//
//  StaticSpecificCollectionView.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class StaticSpecificCollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var parentCollectionName = String()
    var db: Firestore!
    var merchants = [Merchant]()
    var merchantName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        getMerchants()
        
    }
    
    
    
    func getMerchants() {
        if (UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            db.collection("users").document(userID).collection(parentCollectionName).getDocuments() {(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents")
                } else {
                    for document in querySnapshot!.documents {
                        let merchant = Merchant(name: document.get("name") as! String, documentId: document.documentID, collection: self.parentCollectionName)
                        merchant.address = document.get("address") as! String
                        if (document.get("placeID") != nil) {
                            merchant.placeID = document.get("placeID") as! String
                        }
                        self.merchants.append(merchant)
                        self.merchantName.append(merchant.name)
                    }
                    self.table.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantNameCell", for: indexPath) as! merchantNameCell
        let merchantName = merchants[indexPath.row].name
        cell.merchantName.text = merchantName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchants.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var info = [] as [String]
        info.append(merchants[indexPath.row].address as String)
        info.append(merchantName[indexPath.row] as String)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: info)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

class merchantNameCell: UITableViewCell {
    
    @IBOutlet weak var merchantName: UILabel!
    
}
