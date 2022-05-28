//
//  SafeURL.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

struct SafeURL {
    static func path(_ string: String) -> URL {
        guard let url = URL(string: string) else {
            fatalError("Malformed URL: \(string)")
        }
        return url
    }
}
