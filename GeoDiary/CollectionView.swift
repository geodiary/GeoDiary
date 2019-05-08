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

class CollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCollection = collectionNames.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCollection.count
        } else {
            return collectionNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionnameCell", for: indexPath) as! collectionnameCell
        
        if searching {
            cell.collectionName.text = searchCollection[indexPath.row]
        } else {
            let collectionName = collectionNames[indexPath.row]
            cell.collectionName.text = collectionName
        }
        
        //print("Array is populated \(collectionNames)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "intoCollection", sender: collectionNames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.cleanupDatabase(collectionToDel: self.collectionNames[indexPath.row])
            self.collectionNames.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        return action
        
    }
    
    private func cleanupDatabase(collectionToDel: String) {
        let userID = Auth.auth().currentUser!.uid
        
        db.collection("users").document(userID).collection("CollectionNames").document(collectionToDel).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "intoCollection") {
        let scv = segue.destination as! SpecificCollectionView
            scv.parentCollectionName = sender as! String}
        else if(segue.identifier == "addNewMerchant") {
            let anmv = segue.destination as! AddNewMerchantView
            anmv.collectionNames = sender as! [String]
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var db : Firestore!
    var collectionNames = [String] ()
    var searchCollection = [String] ()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        getCollectionNames()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleModalDismissed),
                                               name: NSNotification.Name(rawValue: "modalIsDimissed"),
                                               object: nil)
        
        
    }
    
    @objc func handleModalDismissed() {
        getCollectionNames()
        self.tableView.reloadData()
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
                        if(!self.collectionNames.contains(where: { $0 == document.documentID }))
                        {
                            self.collectionNames.append(document.documentID)
                            
                        }
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
    
    
    @IBAction func addNewPlace(_ sender: Any) {
        performSegue(withIdentifier: "addNewMerchant", sender: collectionNames)
        
    }
    
    
    
    
}



class collectionnameCell: UITableViewCell {
    
    @IBOutlet weak var collectionName: UILabel!
    
}

