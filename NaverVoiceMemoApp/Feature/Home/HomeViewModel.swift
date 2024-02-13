//
//  HomeViewModel.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/13/24.
//

import Foundation

final class HomeViewModel: ObservableObject {

    @Published var selectedTab: Tab
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceRecorderCount: Int

    init(
        selectedTab: Tab = .voiceRecorder,
        todosCount: Int = 0,
        memosCount: Int = 0,
        voiceRecorderCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceRecorderCount = voiceRecorderCount
    }
}

extension HomeViewModel {
    // 각 count 개수를 변경해주는 메서드
    func setTodosCount(_ count: Int) {
        todosCount = count
    }

    func setMemoCount(_ count: Int) {
        memosCount = count
    }

    func setVoiceRecorderCount(_ count: Int) {
        voiceRecorderCount = count
    }

    // Tab 변경 메서드
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
