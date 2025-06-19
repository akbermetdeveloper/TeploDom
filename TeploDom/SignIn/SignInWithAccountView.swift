import SwiftUI

struct SignInWithAccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var accountNumber: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    
    @State private var isLoggedIn = false

    enum Field {
        case account, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
//                    .onTapGesture {
//                        UIApplication.shared.dismissKeyboard()
//                    }

                VStack(alignment: .leading, spacing: 24) {
                    ScrollView {
                        VStack(spacing: 24) {
                            AuthorizationTextField(
                                title: "Лицевой счёт",
                                placeholder: "Введите лицевой счёт",
                                text: $accountNumber
                            )
                            .focused($focusedField, equals: .account)

                            AuthorizationTextField(
                                title: "Пароль",
                                placeholder: "Введите пароль",
                                text: $password,
                                isSecure: true
                            )
                            .focused($focusedField, equals: .password)
                        }
                        .padding(.top, 40)
                    }

                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .font(.SFPro.regular14)
                            .foregroundColor(.App.red)
                            .padding(.top, 8)
                    }

                    Button {
                        Task {
                            focusedField = nil
                            let success = await authViewModel.signIn(accountNumber: accountNumber, password: password)
                            if success {
                                isLoggedIn = true
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black.opacity(0.6))
                                .frame(height: 56)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white.opacity(0.8), lineWidth: 0.1)
                                )
                                .shadow(color: .white.opacity(0.3), radius: 10)

                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Войти")
                                    .font(.SFPro.medium18)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 360)
                    }
                    NavigationLink(destination: MainTabContainer(subViewModel: SubViewModel()), isActive: $isLoggedIn) {
                                EmptyView()
                            }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: .constant(authViewModel.isAuthenticated)) {
                MainTabContainer(subViewModel: SubViewModel())
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Авторизация")
                        .font(.SFPro.regular20)
                        .foregroundColor(.App.white)
                        .padding()
                }
            }
        }
    }
}

