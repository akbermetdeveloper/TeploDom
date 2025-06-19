//
//  AuthorizationTextField.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct AuthorizationTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocusedField: Bool
    var onFocusChange: ((Bool) -> Void)?
    var isSecure: Bool = false
    @State private var isPasswordVisible: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.SFPro.regular16)
                .foregroundColor(Color.App.white)
            
            HStack {
                           SecureInputField(
                               text: $text,
                               isSecure: isSecure && !isPasswordVisible,
                               placeholder: placeholder
                           )
                           .frame(height: 20)

                           if isSecure {
                               
                               Button(action: {
                                   isPasswordVisible.toggle()
                               }) {
                                   Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                       .foregroundColor(.white)
                               }
                           }
                       }
                       .padding(16)
                       .background(
                           RoundedRectangle(cornerRadius: 4)
                               .fill(Color.clear)
                       )
                       .overlay(
                           RoundedRectangle(cornerRadius: 4)
                               .strokeBorder(Color(hex: "#A6C549"), lineWidth: 1)
                       )
                   }
               }
           }


#Preview {
    AuthorizationTextField(
    title: "Email",
    placeholder: "Enter your email",
    text: .constant("")
  )
  .padding()
  .background(Color.black)
}

struct SecureInputField: UIViewRepresentable {
    @Binding var text: String
    var isSecure: Bool
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
            textField.isSecureTextEntry = isSecure
            // Сделать плейсхолдер белого цвета с прозрачностью 0.7
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.7)
                ])
            textField.textColor = .white
            textField.borderStyle = .none
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.delegate = context.coordinator
            return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.isSecureTextEntry != isSecure {
            let wasFirstResponder = uiView.isFirstResponder
            uiView.resignFirstResponder()
            uiView.isSecureTextEntry = isSecure
            if wasFirstResponder {
                uiView.becomeFirstResponder()
            }
            
            uiView.attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        .foregroundColor: UIColor.white.withAlphaComponent(0.7)
                    ])
            
            // Prevent loop of updates
            if uiView.text != text {
                uiView.text = text
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}
