//
//  HomeView.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    let selectedAccount: String

    var body: some View {
        VStack {
            Text("Добро пожаловать")
                .font(.title)
            Text("Лицевой счёт: \(selectedAccount)")
        }
    }
}
