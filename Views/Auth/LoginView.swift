import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var userName = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            TextField("Username", text: $userName)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom)
            }
            
            Button {
                authVM.login(userName: userName, password: password)
                if authVM.currentUser == nil {
                    showError = true
                    errorMessage = "Invalid credentials."
                }
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
