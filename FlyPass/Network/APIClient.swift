//
//  APIClient.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import Alamofire
import RealmSwift

class APIClient {
    static var sharedClient: APIClient {
        return APIClient()
    }
    
    func requestObject<T:Object>(endpoint: flypassEndpoint,keyPath:String? = nil ,completionHandler:@escaping (_ object:T) ->(),errorClosure:@escaping (_ error:NSError)->()) where T : Mappable {
        
        Alamofire.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.customParameterEncoding, headers: endpoint.customHTTPHeaders).responseObject { (response:DataResponse<T>) in
            
            if let value = response.value, response.result.isSuccess, response.response?.statusCode == 200 {
                completionHandler(value)
            }else {
                
                guard let responseData = response.data, let dictionaryObject = try? JSONSerialization.jsonObject(with: responseData, options: []), let dict = dictionaryObject as? [String:Any] else {
                    let newError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Illegal login response."])
                    errorClosure(newError)
                    return
                }
                
                if let err = dict["error"] as? String, let statusCode = dict["statusCode"] as? Int {
                    if let message = dict["message"] as? String {
                        
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey:message])
                        
                        errorClosure(newError)
                    }
                    else {
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error: \(err); Http code: \(statusCode)"])
                        errorClosure(newError)
                    }
                }else {
                    if let status =  response.response?.statusCode {
                        var message = ""
                        if status == 409 {
                            message = "Conflict with etag"
                        }
                        let newError = NSError(domain: "", code: status, userInfo: [NSLocalizedDescriptionKey: message])
                        errorClosure(newError)
                    }
                }
            }
        }
    }
    
    
    func requestArrayOfObject<T:Object>(endpoint: flypassEndpoint,keyPath:String?  = nil ,completionHandler:@escaping (_ object:[T]) ->(),errorClosure:@escaping (_ error:Error)->()) where T : Mappable {
        
        Alamofire.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.customParameterEncoding, headers: endpoint.customHTTPHeaders).responseArray(keyPath:keyPath) { (response:DataResponse<[T]>) in
            
            if let value = response.value, response.result.isSuccess, response.response?.statusCode == 200 {
                completionHandler(value)
            }else {
                
                guard let responseData = response.data, let dictionaryObject = try? JSONSerialization.jsonObject(with: responseData, options: []), let dict = dictionaryObject as? [String:Any] else {
                    let newError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Illegal login response."])
                    errorClosure(newError)
                    
                    return
                }
                
                if let err = dict["error"] as? String, let statusCode = dict["statusCode"] as? Int {
                    if let message = dict["message"] as? String {
                        
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey:message])
                        
                        errorClosure(newError)
                    }
                    else {
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error: \(err); Http code: \(statusCode)"])
                        errorClosure(newError)
                    }
                }
            }
        }
    }
    
    func requestJSONObject(endpoint: flypassEndpoint,completionHandler:@escaping (_ object:Any) ->(),errorClosure:@escaping (_ error:Error)->()) {
        Alamofire.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.customParameterEncoding, headers: endpoint.customHTTPHeaders).responseJSON(completionHandler: { (response:DataResponse<Any>) in
            
            if let value = response.value, response.result.isSuccess, response.response?.statusCode == 200 {
                completionHandler(value)
            }else {
                
                guard let responseData = response.data, let dictionaryObject = try? JSONSerialization.jsonObject(with: responseData, options: []), let dict = dictionaryObject as? [String:Any] else {
                    let newError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Illegal login response."])
                    errorClosure(newError)
                    
                    return
                }
                
                if let err = dict["error"] as? String, let statusCode = dict["statusCode"] as? Int {
                    if let message = dict["message"] as? String {
                        
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey:message])
                        
                        errorClosure(newError)
                    }
                    else {
                        let newError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error: \(err); Http code: \(statusCode)"])
                        errorClosure(newError)
                    }
                }
            }
        })
    }
    
    func requestString(endPoint:flypassEndpoint,successClosure:@escaping (_ success:Bool)->()) {
        Alamofire.request(endPoint.url, method: endPoint.method, parameters: endPoint.parameters, encoding: endPoint.customParameterEncoding, headers: endPoint.customHTTPHeaders).responseString { (response:DataResponse<String>) in
            successClosure(response.response?.statusCode == 200)
        }
    }
}
