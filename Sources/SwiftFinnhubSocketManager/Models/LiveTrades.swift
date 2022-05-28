//
//  LiveTrades.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

public struct LiveTrades: LiveResponse, Mappable {
    public var data: [Trade]
    public var type: String
}
