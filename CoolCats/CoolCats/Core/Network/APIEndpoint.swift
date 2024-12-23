//
//  APIEndpoint.swift
//  CoolCats
//
//  Created by Elano Vasconcelos on 21/12/24.
//

import Foundation

enum APIEndpoint {
    case breeds(limit: Int, page: Int)
    
    var path: String {
        switch self {
        case .breeds:
            return "/breeds"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .breeds(let limit, let page):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .breeds:
            return ["Content-Type": "application/json"]
        }
    }
}
