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
    @StateObject private var clipboard: Clipboard = .init()
    @Environment(\.openWindow) var openWindow
    @State private var animationAmount = 0.0

    func onMediaClick(it: ClipboardItem) {
        animationAmount = 1
        clipboard.paste(it: it)
        Timer.scheduledTimer(
            withTimeInterval: Constants.TICK_INTERVAL, repeats: false
        ) { _ in
            animationAmount = 0
            //            NSApplication.shared.keyWindow?.close()
        }
    }

    var body: some Scene {
        MenuBarExtra(
            "Klip Menu Bar",
            systemImage: clipboard.isTicking ? "checkmark.circle" :
                clipboard.items.count > 0
                ? "\(clipboard.items.count).circle"
                : "scissors.circle"
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                Divider()
                Button("About") {
                    NSApplication.shared.orderFrontStandardAboutPanel()
                    NSApp.activate(ignoringOtherApps: true)
                }
                //                Button("Preferences") {}
                Divider()
                Button("Show all medias") {
                    NSApp.activate(ignoringOtherApps: true)
                    openWindow(id: Constants.MEDIA_WINDOW_ID)
                }
                .keyboardShortcut("a")
                .disabled(
                    !clipboard.items.contains {
                        $0.pasteboardType == .fileURL || $0.pasteboardType == .png
                    }
                )
                Divider()
                ContentView()
                    .environmentObject(clipboard)
            }.padding()
        }
        Window("Medias", id: Constants.MEDIA_WINDOW_ID) {
            if animationAmount != 0 {
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text("Content added to clipboard!")
                }.padding([.top])
//                    .scaleEffect(x: 1.0, y: animationAmount)
//                    .animation(.easeInOut(duration: 0.3), value: animationAmount)
            }
            ScrollView {
                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    ForEach(
                        Array(clipboard.items.enumerated()),
                        id: \.offset
                    ) { _, it in
                        let filePath = String(decoding: it.data, as: UTF8.self)
                        if (it.pasteboardType == .fileURL && filePath.hasSuffix(".png"))
                            || it.pasteboardType == .png
                        {
                            Button(action: {
                                onMediaClick(it: it)
                            }) {
                                if it.pasteboardType == .fileURL {
                                    AsyncImage(url: URL(string: filePath)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }.cornerRadius(8)
                                } else {
                                    Image(nsImage: NSImage(data: it.data)!)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                            Divider()
                        } else if it.pasteboardType == .fileURL {
                            Button(action: {
                                onMediaClick(it: it)
                            }) {
                                Text("[\(filePath)]")
                            }.buttonStyle(BorderlessButtonStyle())
                            Divider()
                        }
                    }
                }
            }.frame(width: 300).padding()
        }.windowResizability(.contentSize)
    }
}
