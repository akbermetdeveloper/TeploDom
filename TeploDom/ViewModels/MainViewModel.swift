//
//  MainViewModel.swift
//  TeploDom
//
//  Created by Bema on 19/6/25.
//

import Foundation
import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    @Published var savedAccounts: [String] = [] 
    
    private let key = "savedAccounts"

    init() {
        loadSavedAccounts()
    }

    func loadSavedAccounts() {
        if let accounts = UserDefaults.standard.stringArray(forKey: key) {
            self.savedAccounts = accounts
        }
    }

    func addAccount(_ account: String) {
        if !savedAccounts.contains(account) {
            savedAccounts.append(account)
            UserDefaults.standard.set(savedAccounts, forKey: key)
        }
    }

    func removeAccount(_ account: String) {
        savedAccounts.removeAll { $0 == account }
        UserDefaults.standard.set(savedAccounts, forKey: key)
    }
}

