//
//  NankiApp.swift
//  Nanki
//
//  Created by 안정흠 on 2/18/25.
//

import SwiftUI

@main
struct NankiApp: App {
    @StateObject var store = WordStore()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .environmentObject(store)
            }
//            ContentView()
        }
    }
}
