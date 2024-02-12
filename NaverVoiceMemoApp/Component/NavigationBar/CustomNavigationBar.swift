//
//  CustomNavigationBar.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import SwiftUI

struct CustomNavigationBar: View {

    let isDisplayLeftButton: Bool
    let isDisplayRightButton: Bool
    let leftButtonAction: () -> Void
    let rightButtonAction: () -> Void
    let rightButtonType: NavigationButtonType

    init(
        isDisplayLeftButton: Bool = true,
        isDisplayRightButton: Bool = true,
        leftButtonAction: @escaping () -> Void = {},
        rightButtonAction: @escaping () -> Void = {},
        rightButtonType: NavigationButtonType = .edit
    ) {
        self.isDisplayLeftButton = isDisplayLeftButton
        self.isDisplayRightButton = isDisplayRightButton
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction
        self.rightButtonType = rightButtonType
    }

    var body: some View {
        HStack {
            if isDisplayLeftButton {
                Button(action: leftButtonAction) {
                    Image("leftArrow")
                }
            }

            Spacer()

            if isDisplayRightButton {
                Button(action: rightButtonAction) {
                    if rightButtonType == .close {
                        Image("close")
                    } else {
                        Text(rightButtonType.rawValue)
                            .foregroundColor(.custoBlack)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

// MARK: - Preview
struct CustomNavigationBar_Previews: PreviewProvider {

    static var previews: some View {
        CustomNavigationBar()
    }
}
