import SwiftUI

struct TodoRowView: View {
    let todo: TodoModel
    let isDeleteMode: Bool
    let isSelected: Bool
    
    // callbacks:
    let onToggleCompletion: (TodoModel) -> Void
    let onToggleSelection: (UUID) -> Void
    
    var body: some View {
        HStack {
            // in delete-mode, show a tappable circle
            if isDeleteMode {
                Image(systemName: isSelected
                      ? "checkmark.circle.fill"
                      : "circle")
                .foregroundColor(.red)
                .onTapGesture {
                    onToggleSelection(todo.id)
                }
            }
            
            // title with strike-through if completed
            Text(todo.title)
                .strikethrough(todo.isCompleted)
            
            Spacer()
            
            // always show a Toggle for “completed”—but disable it in delete-mode:
            Toggle("", isOn: Binding(
                get: { todo.isCompleted },
                set: { _ in onToggleCompletion(todo) }
            ))
            .labelsHidden()
            .disabled(isDeleteMode)
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        // row itself is tapped while in delete-mode -> flip its selection
        .onTapGesture {
            if isDeleteMode {
                onToggleSelection(todo.id)
            }
        }
    }
}
