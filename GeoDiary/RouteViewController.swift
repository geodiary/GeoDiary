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

class RouteViewController: UIViewController {

    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!

    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapFunctions = MapFunctions()

        // load map view and set initial location
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: 40.728952, longitude: -73.995681, zoom: 12))
        self.view.addSubview(self.mapView)
        
        self.mapMarker = GMSMarker(position: CLLocationCoordinate2DMake(40.728952, -73.995681))
        self.mapMarker.title = "Courant Institute of Mathematical Sciences - New York University"
        self.mapMarker.map = self.mapView
    }
    

    @IBAction func createRoute(_ sender: Any) {
        
        let createRouteAlert = UIAlertController(title: "Create Route", message: "See route between two locations", preferredStyle: UIAlertController.Style.alert)
        createRouteAlert.addTextField(configurationHandler: {(textField) -> Void in
            textField.placeholder = "Origin:"
        })
        createRouteAlert.addTextField(configurationHandler: {(textField) -> Void in
            textField.placeholder = "Destination:"
        })
        
        let createRouteAction = UIAlertAction(title: "Create Route", style: UIAlertAction.Style.default, handler: {(alertAction) -> Void in
//            let origin = (createRouteAlert.textFields![0] as UITextField).text as! String
//            let destination = (createRouteAlert.textFields![0] as UITextField).text as! String
            
            let originPlaceID  = "ChIJHbNDrN9hwokRSTvYiaYovd8"
            let destinationPlaceID = "ChIJr4JMceFhwokRcx2Oie6Ue4w"
            self.mapFunctions.getDirectionsBetweenTwoPoints(originPlaceID: originPlaceID, destinationPlaceID: destinationPlaceID, withCompletionHandler: {(status, success) -> Void in
                if success {
                    print("success")
                    print(status)
                    
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
                    
                } else {
                    print("fail")
                    print(status)
                }
            })
        })
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { (alertAction) -> Void in
        })
        
        createRouteAlert.addAction(createRouteAction)
        createRouteAlert.addAction(closeAction)
        
        present(createRouteAlert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
