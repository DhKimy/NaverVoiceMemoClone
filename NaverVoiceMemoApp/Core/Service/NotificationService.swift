//
//  NotificationService.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/13/24.
//

import UserNotifications

/**
 음성 메모도 따로 객체로 빼서 서비스로 구현하고, ViewModel에 주입할 수 있다.
*/
struct NotificationService {

    func sendNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )

                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

/**
 컴플리션 핸들러를 받기 위한 Delegate
 */
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
