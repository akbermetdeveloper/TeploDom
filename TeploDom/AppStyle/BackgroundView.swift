//
//  BackgroundView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [Color(hex: "#6A7A98"), Color(hex: "#232832")]),
            center: .center,
            startRadius: 0,
            endRadius: 250
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
