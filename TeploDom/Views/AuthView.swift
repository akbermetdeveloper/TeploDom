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
        
        VStack(spacing: 20) {
            
            Text("Добавить аккаунт")
                .font(.title)
                .bold()
            
            TextField("Лицевой счёт", text: $accountNumber)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Пароль", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button {
                Task {
                    let success = await authVM.signIn(accountNumber: accountNumber, password: password)
                    if success {
                        onAuthSuccess(accountNumber)
                        dismiss()
                    }
                }
            } label: {
                Text("Войти")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let error = authVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
