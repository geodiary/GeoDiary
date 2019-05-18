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

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var mapFunctions: MapFunctions!
    let locationIDs = ["ChIJnSKGEJlZwokRQIpiCvzKzV4", "ChIJaeKcEaRZwokRcllXm5cM7J0", "ChIJ0QCeh5tZwokRh9J_3uvSPjU", "ChIJKxDbe_lYwokRVf__s8CPn-o"]
    var placeIDs = [String]()
    var placeNames = [String]()
    var routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapFunctions = MapFunctions()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleModalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! locationCell
        cell.locationName.text = placeNames[indexPath.row]
        return cell
    }
    
    @objc func handleModalDismissed(notification: NSNotification) {
        let arr = notification.object as! [String]
        placeIDs.append(arr[0] as! String)
        placeNames.append(arr[1] as! String)
        self.table.reloadData()
    }
    
    @IBAction func planRoute(_ sender: Any) {
        let results = self.mapFunctions.route(placeIDs: self.locationIDs, completionHandler: {routes in
            if let routes = routes {
                self.performSegue(withIdentifier: "showRouteSegue", sender: routes)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showRouteSegue") {
            let rvc = segue.destination as! RouteViewController
            rvc.routes = sender as! [Route]
        }
    }
}

class locationCell: UITableViewCell {
    
    @IBOutlet weak var locationName: UILabel!
    
}
