//
//  OffsetKey.swift
//  Dyskid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}
