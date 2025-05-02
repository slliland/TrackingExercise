import SwiftUI

struct ProfileView: View {
    // Use the shared AuthenticationViewModel from the environment.
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    // Get the SwiftData ModelContext from the environment.
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 20) {
            if let user = authViewModel.currentUser {
                // User is logged in.
                VStack(spacing: 16) {
                    Text("Welcome, \(user.username)!")
                        .font(.title)
                        .bold()
                    
                    // Editable toggle for Remember Me
                    Toggle("Remember Me", isOn: Binding(
                        get: { user.rememberMe },
                        set: { newValue in
                            user.rememberMe = newValue
                        }
                    ))
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            } else {
                // No user is logged in: show the login/registration form.
                VStack(spacing: 16) {
                    Text("Please Log In")
                        .font(.title)
                        .bold()
                    
                    TextField("Username", text: $authViewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $authViewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Toggle("Remember Me", isOn: $authViewModel.rememberMe)
                        .padding(.horizontal)
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            authViewModel.login()
                        }) {
                            Text("Log In")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            authViewModel.register()
                        }) {
                            Text("Register")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            Spacer()
        }
        .navigationTitle("Profile")
        .onAppear {
            // Inject the ModelContext into the authentication view model.
            authViewModel.modelContext = modelContext
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
    .previewDisplayName("Profile View")
}

