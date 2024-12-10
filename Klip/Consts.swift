//
//  Consts.swift
//  Klip
//
//  Created by 王博晗 on 2023/2/26.
//

import Foundation
import SwiftUI

struct Constants {
  static let INTERNAL_TYPE = NSPasteboard.PasteboardType(rawValue: "internal.Klip.type")
  static let INTERNAL_CONTENT = "internal"
  static let MEDIA_WINDOW_ID = "medias"
  static let SETTINGS_WINDOW_ID = "settings"
  static let TICK_INTERVAL = 1.0
  static let HISTORY_LENGTH_KEY = "historyLength"
  static let LAUNCH_AT_LOGIN = "launchAtLogin"
}
