//
//  MemoListView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import SwiftUI

struct MemoListView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            if !memoListViewModel.memos.isEmpty {
                CustomNavigationBar(
                    isDisplayLeftButton: false,
                    rightButtonAction: {
                        memoListViewModel.navigationRightButtonTapped()
                    },
                    rightButtonType: memoListViewModel.navigationBarRightButtonMode
                )
            } else {
                Spacer()
                    .frame(height: 30)
            }

            // 타이틀 뷰
            MemoTitleView()

            // 안내뷰 || 메모 컨텐츠뷰
            if memoListViewModel.memos.isEmpty {
                MemoAnnounceView()
            } else {
                MemoContentView()
                    .padding(.top, 20)
            }
        }
        .writeButton(
            perform: { pathModel.paths.append(.memoView(isCreateMode: true, memo: nil)) },
            imageName: "writeBtn"
        )
        .alert(
            "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
            isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
        ) {
            Button("삭제", role: .destructive) {
                memoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) { }
        }
        .onChange(
            of: memoListViewModel.memos,
            perform: { memos in
                homeViewModel.setMemoCount(memos.count)
            }
        )
    }
}

// MARK: - Title View
private struct MemoTitleView: View {

    @EnvironmentObject private var memoListViewModel: MemoListViewModel

    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
                Text("메모를\n추가해보세요!")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }

            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - 안내 View
private struct MemoAnnounceView: View {

    @EnvironmentObject private var memoListViewModel: MemoListViewModel

    fileprivate var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image("pencil")
                .renderingMode(.template)

            Text("\"퇴근 9시간 전 메모\"")
            Text("\"개발 끝낸 후 퇴근하기\"")
            Text("\"밀린 알고리즘 공부하기!\"")

            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.customGray2)
    }
}

// MARK: - 컨텐츠 View
private struct MemoContentView: View {

    @EnvironmentObject private var memoListViewModel: MemoListViewModel

    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)

                Spacer()
            }

            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.custoGray0)
                        .frame(height: 1)

                    ForEach(memoListViewModel.memos, id: \.self) { memo in
                        // 메모 셀 뷰 호출
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

// MARK: - 메모 셀 뷰
private struct MemoCellView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo

    fileprivate init(
        isRemoveSelected: Bool = false,
        memo: Memo)
    {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }

    fileprivate var body: some View {
        Button(action: {
            pathModel.paths.append(.memoView(isCreateMode: false, memo: memo))
        }) {
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(memo.title)
                            .lineLimit(1)
                            .font(.system(size: 16))
                            .foregroundColor(.custoBlack)

                        Text(memo.convertedDate)
                            .font(.system(size: 12))
                            .foregroundColor(.custoIconGray)
                    }

                    Spacer()

                    if memoListViewModel.isEditMemoMode {
                        Button(action: {
                            isRemoveSelected.toggle()
                            memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                        }) {
                            isRemoveSelected
                            ? Image("selectedBox")
                            : Image("unSelectedBox")
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
        }
    }
}

// MARK: - 플로팅 버튼 View
private struct MemoWriteButtonView: View {

    @EnvironmentObject private var pathModel: PathModel

    fileprivate var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    pathModel.paths.append(.memoView(isCreateMode: true, memo: nil))
                }) {
                    Image("writeBtn")
                }
            }
        }
    }
}

#Preview {
    MemoListView()
        .environmentObject(PathModel())
        .environmentObject(MemoListViewModel())
}
