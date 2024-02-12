//
//  TodoView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import SwiftUI

struct TodoView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()

    var body: some View {
        VStack {
            CustomNavigationBar(
                leftButtonAction: {
                    pathModel.paths.removeLast()
                },
                rightButtonAction:  {
                    todoListViewModel.addTodo(
                        .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.day,
                            selected: false
                        )
                    )
                    pathModel.paths.removeLast()
                },
                rightButtonType: .create
            )

            // 타이틀 뷰
            TitleView()
                .padding(.top, 20)

            Spacer()
                .frame(height: 20)

            // 투두 타이틀뷰(텍스트필드)
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)

            // 시간 선택
            SelectTimeView(todoViewModel: todoViewModel)

            // 날짜 선택
            SelectDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)

            Spacer()
        }
    }
}

// MARK: - Title View
private struct TitleView: View {

    fileprivate var body: some View {
        HStack {
            Text("To do List를\n추가해주세요.")

            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)

    }
}

// MARK: - Todo Title View(title input view)
private struct TodoTitleView: View {

    // StateObject로 만들어 진것을 할당
    @ObservedObject private var todoViewModel: TodoViewModel

    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }

    fileprivate var body: some View {
        TextField("제목을 입력하세요", text: $todoViewModel.title)
    }
}

// MARK: - 시간 선택 뷰
private struct SelectTimeView: View {

    @ObservedObject private var todoViewModel: TodoViewModel

    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }

    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)

            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)

            Rectangle()
                .fill(.customGray0)
                .frame(height: 1)
        }
    }
}

// MARK: - 날짜 선택 뷰
private struct SelectDayView: View {

    @ObservedObject private var todoViewModel: TodoViewModel

    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }

    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("날짜")
                    .foregroundColor(.custoIconGray)

                Spacer()
            }

            HStack {
                Button(action: {
                    todoViewModel.setIsDisplayCalendar(true)
                }) {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.custoGreen)
                }
                .popover(isPresented: $todoViewModel.isDisplayCalendar) {
                    DatePicker(
                        "",
                        selection: $todoViewModel.day,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: todoViewModel.day) {
                        todoViewModel.setIsDisplayCalendar(false)
                    }
                }

                Spacer()
            }

        }
    }
}

#Preview {
    TodoView()
}
