import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            NavigationStack {
                if let user = authVM.currentUser {
                    HomeView(viewModel: TodoViewModel(ownerUsername: user.userName))
                } else {
                    Text("No user logged in.")
                }
            }
            .tabItem {
                Label("Home", systemImage: "list.bullet")
            }
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    let mockAuthVM = AuthViewModel()
    let user = UserModel(firstName: "Test1", lastName: "Test2", userName: "test3", password: "password")
    mockAuthVM.users = [user]
    mockAuthVM.currentUser = user
    return TabBarView().environmentObject(mockAuthVM)
}
