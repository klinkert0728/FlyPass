//
//  TollsHelper.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 7/9/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import CoreLocation

public enum tollsLocation:String {
    case lasPalmasAirport
    
    func tollLocation() -> CLLocationCoordinate2D {
        switch self {
        case .lasPalmasAirport:
            return CLLocationCoordinate2D(latitude: 6.170875, longitude: -75.4809139)
        default:
            return CLLocationCoordinate2D(latitude: 1, longitude: 1)
        }
    }
}
