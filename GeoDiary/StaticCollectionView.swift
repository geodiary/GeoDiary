//
//  StaticCollectionView.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/17/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class StaticCollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var db: Firestore!
    var collectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        getCollectionNames()
    }
    
    @objc func handleModalDismissed(notification: NSNotification) {
        print("\(notification.object)")
        getCollectionNames()
        self.table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "intoStaticCollection" {
            let sscv = segue.destination as! StaticSpecificCollectionView
            sscv.parentCollectionName = sender as! String
        }
    }
    
    func getCollectionNames() {
        if (UserDefaults.standard.isLoggedIn()) {
            
            let userID = Auth.auth().currentUser!.uid
            db.collection("users").document(userID).collection("CollectionNames").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents")
                } else {
                    for document in querySnapshot!.documents {
                        if (!self.collectionNames.contains(where: {$0 == document.documentID})) {
                            self.collectionNames.append(document.documentID)
                        }
                    }
                }
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionNameCell", for: indexPath) as! collectionNameCell
        let collectionName = collectionNames[indexPath.row]
        cell.collectionName.text = collectionName
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "intoStaticCollection", sender: collectionNames[indexPath.row])
    }
}

class collectionNameCell: UITableViewCell {

    @IBOutlet weak var collectionName: UILabel!
    
}

