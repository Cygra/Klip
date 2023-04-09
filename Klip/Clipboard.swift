//
//  Clipboard.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import Foundation
import SwiftUI

struct ClipboardItem: Identifiable {
    let id = UUID()
    var pasteboardType: NSPasteboard.PasteboardType
    var data: Data
}

class Clipboard: ObservableObject {
    private let pasteboard = NSPasteboard.general
    private var timer = Timer()
    private var changeCount: Int
    
    @Published var items: [ClipboardItem] = []
    @Published var isTick: Bool = false
    
    func toggleTick() {
        isTick = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
            self.isTick = false
        }
    }
    
    func addItemToItems(it: ClipboardItem) {
        toggleTick()
        if items.count > 9 {
            items = Array(items.dropLast(1))
        }
        items.insert(it, at: 0)
    }
    
    func checkForChangesInPasteboard() {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        changeCount = pasteboard.changeCount
        pasteboard.pasteboardItems?.forEach { it in
            let fromKlip = it.string(forType: Constants.INTERNAL_TYPE) == Constants.INTERNAL_CONTENT
            guard !fromKlip else {
                return
            }
            for pasteboardType in [
                NSPasteboard.PasteboardType.png,
                NSPasteboard.PasteboardType.fileURL,
                NSPasteboard.PasteboardType.string,
            ] {
                if let result = it.data(forType: pasteboardType) {
                    addItemToItems(it: ClipboardItem(pasteboardType: pasteboardType, data: result))
                    break
                }
            }
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.checkForChangesInPasteboard()
        }
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func paste(it: ClipboardItem) {
        pasteboard.clearContents()
        pasteboard.setData(it.data, forType: it.pasteboardType)
        pasteboard.setString(Constants.INTERNAL_CONTENT, forType: Constants.INTERNAL_TYPE)
        toggleTick()
    }
    
    init() {
        changeCount = pasteboard.changeCount
        start()
    }

    deinit {
        stop()
    }
}
