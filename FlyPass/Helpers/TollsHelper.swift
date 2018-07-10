//
//  TollsHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 7/9/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate protocol tollsLocationProtocol {
    var id:String {get}
    var center:CLLocationCoordinate2D { get }
    var radius:Double { get }
}

extension tollsLocationProtocol {
    var radius:Double {
        return 20.0
    }
}

public enum tollsLocation:String {
    case lasPalmasAirport
    case viscaya
    
    fileprivate func tollCenter() -> CLLocationCoordinate2D {
        switch self {
        case .lasPalmasAirport:
            return CLLocationCoordinate2D(latitude: 6.170875, longitude: -75.4766036)
        default:
            return CLLocationCoordinate2D(latitude: 6.2079780819689327, longitude: -75.5635904880711)
        }
    }
    
    func circularRegion() -> CLCircularRegion {
        return tollsRegion(id: self.rawValue).circularRegion()
    }
}

fileprivate struct tollsRegion:tollsLocationProtocol {
   
    var id:String
    
    var center: CLLocationCoordinate2D {
        switch id {
        case tollsLocation.lasPalmasAirport.rawValue:
            return tollsLocation.lasPalmasAirport.tollCenter()
        default:
           return tollsLocation.viscaya.tollCenter()
        }
    }
    
    func circularRegion() -> CLCircularRegion {
        return CLCircularRegion(center: center, radius: radius, identifier: id)
    }
}

