//
//  AppDelegate.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import UIKit

/**
 SwiftUI 개발 시 Low Level 개발이 필요한 경우 구현 가능
 */
class AppDelegate: NSObject, UIApplicationDelegate {

    var notificationDelegate = NotificationDelegate()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
