import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: TodoViewModel

    @State private var showingAddAlert = false
    @State private var newTitle = ""

    @State private var isDeleteMode = false
    @State private var selectedIDs: Set<UUID> = []

    init(viewModel: TodoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.todos, id: \TodoModel.id) { (todo: TodoModel) in
                        let completionBinding = Binding<Bool>(
                            get: { todo.isCompleted },
                            set: { _ in
                                viewModel.toggleTodoCompletion(of: todo)
                            }
                        )
                        
                        HStack {
                            if isDeleteMode {
                                Image(systemName: selectedIDs.contains(todo.id)
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    toggleSelection(todo.id)
                                }
                            }
                            
                            Text(todo.title)
                                .strikethrough(todo.isCompleted)
                            
                            Spacer()
                            
                            Toggle("", isOn: completionBinding)
                                .labelsHidden()
                                .disabled(isDeleteMode)
                        }
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if isDeleteMode {
                                toggleSelection(todo.id)
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 12) {
                Button {
                    showingAddAlert = true
                } label: {
                    Text("Add Todo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: deleteButtonTapped) {
                    Text(isDeleteMode
                         ? "Confirm Deletion"
                         : "Delete Todo")
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom, 24)
            .padding(.horizontal)
        }
        .navigationTitle("Todosss")
        .alert(
            "New Todo",
            isPresented: $showingAddAlert,
            actions: {
                TextField("Title", text: $newTitle)
                Button("Add") {
                    let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        viewModel.addTodo(title: trimmed)
                        newTitle = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    newTitle = ""
                }
            },
            message: { Text("Enter a title for your todo") }
        )
    }

    // MARK: – Helpers
    private func toggleSelection(_ id: UUID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }
    private func deleteButtonTapped() {
        if isDeleteMode {
            if selectedIDs.isEmpty {
                isDeleteMode = false
            } else {
                viewModel.removeTodos(idsToRemove: selectedIDs)
                selectedIDs.removeAll()
                isDeleteMode = false
            }
        } else {
            isDeleteMode = true
        }
    }
}

#Preview {
    HomeView(viewModel: .init(ownerUsername: "test"))
}
