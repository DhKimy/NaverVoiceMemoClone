//
//  MemoViewModel.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import Foundation

class MemoViewModel: ObservableObject {

    @Published var memo: Memo

    init(memo: Memo) {
        self.memo = memo
    }
}
