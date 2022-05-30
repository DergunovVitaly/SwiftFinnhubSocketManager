//
//  SafeURL.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

struct SafeURL {
    static func path(_ string: String) -> URL {
        if let url = URL(string: string) {
            return url
        }
        else {
            print("⚠️ Malformed URL: \(string)")
        }
    }
}
