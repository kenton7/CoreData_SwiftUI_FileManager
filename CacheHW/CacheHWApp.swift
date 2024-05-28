//
//  CacheHWApp.swift
//  CacheHW
//
//  Created by Илья Кузнецов on 27.05.2024.
//

import SwiftUI

@main
struct CacheHWApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
