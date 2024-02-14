//
//  WriteButton.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/15/24.
//

import SwiftUI

/**
 ZStack {
     // TODO: - todo cell list
     VStack {
         if todoListViewModel.todos.isEmpty {
             CustomNavigationBar(
                 isDisplayLeftButton: false,
                 rightButtonAction: {
                     todoListViewModel.navigationRightButtonTapped()
                 },
                 rightButtonType: todoListViewModel.navigationBarRightButtonMode
             )
         } else {
             Spacer()
                 .frame(height: 30)
         }

         TitleView()
             .padding(.top, 20)

         if todoListViewModel.todos.isEmpty {
             AnnouncementView()
         } else {
             TodoListContentView()
                 .padding(.top, 20)
         }
     }

     WriteTodoButtonView()
         .padding(.trailing, 20)
         .padding(.bottom, 50)
 }
 이것을 대체하는 모디파이어
 */
// MARK: Sol 1
public struct WriteButtonViewModifier: ViewModifier {

    let action: () -> Void
    let imageName: String

    public init(action: @escaping () -> Void, imageName: String) {
        self.action = action
        self.imageName = imageName
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: action) {
                        Image(imageName)
                    }
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
}

// MARK: sol 2
extension View {
    public func writeButton(perform action: @escaping () -> Void, imageName: String) -> some View {
        ZStack {
            self

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: action) {
                        Image(imageName)
                    }
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
}

// MARK: - Sol 3
public struct WriteButtonView<Content: View>: View {

    let content: Content
    let action: () -> Void
    let imageName: String

    public init(
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void,
        imageName: String
    ) {
        self.content = content()
        self.action = action
        self.imageName = imageName
    }

    public var body: some View {
        ZStack {
            content

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: action) {
                        Image(imageName)
                    }
                }
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
}
