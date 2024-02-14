//
//  TodoListView.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import SwiftUI

struct TodoListView: View {

    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
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
        .modifier(
            WriteButtonViewModifier(
                action: { pathModel.paths.append(.todoView) },
                imageName: "writeBtn"
            )
        )
        .alert(
            "To do List \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeButtonTapped()
            }

            Button("취소", role: .cancel) {
                
            }
        }
        .onChange(of: todoListViewModel.todos) { todos in
            homeViewModel.setTodosCount(todos.count)
        }
    }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {

    @EnvironmentObject private var todoListViewModel: TodoListViewModel

    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do List를\n추가해 보세요!")
            } else {
                Text("To do List \(todoListViewModel.todos.count)개가\n있습니다.")
            }

            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {

    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()

            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")

            Spacer()
        }
        .font(.system(size: 16))
        .foregroundColor(.custogray2)
    }
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {

    @EnvironmentObject private var todoListViewModel: TodoListViewModel

    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할 일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)

                Spacer()
            }

            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.custoGray0)
                        .frame(height: 1)

                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        // todo 셀 뷰 호출하고 todo 넣어서 뷰 호출
                        TodoCellView(todo: todo)

                    }
                }
            }
        }
    }
}

// MARK: - Todo Cell Veiw
private struct TodoCellView: View {

    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo

    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        //
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }

    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button(action: {
                        todoListViewModel.selectedBoxTapped(todo)
                    }) {
                        todo.selected
                        ? Image("selectedBox")
                        : Image("unSelectedBox")
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundColor(todo.selected ? .custoIconGray : .custoBlack)
                        .strikethrough(todo.selected)

                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundColor(.custoIconGray)
                }

                Spacer()

                if todoListViewModel.isEditTodoMode {
                    Button(action: {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    }) {
                        isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)

        Rectangle()
            .fill(.customGray0)
            .frame(height: 1)
    }
}

#Preview {
    TodoListView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
}
