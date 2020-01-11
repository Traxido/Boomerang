//
//  Global.swift
//  Boomerang
//
//  Created by Andrew Sheron on 1/8/20.
//  Copyright © 2020 Andrew Sheron. All rights reserved.
//

import Foundation

var colors = ["red", "yellow", "green", "blue"]

struct physicsCategory {
    static let player : UInt32 = 0x1 << 0
    static let enemy : UInt32 = 0x1 << 1
    static let boomerang : UInt32 = 0x1 << 2
}
