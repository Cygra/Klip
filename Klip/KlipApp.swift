//
//  KlipApp.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//
// TODO:
// 富文本、图片
// 默认 About 弹窗

import SwiftUI

@available(macOS 13.0, *)
@main
struct KlipApp: App {
    //    @Environment(\.openWindow) private var openAboutWindow
    @StateObject private var clipboard: Clipboard = Clipboard()
    
    var body: some Scene {
        MenuBarExtra("1", systemImage: "1.circle") {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            Divider()
            Button("About") {
                NSApplication.shared.orderFrontStandardAboutPanel()
                NSApp.activate(ignoringOtherApps: true)
            }
            Divider()
            Button("Preference") {
                
            }
            Divider()
            ContentView()
                .environmentObject(clipboard)
        }
    }
}
