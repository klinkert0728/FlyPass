//
//  Endpoint.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum flypassEndpoint {
    
    case userInformation()
    case getUserMovements(page:Int)
    
    
}


extension flypassEndpoint:APIEndpoint {
    
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "https://secure.flypass.com.co/flypass/")!
        }
    }
    
    var path: String {
        switch self {
        case .userInformation():
            return "user-service/userinformation"
        case .getUserMovements(page: let page):
            return "report/userMovements"
        default :
            return ""
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserMovements(page: let page):
            return ["page":page]
        default:
            return nil
        }
    }
    
    var customParameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
        
    }
    
    var customHTTPHeaders: [String: String]? {
        switch self {
        default:
            //let token = KNMTCAppEngine.activeAppEngine()?.sessionManager.activeSession()?.token ?? ""
            let token = ""
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
