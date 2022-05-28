
//
//  Quote.swift
//
//
//  Created by Vitalii on 27.05.2022.
//

import Foundation

public struct Quote: Mappable {
    public var open: Float
    public var high: Float
    public var low: Float
    public var current: Float
    public var previousClose: Float
    public var timestamp: Int

    enum CodingKeys: String, CodingKey {
        case open = "o"
        case high = "h"
        case low = "l"
        case current = "c"
        case previousClose = "pc"
        case timestamp = "t"
    }
}
