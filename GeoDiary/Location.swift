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
    var locationPlaceID = String()
    var locationAddress = String()
    var locationLatitude = Double()
    var locationLongitude = Double()
    
    init() {
        self.locationName = ""
        self.locationAddress = ""
        self.locationLatitude = 0.0
        self.locationLongitude = 0.0
    }
    
    init(name: String, placeID: String, address: String, latitude: Double, longitude: Double) {
        self.locationName = name
        self.locationPlaceID = placeID
        self.locationAddress = address
        self.locationLatitude = latitude
        self.locationLongitude = longitude
    }
}
