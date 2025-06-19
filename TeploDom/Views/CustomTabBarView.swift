//
//  CustomTabBarView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
   // @EnvironmentObject var permissionManager: PermissionManager

    enum Tab {
        case main, meters, consumptions, readings, settings
    }

    var body: some View {
        HStack(spacing: 0) {
                    TabBarButton(icon: "house.fill", text: "Главная", isSelected: selectedTab == .main) {
                        selectedTab = .main
                    }
                    TabBarButton(icon: "chart.line.uptrend.xyaxis.circle.fill", text: "Счетчики", isSelected: selectedTab == .meters) {
                        selectedTab = .meters
                    }
                    TabBarButton(icon: "dollarsign.circle.fill", text: "Расходы", isSelected: selectedTab == .consumptions) {
                        selectedTab = .consumptions
                    }
            
            TabBarButton(icon: "chart.bar.xaxis.ascending.badge.clock", text: "Показатели", isSelected: selectedTab == .readings) {
                selectedTab = .readings
            }
            
            TabBarButton(icon: "gearshape.fill", text: "Настройки", isSelected: selectedTab == .settings) {
                selectedTab = .settings
            }
                }
                .padding(10)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()
            }
}

struct TabBarButton: View {
    let icon: String
    let text: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isSelected, let text = text {
                VStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text(text)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 10)
                .background(Color(hex: "#A6C549"))
                .clipShape(Capsule())
            } else {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "#A6C549"))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    HStack {
        TabBarButton(
            icon: "house.fill",
            text: "Главная",
            isSelected: true
        ) {}

        TabBarButton(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            text: "Счетчики",
            isSelected: false
        ) {}

        TabBarButton(
            icon: "dollarsign.circle.fill",
            text: "Расходы",
            isSelected: false
        ) {}
        
        TabBarButton(
            icon: "chart.bar.xaxis.ascending.badge.clock",
            text: "Показатели",
            isSelected: false
        ) {}
        
        TabBarButton(
            icon: "gearshape.fill",
            text: "Настройки",
            isSelected: false
        ) {}
    }
    .padding(10)
    .background(Color.white)
    .clipShape(Capsule())
    .padding()
    .background(Color.clear)
}

