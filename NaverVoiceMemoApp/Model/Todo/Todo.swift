//
//  Todo.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import Foundation

struct Todo: Hashable {

    var title: String
    var time: Date
    var day: Date
    var selected: Bool

    var convertedDayAndTime: String {
        // ex. 오늘 - 오후 3시에 알림
        String("\(day.formattedDay) - \(time.formattedTime)에 알림")
    }
}
