//
//  RouteChildListViewController.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class RouteChildListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var routes: [Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeListCell", for: indexPath) as! routeListCell
        let routeHTMLText = routes[indexPath.row].htmlInstructions
        cell.routeHTMLText.text = routeHTMLText
        return cell
    }
}

class routeListCell: UITableViewCell {
    
    @IBOutlet weak var routeHTMLText: UILabel!
    
}
