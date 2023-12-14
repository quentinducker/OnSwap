//
//  OnSwapApp.swift
//  OnSwap
//
//  Created by Quentin Ducker on 12/9/23.
//

import SwiftUI
import SwiftData

@main
struct OnSwapApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(for: [User.self, Product.self])
        
    }
}
