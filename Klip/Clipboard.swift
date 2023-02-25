//
//  Clipboard.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/25.
//

import Foundation
import SwiftUI

class Clipboard: ObservableObject {
    private var timer = Timer()
    private let pasteboard = NSPasteboard.general
    private var changeCount: Int = 0
    
    @Published var items: [String] = []
    
    
    func checkForChangesInPasteboard () {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        self.changeCount = pasteboard.changeCount
        self.pasteboard.pasteboardItems?.forEach({it in
            if items.count > 9 {
                items = Array(items.dropFirst(items.count - 9))
            }
            items.append(it.string(forType: .string) ?? "")
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

    init() {
        start()
    }
    deinit {
        stop()
    }
}
