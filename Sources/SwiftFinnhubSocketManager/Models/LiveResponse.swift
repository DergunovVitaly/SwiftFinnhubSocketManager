//
//  LiveResponse.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

public protocol LiveResponse {
    var type: String { get set }
}

public enum LiveResponseType: String {
    case trade
    case ping
}
