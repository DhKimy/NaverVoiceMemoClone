//
//  SettingView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/13/24.
//

import SwiftUI

struct SettingView: View {

    var body: some View {
        VStack {
            // 타이틀
            TitleView()

            Spacer()
                .frame(height: 35)
            
            // 총 탭 카운트
            TotalTabCountView()

            Spacer()
                .frame(height: 45)

            // 탭 무브
            TotalTabMoveView()

            Spacer()
        }
    }
}

// MARK: - Title
private struct TitleView: View {

    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.custoBlack)

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - 설정된 카운트 뷰
private struct TotalTabCountView: View {

    fileprivate var body: some View {
        HStack{
            Spacer()

            TabCountView(title: "To do", count: 1)

            Spacer()

            TabCountView(title: "메모", count: 2)

            Spacer()

            TabCountView(title: "음성메모", count: 3)

            Spacer()
        }
    }
}

// MARK: - 공통 뷰 컴포넌트
private struct TabCountView: View {

    private var title: String
    private var count: Int

    fileprivate init(title: String, count: Int) {
        self.title = title
        self.count = count
    }

    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.custoBlack)

            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.custoBlack)
        }
    }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {

    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.custoGray1)
                .frame(height: 1)

            TabMoveView(title: "To do List", tabAction: { })
            TabMoveView(title: "메모장", tabAction: { })
            TabMoveView(title: "음성메모", tabAction: { })
            TabMoveView(title: "타이머", tabAction: { })

            Rectangle()
                .fill(Color.custoGray1)
                .frame(height: 1)
        }
    }
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {

    private var title: String
    private var tabAction: () -> Void

    fileprivate init(title: String, tabAction: @escaping () -> Void) {
        self.title = title
        self.tabAction = tabAction
    }

    fileprivate var body: some View {
        Button(action: tabAction) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.custoBlack)

                Spacer()

                Image("arrowRight")
            }
        }
        .padding(.all, 20)
    }
}

#Preview {
    SettingView()
}
