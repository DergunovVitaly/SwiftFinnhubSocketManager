//
//  FinnhubLiveClient.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

public enum FinnhubLiveError: Error {
    case networkFailure(Error)
    case unknownFailure
    case invalidData
}

public enum FinnhubLiveSuccess {
    case trades(LiveTrades)
    case ping(LivePing)
    case empty
}

public class FinnhubLiveClient {
    public static let shared: FinnhubLiveClient = {
        let instance = FinnhubLiveClient()
        return instance
    }()
    
    fileprivate lazy var socketService: SocketService = {
        SocketService(url: SafeURL.path("\(Constants.BASE_SOCKET_URL)?token=\(Constants.API_KEY)"))
    }()
    
    func parseLiveText(_ text: String) -> Result<FinnhubLiveSuccess, FinnhubLiveError> {
        guard let json = text.data(using: .utf8) else {
            return (.failure(.invalidData))
        }
        let decoder = JSONDecoder()
        if let liveTrades = try? decoder.decode(LiveTrades.self, from: json) {
            return (.success(.trades(liveTrades)))
        } else if let ping = try? decoder.decode(LivePing.self, from: json) {
            return (.success(.ping(ping)))
        } else {
            return (.failure(.invalidData))
        }
    }
    
    public func subscribe(symbol: String) {
        let messageString = "{\"type\":\"subscribe\",\"symbol\":\"\(symbol)\"}"
        socketService.sendMessage(string: messageString)
    }
    
    public func subscribe(symbols: [String]) {
        for symbol in symbols {
            subscribe(symbol: symbol)
        }
    }
    
    public func receiveMessage(completionHandler: @escaping (Result<FinnhubLiveSuccess, FinnhubLiveError>) -> Void) {
        socketService.receiveMessage { [unowned self]  result in
            switch result {
            case .connected:
                completionHandler(.success(.empty))
            case .disconnected:
                completionHandler(.success(.empty))
            case let .text(text):
                completionHandler(self.parseLiveText(text))
            case .binary:
                completionHandler(.success(.empty))
            case let .error(error):
                if let unwrappedError = error {
                    completionHandler(.failure(.networkFailure(unwrappedError)))
                } else {
                    completionHandler(.failure(.unknownFailure))
                }
            case .cancelled:
                completionHandler(.success(.empty))
            }
        }
    }
    
    public func closeConnection() {
        socketService.closeConnection()
    }
}
