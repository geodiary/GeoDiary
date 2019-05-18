//
//  RouteViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class RouteViewController: UIViewController {

    @IBOutlet weak var listContainerView: UIView!
    
    var mapView: GMSMapView!
    var routes: [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChildMapSegue" {
            if let childMapVC = segue.destination as? RouteChildMapViewController {
                childMapVC.routes = self.routes
            }
        }
    }
}
