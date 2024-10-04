//
//  DyskidApp.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 9.09.2024.
//

import SwiftUI
import Firebase

@main
struct DysKidApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
