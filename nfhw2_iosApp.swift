import SwiftUI

@main
struct nfhw2_iosApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.currentUser == nil {
                    AuthView()
                        .environmentObject(authVM)
                } else {
                    TabBarView()
                        .environmentObject(authVM)
                }
            }
        }
    }
}
