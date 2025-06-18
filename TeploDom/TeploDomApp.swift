//
//  TeploDomApp.swift
//  TeploDom
//
//  Created by Bema on 18/6/25.
//

import SwiftUI

@main
struct TeploDomApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
