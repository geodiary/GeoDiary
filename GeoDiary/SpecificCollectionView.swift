//
//  SpecificCollectionView.swift
//  GeoDiary
//
//  Created by YangLingqin on 28/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class SpecificCollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantnameCell", for: indexPath) as! merchantnameCell
        let merchantName = merchants[indexPath.row].name
        
        cell.merchantName.text = merchantName
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "intoMerchant", sender: merchants[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let smv = segue.destination as! SpecificMerchantView
        smv.merchantInfo = sender as! Merchant
    }
    
    
    var parentCollectionName = String()
    var db : Firestore!
    var merchants = [Merchant] ()
    
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(parentCollectionName)
        collectionName.text = parentCollectionName
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getMerchants()

        // Do any additional setup after loading the view.
    }
    
    private func getMerchants() {
        if(UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            
            db.collection("users").document(userID).collection(parentCollectionName).getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let merchant = Merchant(name: document.get("name") as! String)
                        self.merchants.append(merchant)
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
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

class merchantnameCell: UITableViewCell {
    
    @IBOutlet weak var merchantName: UILabel!
    
}
