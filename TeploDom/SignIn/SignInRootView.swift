//
//  SignInRootView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct SignInRootView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @State private var isShowingSignInSheet: Bool = false
  @State private var navigatingToCreateProfileView: Bool = false
  @State private var navigatingToJoinCircle: Bool = false

  var body: some View {
    NavigationStack {
      ZStack {
        BackgroundView()
        VStack(spacing: 0) {
            
            VStack(spacing: 28) {
                Text("Добро пожаловать!")
                    .font(.SFPro.bold32)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color( "NewColor"), Color("SecondColor")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                Text("💧Учет горячей воды —\nлегко и понятно")
                    .font(.SFPro.regular20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
          }
          .padding(.top, 64)

          
          Spacer()
          ZStack {

            Image("Frame3")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 320, height: 320)
              .foregroundColor(.black)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
          }
          .padding(.top, 80)
            
          Spacer()
          
          VStack(spacing: 16) {
              Spacer()
            Button(action: {
                isShowingSignInSheet = true
            }) {
                Text("Продолжить")
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
            .padding(.horizontal)
          }
          Spacer()

          
//          HStack(spacing: 4) {
//            Text("Already have an account?")
//              .font(.League.regular16)
//              .foregroundColor(.App.white)
//
//            Button(action: {
//              isShowingSignInSheet = true
//                for family in UIFont.familyNames {
//                    print("Family: \(family)")
//                    for name in UIFont.fontNames(forFamilyName: family) {
//                        print("  Font: \(name)")
//                    }
//                }
//
//            }) {
//              Text("Sign In")
//                .font(.League.medium16)
//                .foregroundColor(.App.yellow)
//            }
//          }
//          .padding(.bottom, 16)
        }
      }
      .navigationDestination(isPresented: $isShowingSignInSheet) {
          SignInSheetView()
      }
    }
  }
}

#Preview {
  SignInRootView()
}

