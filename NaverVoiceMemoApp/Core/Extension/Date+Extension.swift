//
//  Date+Extension.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import Foundation

extension Date {

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }

    var formattedDay: String {
        let now = Date()
        let calendar = Calendar.current

        let nowStartOfDay = calendar.startOfDay(for: now)
        let dateStartOfDay = calendar.startOfDay(for: self)
        let numOfDayDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day

        if let numOfDayDifference = numOfDayDifference, numOfDayDifference == 0 {
            return "오늘"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
}
