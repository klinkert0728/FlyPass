//
//  APIEndpoint.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import Alamofire

protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var customHTTPHeaders: [String: String]? { get }
    var customParameterEncoding:ParameterEncoding {get}
}

extension APIEndpoint {
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
}
