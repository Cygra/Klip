//
//  ContentView.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var clipboard: Clipboard

    var body: some View {
        ForEach(clipboard.items.reversed(), id: \.id) { it in
            if it.pasteboardType == .string {
                Button(String(decoding: it.data, as: UTF8.self)) {
                    clipboard.paste(it: it)
                }
            } else if it.pasteboardType == .fileURL {
                let filePath = String(decoding: it.data, as: UTF8.self)
                if filePath.hasSuffix(".png") {
                    Button(action: {
                        clipboard.paste(it: it)
                    }) {
                        AsyncImage(url: URL(string: filePath))
                    }
                } else {
                    Button("file: " + filePath) {
                        clipboard.paste(it: it)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
