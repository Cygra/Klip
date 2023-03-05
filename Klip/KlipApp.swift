//
//  KlipApp.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import SwiftUI

@available(macOS 13.0, *)
@main
struct KlipApp: App {
    @StateObject private var clipboard: Clipboard = Clipboard()
    
    var body: some Scene {
        MenuBarExtra("1", systemImage: "1.circle") {
            Button("About") {
                NSApplication.shared.orderFrontStandardAboutPanel()
                NSApp.activate(ignoringOtherApps: true)
            }
            Button("Preferences") {
            }
            Divider()
            ContentView()
                .environmentObject(clipboard)
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
