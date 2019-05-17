//
//  RouteViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/10/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlannerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
        /*
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withTarget: self.mapFunctions.originCoordinate, zoom: 15))
        self.view.addSubview(self.mapView)
        
        self.originMarker = GMSMarker(position: self.mapFunctions.originCoordinate)
        self.originMarker.map = self.mapView
        self.originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        self.originMarker.title = self.mapFunctions.originAddress
        
        self.destinationMarker = GMSMarker(position: self.mapFunctions.destinationCoordinate)
        self.destinationMarker.map = self.mapView
        self.destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        self.destinationMarker.title = self.mapFunctions.destinationAddress
        
        // draw route on map
        let route = self.mapFunctions.overviewPolyline["points"] as! String
        let path = GMSPath(fromEncodedPath: route)
        
        self.routePolyline = GMSPolyline(path: path)
        self.routePolyline.map = self.mapView
        */
}
