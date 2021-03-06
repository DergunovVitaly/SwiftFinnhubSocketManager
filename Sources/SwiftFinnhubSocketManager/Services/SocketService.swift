//
//  SocketService.swift
//  
//
//  Created by Vitalii on 24.05.2022.
//

import Foundation

enum SocketEvent {
    case connected([String: String])
    case disconnected(String, UInt16)
    case text(String)
    case binary(Data)
    case error(Error?)
    case cancelled
}

class SocketService {
  
    var task: URLSessionWebSocketTask?
    
    init(url: URL) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        task = urlSession.webSocketTask(with: url)
        task?.resume()
    }
    
    func sendMessage(string: String) {
        let socketMessage = URLSessionWebSocketTask.Message.string(string)
        task?.send(socketMessage) { error in
            if let error = error {
                print(error)
            }
        }
    }

    func receiveMessage(completion: @escaping (SocketEvent) -> Void) {
        task?.receive { [weak self] result in
            switch result {
            case let .success(message):
                switch message {
                case let .string(string):
                    completion(.text(string))
                case let .data(data):
                    completion(.binary(data))
                @unknown default:
                    completion(.error(nil))
                }
            case let .failure(error):
                completion(.error(error))
            }
            self?.receiveMessage(completion: completion)
        }
    }

    func closeConnection() {
        task?.cancel(with: .goingAway, reason: nil)
    }
}
