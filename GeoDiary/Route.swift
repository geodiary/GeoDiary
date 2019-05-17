//
//  Route.swift
//  GeoDiary
//
//  Created by Raihan Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class Route {
    var startCoordinate: CLLocationCoordinate2D!
    var endCoordinate: CLLocationCoordinate2D!
    var startAddress: String!
    var endAddress: String!
    var overviewPolyline: Dictionary<NSString, AnyObject>!
    
    var description : String {
        var desc = ""
        desc += "start coordinate: \(String(describing: self.startCoordinate)) - "
        desc += "end coordinate: \(String(describing: self.endCoordinate)) - "
        desc += "start address: \(String(describing: self.startAddress)) - "
        desc += "end address: \(String(describing: self.endAddress)) - "
        return desc
    }
    
    init() {
        
    }
}
