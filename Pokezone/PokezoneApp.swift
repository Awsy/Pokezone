//
//  PokezoneApp.swift
//  Pokezone
//
//  Created by Aws Shkara on 18/06/2025.
//

import SwiftUI

@main
struct PokezoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
