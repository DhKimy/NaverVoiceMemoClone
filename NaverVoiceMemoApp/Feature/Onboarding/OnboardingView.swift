//
//  OnboardingView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import SwiftUI

struct OnboardingView: View {

    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()

    var body: some View {
        NavigationStack(path: $pathModel.paths) {
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
            MemoListView()
                .environmentObject(memoListViewModel)
                .navigationDestination(
                    for: PathType.self,
                    destination: { pathType in
                        switch pathType {
                        case .homeView:
                            HomeView()
                                .navigationBarBackButtonHidden()
                        case .todoView:
                            TodoView()
                                .navigationBarBackButtonHidden()
                                .environmentObject(todoListViewModel)
                        case let .memoView(isCreateMode, memo):
                            MemoView(
                                memoViewModel: isCreateMode
                                ? .init(memo: .init(title: "", content: "", date: .now))
                                : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                                isCreateMode: isCreateMode
                            )
                            .navigationBarBackButtonHidden()
                            .environmentObject(memoListViewModel)
                        }
                    }
                )
        }
        .environmentObject(pathModel)
    }
}

// MARK: - Onboarding ContentView
private struct OnboardingContentView: View {

    @ObservedObject private var onboardingViewModel: OnboardingViewModel

    // 온보딩뷰에서 사용하기 위해 fileprivate으로 선언(파일 내 한정 사용)
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }

    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            Spacer()
            // 시작 버튼 뷰
            StartButtonView()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - Onboarding Cell List View
private struct OnboardingCellListView: View {

    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int

    fileprivate init(onboardingViewModel: OnboardingViewModel, selectedIndex: Int = 0) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }

    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onboardingContent.enumerated()), id: \.element) { index, onboardingConent in
                OnboardingCellView(onboardingContent: onboardingConent)
                    .tag(index)

            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0
            ? Color.custoSky
            : Color.custoBackgroundGreen
        )
        .clipped() // 탭 뷰 구성시 잘리는 부분이 있을 수도 있기 때문에 clipped
    }
}

// MARK: - Onboarding Cell View
private struct OnboardingCellView: View {

    private var onboardingContent: OnboardingContent

    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }

    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()

            HStack {
                Spacer()

                VStack {
                    Spacer()
                        .frame(height: 24)

                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))

                    Spacer()
                        .frame(height: 5)

                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }

                Spacer()
            }
            .background(Color.custoWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

// MARK: - Start Button View
private struct StartButtonView: View {

    // NavigationStack에서 전역적으로 EnvironmentObject 전달한 것을 구현
    @EnvironmentObject private var pathModel: PathModel

    fileprivate var body: some View {
        Button(action: {
            pathModel.paths.append(.homeView)
        }, label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))

                Image("startHome")
                    .renderingMode(.template)
            }
            .foregroundColor(.custoGreen)
        })
        .padding(.bottom, 50)
    }
}

// MARK: - Preview
struct OnboardingView_Preview: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
