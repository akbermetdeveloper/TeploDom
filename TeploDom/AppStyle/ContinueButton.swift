//
//  ContinueButton.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct ContinueButton: View {
    @EnvironmentObject var iapViewModel: IAPViewModel
    @ObservedObject var subViewModel: SubViewModel

    var body: some View {
        Group {
            Button(action: {
                subViewModel.switchToNextPage()
            }) {
                ZStack {
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
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContinueButton(subViewModel: SubViewModel())
        .environmentObject(IAPViewModel())
}

//@ViewBuilder
//func frostedGlassBackground() -> some View {
//    ZStack {
//        BlurView(style: .systemUltraThinMaterial) // фон с blur
//        Color(hex: "#1E2E3F").opacity(0.5) // полупрозрачный цвет
//    }
//    .cornerRadius(16)
//    .shadow(color: Color.white.opacity(0.1), radius: 64, x: 0, y: 0)
//}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
