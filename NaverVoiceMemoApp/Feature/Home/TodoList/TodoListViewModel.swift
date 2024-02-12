//
//  TodoListViewModel.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/12/24.
//

import Foundation

class TodoListViewModel: ObservableObject {

    @Published var todos: [Todo]
    @Published var isEditTodoMode: Bool
    @Published var removeTodos: [Todo]
    @Published var isDisplayRemoveTodoAlert: Bool

    var removeTodosCount: Int {
        return removeTodos.count
    }

    var navigationBarRightButtonMode: NavigationButtonType {
        isEditTodoMode ? .complete : .edit
    }

    init(
        todos: [Todo] = [],
        isEditTodoMode: Bool = false,
        removeTodos: [Todo] = [],
        isDisplayRemoveTodoAlert: Bool = false
    ) {
        self.todos = todos
        self.isEditTodoMode = isEditTodoMode
        self.removeTodos = removeTodos
        self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
    }
}

extension TodoListViewModel {

    // 박스를 선택할 때, todo에 있는 selected 변수를 토글 시켜줌
    func selectedBoxTapped(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0 == todo}) {
            todos[index].selected.toggle()
        }
    }

    // Todo를 추가함
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }

    // 우측 버튼 역할 부여(편집 모드 진입)
    func navigationRightButtonTapped() {
        if isEditTodoMode {
            if removeTodos.isEmpty {
                isEditTodoMode = false
            } else {
                // Alert 표시
                setIsDisplayRemoveTodoAlert(true)
            }
        } else {
            isEditTodoMode = true
        }
    }

    // Alert을 불러주는 메서드
    private func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
        isDisplayRemoveTodoAlert = isDisplay
    }

    // selectedBox를 체크할 때마다 removeTodos에 배열에서 빼거나 더해준다
    func todoRemoveSelectedBoxTapped(_ todo: Todo) {
        if let index = removeTodos.firstIndex(of: todo) {
            removeTodos.remove(at: index)
        } else {
            removeTodos.append(todo)
        }
    }

    // 전체 todo 중 removeTodos에만 있는 것만 삭제
    func removeButtonTapped() {
        todos.removeAll { todo in
            removeTodos.contains(todo)
        }
        removeTodos.removeAll()
        isEditTodoMode = false
    }
}
