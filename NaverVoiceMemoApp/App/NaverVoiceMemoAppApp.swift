//
//  NaverVoiceMemoAppApp.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import SwiftUI

@main
struct NaverVoiceMemoAppApp: App {

    // SwiftUI 코드에서 AppDelegate를 사용하기 위해 필요한 변수. 진입점에서 한 번만 선언해야 함
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
