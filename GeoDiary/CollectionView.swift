//
//  CollectionView.swift
//  GeoDiary
//
//  Created by YangLingqin on 27/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//


import UIKit

import Firebase

import GoogleSignIn

class CollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionnameCell", for: indexPath) as! collectionnameCell
        let collectionName = collectionNames[indexPath.row]
        
        cell.collectionName.text = collectionName
        //print("Array is populated \(collectionNames)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "intoCollection", sender: collectionNames[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scv = segue.destination as! SpecificCollectionView
        scv.parentCollectionName = sender as! String
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var db : Firestore!
    var collectionNames = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getCollectionNames()
        
        
    }
    
    private func getCollectionNames() {
        if(UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            db.collection("users").document(userID).collection("CollectionNames").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        self.collectionNames.append(document.documentID)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func GoogleSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            
            self.dismiss(animated: true, completion: nil)
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    
}


class collectionnameCell: UITableViewCell {
    
    @IBOutlet weak var collectionName: UILabel!
    
}
