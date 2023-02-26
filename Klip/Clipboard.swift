//
//  Clipboard.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import Foundation
import SwiftUI

class Clipboard: ObservableObject {
    private let pasteboard = NSPasteboard.general
    private var timer = Timer()
    private var changeCount: Int
    
    @Published var items: [String] = []
    
    func addItemToItems(it: String) {
        if items.count > 9 {
            items = Array(items.dropFirst(items.count - 9))
        }
        items.append(it)
    }
    
    func checkForChangesInPasteboard () {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        changeCount = pasteboard.changeCount
        pasteboard.pasteboardItems?.forEach({it in
            let result = it.string(forType: .string) ?? ""
            if result != "" && it.string(forType: Constants.INTERNAL_TYPE) != Constants.INTERNAL_CONTENT {
                addItemToItems(it: result)
            }
        })
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.checkForChangesInPasteboard()
        }
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func paste(it: String) {
        pasteboard.clearContents()
        pasteboard.setString(it, forType: .string)
        pasteboard.setString(Constants.INTERNAL_CONTENT, forType: Constants.INTERNAL_TYPE)
    }
    
    init() {
        changeCount = pasteboard.changeCount
        start()
    }
    deinit {
        stop()
    }
}
