//
//  SubView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct SubView: View {
    @EnvironmentObject var iapViewModel: IAPViewModel
    @ObservedObject var subViewModel: SubViewModel
    @Binding var showSubview: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showPermissionsScreen = false
    @State private var showMainScreen = false
    
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                if subViewModel.isSpecial {
                    //specialPaywallUI(geo)
                } else {
                    contentView()
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func contentView() -> some View {
        ZStack {
            
            subViewModel.currentItem.backgroundView
            
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 28/255, green: 36/255, blue: 45/255).opacity(1.0))
                        .blur(radius: 0.2)
                        //.clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.white.opacity(0.1), radius: 64, x: 0, y: 0)
                        .frame(height: 340)
                        .edgesIgnoringSafeArea(.bottom)
                    
                        .overlay {
                            VStack(spacing: 0) {
                                Color.clear
                                    .frame(height: 10)
                                    .frame(maxWidth: .infinity)
                                VStack(spacing: 0) {
                                    //Spacer().frame(height: 10)
                                    Text(subViewModel.currentItem.title)
                                        .font(.SFPro.bold24)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                        .frame(maxWidth: .infinity)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(.clear)
                                        .overlay(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color("NewColor"),
                                                    Color("SecondColor")
                                                ]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .mask(
                                            Text(subViewModel.currentItem.title)
                                                .font(.SFPro.bold24)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                        )
                                    //.padding(.horizontal, 20)
                                    
                                    Spacer().frame(height: 10)
                                    
                                    VStack {
                                        
                                        Text(subViewModel.currentItem.description)
                                            .font(.SFPro.regular18)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth: .infinity)
                                            .lineLimit(3)
                                            .fixedSize(horizontal: true, vertical: true)
                                        
                                    }
                                    
                                    Spacer().frame(height: 20)
                                    
                                    ContinueButton(iapViewModel: _iapViewModel, subViewModel: subViewModel)
                                        .frame(height: 60)
                                }
                                
//                                footer
//                                    //.opacity(isPaywall ? 1 : 0)
//                                    .allowsHitTesting(subViewModel)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 55)
                        }
                }
                .frame(width: .infinity)
            }
        }
    }
    
    
    
    
}

