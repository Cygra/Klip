//
//  ContentView.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import SwiftUI

func clipContent(data: Data, type: NSPasteboard.PasteboardType) -> String {
    let content = String(decoding: data, as: UTF8.self)
    if type == .string {
        return content.count > 60 ? "\(content.prefix(60)) ..." : content
    } else if type == .fileURL {
        return "[\(content.replacingOccurrences(of: content.dropFirst(28).dropLast(28), with: "..."))]"
    } else {
        return ""
    }
}

@available(macOS 13.0, *)
struct ContentView: View {
    @EnvironmentObject var clipboard: Clipboard
    @Environment(\.openWindow) var openWindow

    var body: some View {
        ForEach(
            Array(clipboard.items.prefix(Constants.LIST_CAPASITY).enumerated()),
            id: \.offset
        ) { ind, it in
            if it.pasteboardType == .string || it.pasteboardType == .fileURL {
                Button(clipContent(data: it.data, type: it.pasteboardType)) {
                    clipboard.paste(it: it)
                }.keyboardShortcut(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"][ind])
            } else if it.pasteboardType == .png {
                Button("Png from Screenshot") {
                    NSApp.activate(ignoringOtherApps: true)
                    openWindow(id: Constants.MEDIA_WINDOW_ID)
                }.keyboardShortcut(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"][ind])
            }
        }
    }
}

@available(macOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
