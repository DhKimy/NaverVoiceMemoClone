//
//  Double+Extension.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import Foundation

extension Double {

    // 03:05
    var formattedTimeInterval: String {
        let totalSecond = Int(self)
        let second = totalSecond % 60
        let minutes = (totalSecond / 60) % 60

        return String(format: "%02d:%02d", minutes, second)
    }
}
