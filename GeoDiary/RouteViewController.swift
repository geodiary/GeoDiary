//
//  RouteViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/8/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class RouteViewController: UIViewController {
    
    
    @IBOutlet weak var mapContainer: UIView!
    var mapView: GMSMapView!
    var mapMarker: GMSMarker!
    var mapFunctions: MapFunctions!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapFunctions = MapFunctions()
        
        // load map view and set initial location
        self.mapView = GMSMapView.map(withFrame: self.mapContainer.frame, camera: GMSCameraPosition.camera(withLatitude: 40.728952, longitude: -73.995681, zoom: 12))
//        self.mapView.isMyLocationEnabled = true
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
            let origin = (createRouteAlert.textFields![0] as UITextField).text as! String
            let destination = (createRouteAlert.textFields![0] as UITextField).text as! String

            self.mapFunctions.getDirections(origin: origin, destination: destination, waypoints: nil, withCompletionHandler: {(status, success) -> Void in
                if success {
                    print("success")
                } else {
                    print("fail")
                }
            })
        })

        let closeAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { (alertAction) -> Void in
        })

        createRouteAlert.addAction(createRouteAction)
        createRouteAlert.addAction(closeAction)

        present(createRouteAlert, animated: true, completion: nil)
    }
    
}
/*
extension RouteViewController: UISearchBarDelegate {
    // connect search button for both text fields to this function
    @IBAction func searchByAddress() {
        
    }
}
extension RouteViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // update
        print("in viewController()")
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}*/
