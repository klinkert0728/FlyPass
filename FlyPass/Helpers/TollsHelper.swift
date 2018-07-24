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

protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}

extension tollsLocationProtocol {
    var radius:Double {
        return 1000.0
    }
}


public enum tollsLocation:String,EnumCollection {
    case lasPalmasAirport
    case elRetiro
    case amaga
    case viscaya
    case home
    case palmahia
    
    fileprivate func tollCenter() -> CLLocationCoordinate2D {
        switch self {
        case .lasPalmasAirport:
            return CLLocationCoordinate2D(latitude: 6.170875, longitude: -75.4766036)
        case .home:
            return CLLocationCoordinate2D(latitude: 6.1996043, longitude: -75.5716912)
        case .amaga:
            return CLLocationCoordinate2D(latitude: 6.0469539, longitude: -75.6620097)
        case .elRetiro:
            return CLLocationCoordinate2D(latitude: 6.1513475, longitude: -75.5354653)
        case .palmahia:
            return CLLocationCoordinate2D(latitude: 6.1911443, longitude: -75.5853327)
        default:
            return CLLocationCoordinate2D(latitude: 6.2080713, longitude: -75.5637172)
        }
    }
    
    func tollName() -> String {
        switch self {
        case .lasPalmasAirport:
            return "Variante al Aeropuerto"
        case .home:
            return "Home"
        case .elRetiro:
            return "El retiro"
        case .amaga:
            return "Amaga"
        case .palmahia:
            return "Palmahía"
        default:
            return "Vizcaya"
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
        case tollsLocation.elRetiro.rawValue:
            return tollsLocation.elRetiro.tollCenter()
        case tollsLocation.home.rawValue:
            return tollsLocation.home.tollCenter()
        case tollsLocation.amaga.rawValue:
            return tollsLocation.amaga.tollCenter()
        case tollsLocation.palmahia.rawValue:
            return tollsLocation.palmahia.tollCenter()
        default:
           return tollsLocation.viscaya.tollCenter()
        }
    }
    
    func circularRegion() -> CLCircularRegion {
        return CLCircularRegion(center: center, radius: radius, identifier: id)
    }
}

