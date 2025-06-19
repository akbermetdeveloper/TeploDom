//
//  AppStyle.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

extension Color {
    struct App {
        
        static let black = Color(hex: "#1C1C1E")
        static let darkGray = Color(hex: "#282828")
        static let lightGray = Color(hex: "#BBBBBB")
        static let white = Color(hex: "#F9F9F9")
        static let yellow = Color(hex: "#FCD36A")
        static let lightYellow = Color(hex: "#FEF4DA")
        static let red = Color(hex: "#FF0000")
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Font {
    struct SFPro {
        
        static let bold36 = system(size: 36, weight: .bold)
        static let bold32 = system(size: 32, weight: .bold)
        static let bold30 = system(size: 30, weight: .bold)
        static let bold28 = system(size: 28, weight: .bold)
        static let bold26 = system(size: 26, weight: .bold)
        static let bold24 = system(size: 24, weight: .bold)
        
        static let semiBold26 = system(size: 26, weight: .semibold)
        static let semiBold24 = system(size: 24, weight: .semibold)
        static let semiBold20 = system(size: 20, weight: .semibold)
        static let semiBold18 = system(size: 18, weight: .semibold)
        static let semiBold16 = system(size: 16, weight: .semibold)
        
        static let medium32 = system(size: 32, weight: .medium)
        static let medium24 = system(size: 24, weight: .medium)
        static let medium20 = system(size: 20, weight: .medium)
        static let medium18 = system(size: 18, weight: .medium)
        static let medium16 = system(size: 16, weight: .medium)
        static let medium14 = system(size: 14, weight: .medium)
        static let medium12 = system(size: 12, weight: .medium)
      
        
        static let regular24 = system(size: 24, weight: .regular)
        static let regular20 = system(size: 20, weight: .regular)
        static let regular18 = system(size: 18, weight: .regular)
        static let regular16 = system(size: 16, weight: .regular)
        static let regular14 = system(size: 14, weight: .regular)
        static let regular12 = system(size: 12, weight: .regular)

        
        static let light12 = system(size: 12, weight: .light)
    }
}


