import SwiftUI

struct AuthView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("authViewBackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(1), location: 0),
                                    .init(color: Color.white.opacity(0.8), location: 0.2),
                                    .init(color: .clear,          location: 0.4)
                                ]),
                                startPoint: .top,
                                endPoint: UnitPoint(x: 0.5, y: 0.6)
                            )

                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear,                 location: 0.6),
                                    .init(color: Color.white.opacity(0.8), location: 0.8),
                                    .init(color: Color.white.opacity(1),   location: 1)
                                ]),
                                startPoint: UnitPoint(x: 0.5, y: 0.8),
                                endPoint: .bottom
                            )
                        }
                    )
                    .ignoresSafeArea()
                
                VStack {
                    NavigationLink(destination: RegistrationView()) {
                        Text("Get Started")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("I already have an account")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(24)
            }
            .navigationTitle("todosss")
        }
    }
}

#Preview {
    NavigationStack {
        AuthView()
    }
}
