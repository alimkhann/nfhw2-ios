import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userName = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(.roundedBorder)
            TextField("Last Name", text: $lastName)
                .textFieldStyle(.roundedBorder)
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
                let user = UserModel(firstName: firstName, lastName: lastName, userName: userName, password: password)
                let beforeCount = authVM.users.count
                authVM.register(user: user)
                if authVM.users.count == beforeCount {
                    showError = true
                    errorMessage = "Username already taken."
                }
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    RegistrationView().environmentObject(AuthViewModel())
}
