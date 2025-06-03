import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = authVM.currentUser {
                Image("profilePicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 256, height: 256)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .shadow(radius: 8)
                
                Text("""
                     I’m a CS student at CityU who’s really into building iOS apps and clean, user-friendly stuff. I enjoy turning ideas into working products—especially if they solve real problems.
                     """)
                .font(.body)
                .fontDesign(.rounded)
                .lineSpacing(4)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Text("First Name: \(user.firstName)")
                Text("Last Name: \(user.lastName)")
                Text("Username: \(user.userName)")
                
                Button {
                    authVM.logout()
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
            } else {
                Text("No user data.")
            }
        }
        .padding()
        .navigationTitle("Profile")
    }
}
