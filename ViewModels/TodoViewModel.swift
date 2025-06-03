import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [TodoModel] = [] {
        didSet {
            debugPrint("📝 [TodoViewModel] Todos changed for 👤\(owner):", todos)
            persistTodos()
        }
    }
    private let owner: String
    private let todosKey: String

    init(ownerUsername: String) {
        self.owner = ownerUsername
        self.todosKey = "todos_\(ownerUsername)"
        self.todos = loadTodos()
        debugPrint("📥 [TodoViewModel] Loaded todos for 👤\(owner):", todos)
    }

    func addTodo(title: String) {
        todos.append(
            TodoModel(id: UUID(), title: title, isCompleted: false)
        )
        debugPrint("➕ [TodoViewModel] Added todo for 👤\(owner):", title)
    }

    func removeTodos(idsToRemove: Set<UUID>) {
        let beforeCount = todos.count
        todos.removeAll { idsToRemove.contains($0.id) }
        debugPrint("➖ [TodoViewModel] Removed \(beforeCount - todos.count) todos for 👤\(owner)")
    }

    func toggleTodoCompletion(of todo: TodoModel) {
        for (i, t) in todos.enumerated() where t.id == todo.id {
            todos[i].isCompleted.toggle()
            debugPrint("🔄 [TodoViewModel] Toggled completion for todo \(todo.id) for 👤\(owner)")
            return
        }
    }

    private func loadTodos() -> [TodoModel] {
        guard
            let data = UserDefaults.standard.data(forKey: todosKey),
            let decoded = try? JSONDecoder().decode([TodoModel].self, from: data)
        else {
            debugPrint("⚠️ [TodoViewModel] No todos found for 👤\(owner)")
            return []
        }
        return decoded
    }

    private func persistTodos() {
        guard let data = try? JSONEncoder().encode(todos) else {
            debugPrint("⚠️ [TodoViewModel] Failed to encode todos for 👤\(owner)")
            return
        }
        UserDefaults.standard.set(data, forKey: todosKey)
        debugPrint("💾 [TodoViewModel] Persisted todos for 👤\(owner)")
    }
}
