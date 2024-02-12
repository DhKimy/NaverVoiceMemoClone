//
//  MemoView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import SwiftUI

struct MemoView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel: MemoViewModel
    @State var isCreateMode: Bool = true

    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    leftButtonAction: {
                        pathModel.paths.removeLast()
                    },
                    rightButtonAction: {
                        if isCreateMode {
                            memoListViewModel.addMemo(memoViewModel.memo)
                        } else {
                            memoListViewModel.updateMemo(memoViewModel.memo)
                        }
                    },
                    rightButtonType: isCreateMode ? .create : .complete
                )

                // 메모 타이틀 인풋 뷰
                MemoTitleInputView(
                    memoViewModel: memoViewModel,
                    isCreateMode: $isCreateMode
                )
                .padding(.top, 20)

                // 메모 컨턴츠 인풋 뷰
                MemoContentInputView(memoViewModel: memoViewModel)


            }
            // 삭제 플로팅 버튼 뷰
            if isCreateMode {
                MemoDeleteButtonView(memoViewModel: memoViewModel)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - 메모 타이틀 인풋 뷰
private struct MemoTitleInputView: View {

    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFiledFocused: Bool
    @Binding private var isCreateMode: Bool

    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreateMode: Binding<Bool>
    ) {
        self.memoViewModel = memoViewModel
        self._isCreateMode = isCreateMode
    }

    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요.",
            text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal, 20)
        .focused($isTitleFiledFocused)
        .onAppear {
            if isCreateMode {
                isTitleFiledFocused = true
            }
        }
    }
}

// MARK: - 메모 컨텐츠 인풋 뷰
private struct MemoContentInputView: View {

    @ObservedObject private var memoViewModel: MemoViewModel

    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }

    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))

            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요")
                    .font(.system(size: 16))
                    .foregroundColor(.custoGray1)
                    .allowsHitTesting(false)
                    .padding(.top, 10)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, 10)
    }
}

// MARK: - 삭제 플로팅 버튼 뷰
private struct MemoDeleteButtonView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @ObservedObject private var memoViewModel: MemoViewModel

    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }

    fileprivate var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    memoListViewModel.removeMemo(memoViewModel.memo)
                    pathModel.paths.removeLast()
                }) {
                    Image("trash")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
    }
}

#Preview {
    MemoView(
        memoViewModel: .init(
            memo: .init(
                title: "",
                content: "",
                date: Date()
            )
        )
    )
}
