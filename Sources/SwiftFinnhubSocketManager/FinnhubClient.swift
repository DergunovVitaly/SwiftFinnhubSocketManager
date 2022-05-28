//
//  File.swift
//  
//
//  Created by Vitalii on 27.05.2022.
//

import Foundation

public enum FinnhubWebError: Error {
    case networkFailure(Error)
    case invalidData
}

public enum FinnhubClient {

    fileprivate static func headers() -> (String, String) {
        return (Constants.API_KEY, "X-Finnhub-Token")
    }

    fileprivate static func resourcePayload<A>(url: URL) -> Resource<A> where A: Decodable {
        let resource = Resource<A>(get: url, headers: headers())
        return resource
    }

    static func parseResponse<T>(result: Result<T?, Error>) -> Result<T, FinnhubWebError> {
        switch result {
        case let .success(data):
            if let parsed = data {
                return (.success(parsed))
            } else {
                return (.failure(.invalidData))
            }
        case let .failure(error):
            return (.failure(.networkFailure(error)))
        }
    }

    // MARK: Company Profile

    public static func companyProfile(symbol: String, completion: @escaping (Result<CompanyProfile, FinnhubWebError>) -> Void) {
        let url = SafeURL.path("\(Constants.BASE_URL)/stock/profile2?symbol=\(symbol)")
        let resource = Resource<CompanyProfile>(get: url, headers: headers())
        URLSession.shared.load(resource) { (result: Result<CompanyProfile?, Error>) in
            completion(FinnhubClient.parseResponse(result: result))
        }
    }
    
    // MARK: Quote

    public static func quote(symbol: String, completion: @escaping (Result<Quote, FinnhubWebError>) -> Void) {
        let url = SafeURL.path("\(Constants.BASE_URL)/quote?symbol=\(symbol)")
        let resource = Resource<Quote>(get: url, headers: headers())
        URLSession.shared.load(resource) { (result: Result<Quote?, Error>) in
            completion(FinnhubClient.parseResponse(result: result))
        }
    }
  
}

