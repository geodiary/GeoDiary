//
//  RouteChildMapViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class RouteChildMapViewController: UIViewController {

    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var routes: [Route] = []
    var currentIndex = 0
    var currentRoute: Route!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView = GMSMapView(frame: self.mapContainer.frame)
        self.view.addSubview(self.mapView)
        
        drawRoute(route: routes.first!, index: currentIndex)
    }
    
    @IBAction func nextRoute(_ sender: Any) {
        if currentIndex < routes.count-1 {
            currentIndex += 1
            currentRoute = routes[currentIndex]
            drawRoute(route: currentRoute, index: currentIndex)
        }
    }
    
    func drawRoute(route: Route, index: Int) {
        self.mapView.clear()
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: routes[index].startCoordinate, zoom: 12)
        self.view.addSubview(self.mapView)
        
        let startCoord = route.startCoordinate as! CLLocationCoordinate2D
        let startMarker = GMSMarker(position: startCoord)
        startMarker.title = route.startAddress
        startMarker.map = self.mapView
        
        let endCoord = route.endCoordinate as! CLLocationCoordinate2D
        let endMarker = GMSMarker(position: endCoord)
        endMarker.title = route.endAddress
        endMarker.map = self.mapView
        
        let route = route.overviewPolyline["points"] as! String
        let path = GMSPath(fromEncodedPath: route)
        let polyline = GMSPolyline(path: path)
        polyline.map = self.mapView
    }
}
