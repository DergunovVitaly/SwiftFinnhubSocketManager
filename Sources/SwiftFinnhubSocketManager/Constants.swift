//
//  Constants.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

struct Constants {
    static let BASE_URL = "https://finnhub.io/api/v1"
    static let BASE_SOCKET_URL = "wss://ws.finnhub.io"
    static var API_KEY: String {
        guard let filePath = Bundle.main.path(forResource: "Finnhub-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Finnhub-Info.plist'.")
        }
        let url = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String:String] else {
            fatalError("Couldn't find key 'API_KEY' in 'Finnhub-Info.plist'.")
        }
        guard let value = plist["API_KEY"] else {
            fatalError("Couldn't find key 'API_KEY' in 'Finnhub-Info.plist'.")
        }
        return value
    }
}
