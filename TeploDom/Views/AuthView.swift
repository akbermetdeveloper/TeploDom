//
//  AuthView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel

    @State private var accountNumber: String = ""
    @State private var password: String = ""
    
    var onAuthSuccess: (String) -> Void

    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Text("Добавить аккаунт")
                            .font(.SFPro.semiBold20)
                            .foregroundColor(.white)
                        
                        AuthorizationTextField(title: "Лицевой счет", placeholder: "Введите лицевой счет", text: $accountNumber)
                        
                        AuthorizationTextField(title: "Пароль", placeholder: "Введите пароль", text: $password)
                        
                        
                        
                        Spacer()
                        
                        Button {
                            Task {
                                let success = await authVM.signIn(accountNumber: accountNumber, password: password)
                                if success {
                                    dismiss()
                                    try? await Task.sleep(nanoseconds: 200_000_000)
                                    onAuthSuccess(accountNumber)
                                    
                                }
                            }
                        } label: {
                            Text("Войти")
                                .font(.SFPro.semiBold20)
                                .foregroundColor(Color(hex: "#A6C549"))
                                .frame(width: 370, height: 54)
                                .background(
                                    Color.black.opacity(0.6)
                                        .background(.ultraThinMaterial)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.white.opacity(1.1), lineWidth: 0.1)
                                )
                                .cornerRadius(4)
                                .shadow(color: Color.white.opacity(0.4), radius: 10)
                        }
                    }
                    
                    if let error = authVM.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
        }
    }
}
