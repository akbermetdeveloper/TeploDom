//
//  PhoneNumberView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

//Task {
//    await authViewModel.checkAccountNumber()
//}


struct PhoneNumberView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var phoneNumber = ""
    @State private var smsCode = ""
    @State private var verificationID: String?
    @State private var isSMSSent = false
    @State private var errorMessage: String?
    @State private var isLoading = false

    @FocusState private var isSMSFieldFocused: Bool
    @State private var secondsRemaining = 0
    @State private var timer: Timer?

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
                                title: "Номер телефона",
                                placeholder: "+996 (___) ___-___",
                                text: $phoneNumber,
                                keyboardType: .phonePad
                            )
                            .disabled(isSMSSent)

                            if isSMSSent {
                                AuthorizationTextField(
                                    title: "Код из SMS",
                                    placeholder: "Введите код",
                                    text: $smsCode,
                                    keyboardType: .numberPad
                                )
                                .focused($isSMSFieldFocused)
                            }
                        }
                        .padding(.top, 40)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                    if let error = errorMessage {
                        Text(error)
                            .font(.SFPro.regular14)
                            .foregroundColor(.App.red)
                            .padding(.top, 8)
                    }

                    Button(action: {
                        Task { await handleAction() }
                    }) {
                        Text(buttonTitle)
                            .font(.SFPro.medium18)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(width: 360, height: 56)
                            .background(Color.black.opacity(0.6))
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 0.1)
                            )
                            .cornerRadius(4)
                            .shadow(color: Color.white.opacity(0.5), radius: 16)
                    }
                    .padding(.top, 8)
                    .disabled(isLoading || (isSMSSent && smsCode.isEmpty) || (!isSMSSent && secondsRemaining > 0))

                    if isSMSSent && secondsRemaining > 0 {
                        Text("Повторная отправка через \(secondsRemaining) сек")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
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

    private var buttonTitle: String {
        if isSMSSent {
            return "Подтвердить код"
        } else {
            return secondsRemaining > 0 ? "Ожидание..." : "Отправить код"
        }
    }

    private func handleAction() async {
        errorMessage = nil
        isLoading = true

        if isSMSSent {
            await verifyCode()
        } else {
            await sendSMSCode()
        }

        isLoading = false
    }

    private func sendSMSCode() async {
        let rawPhone = phoneNumber.onlyDigits()


        let fullPhone = "+996" + rawPhone.dropFirst(3)

        await withCheckedContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(fullPhone, uiDelegate: nil) { id, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.verificationID = id
                    self.isSMSSent = true
                    self.startTimer()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isSMSFieldFocused = true
                    }
                }
                continuation.resume()
            }
        }
    }

    private func verifyCode() async {
        guard let verificationID else {
            errorMessage = "Ошибка идентификатора подтверждения"
            return
        }

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )

        do {
//            Task {
//                await authViewModel.checkAccountNumber()
//            }
            print("Успешный вход")
            // authViewModel.handleLogin()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    private func startTimer() {
        secondsRemaining = 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            secondsRemaining -= 1
            if secondsRemaining == 0 {
                timer?.invalidate()
            }
        }
    }
}

extension String {
    func onlyDigits() -> String {
        return self.filter { $0.isNumber }
    }
}
