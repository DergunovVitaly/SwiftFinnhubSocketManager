//
//  Trade.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

public struct Trade: Mappable {
    public var p: Float // Last price
    public var s: String // Symbol
    public var t: Int // UNIX milliseconds timestamp
    public var v: Float // Volume
}
