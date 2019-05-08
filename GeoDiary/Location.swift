//
//  Location.swift
//  GeoDiary
//
//  Created by YangLingqin on 7/5/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation

class Location {
    
    var locationName = String()
    var locationAddress = String()
    var locationLatitude = Double()
    var locationLongitude = Double()
    
    init() {
        self.locationName = ""
        self.locationAddress = ""
        self.locationLatitude = 0.0
        self.locationLongitude = 0.0
    }
    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.locationName = name
        self.locationAddress = address
        self.locationLatitude = latitude
        self.locationLongitude = longitude
    }
}
