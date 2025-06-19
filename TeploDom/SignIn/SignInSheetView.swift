//
//  SignInSheetView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    //@State private var isNavigatingToSignInWithEmail: Bool = false
    @State private var showLoginScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack(spacing: 26) {
                    
                    Spacer().frame(height: 5)
                    //Color.clear.frame(width: 24)
                    ZStack {
                        HStack() {
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.SFPro.regular24)
                            }
                            Spacer()
                        }
                        
                        Text("Авторизоваться")
                            .font(.SFPro.semiBold24)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        //Color.clear.frame(width: 24)
                        
                    }
                    .padding(.horizontal, 12)
                    
                    
                    Text("Свяжите своё жилище\nс теплосетями")
                        .font(.SFPro.medium20)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                        .frame(maxWidth: .infinity)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 12)
                    
                   // Spacer()
                    
                    ZStack {
                        
                        Image("Frame3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 24) {
                        
                        Button {
                            showLoginScreen = true
                        } label: {
                            HStack {
                                Spacer()
                                HStack(spacing: 12) {
                                    Image("Lock-3")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                    
                                    
                                    Text("По лицевому счету")
                                        .font(.SFPro.medium18)
                                        .foregroundColor(.white)
                                    
                                }
                                Spacer()
                            }
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
                        
                        
                    }
                    
                    VStack(spacing: 24) {
                        
                        HStack {
                            Line()
                        }
                        .padding(.horizontal, 24)
                        
                        
//                        SignInWithAppleButton(
//                            onRequest: authViewModel.handleSignInWithAppleRequest,
//                            onCompletion: authViewModel.handleSignInWithAppleCompletion
//                        )
//                        .signInWithAppleButtonStyle(.white)
//                        .frame(height: 56)
//                        .cornerRadius(16)
//                        .padding(.horizontal, 24)
                    }
                    
                }
                .padding(.bottom, 50)
//                .frame(alignment: .top)
//                .ignoresSafeArea(.container, edges: .top)
                if authViewModel.isLoading {
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                                .frame(width: 50, height: 50)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        }
                        .padding(.top, 16)
                        Spacer()
                    }
                }
                
                
            }
            .navigationDestination(isPresented: $showLoginScreen) {
                SignInWithAccountView()
                //SignInWithEmailView()
                
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
    
    
}


struct Line: View {
  var body: some View {
    Rectangle()
          .fill(Color.white)
      .frame(height: 2)
  }
}

struct CustomProgressView: View {
  var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.black.opacity(0.7))
          .frame(width: 50, height: 50)
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .black))
          .frame(width: 50, height: 50)
      }
  }
}

#Preview{
    SignInSheetView()
}

private func safeAreaTop() -> CGFloat {
  (UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .first?.windows.first?.safeAreaInsets.top) ?? 0
}
