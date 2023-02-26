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
        ForEach(clipboard.items.reversed(), id: \.self) { it in
            Button(it) {
                clipboard.paste(it: it)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
