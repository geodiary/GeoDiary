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

class SpecificCollectionView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    //Search Bar set up
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchMerchants = merchantsName.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    
    
    
    //Table view set up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchMerchants.count
        } else {
            return merchants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "merchantnameCell", for: indexPath) as! merchantnameCell
        
        if searching  {
            cell.merchantName.text = searchMerchants[indexPath.row]
        } else {
            let merchantName = merchants[indexPath.row].name
            cell.merchantName.text = merchantName
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "intoMerchant", sender: merchants[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath)->UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.cleanupDatabase(merchantToDel: self.merchants[indexPath.row])
            self.merchants.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .red
        return action
    
    }
    
    private func cleanupDatabase(merchantToDel: Merchant) {
        let userID = Auth.auth().currentUser!.uid
        let storageRef = Storage.storage().reference()
        db.collection("users").document(userID).collection(merchantToDel.collection).document(merchantToDel.documentId).collection("photos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.photoID.append(document.documentID)
                    print("photoID => \(document.documentID)")
                }
                print("\(self.photoID.count)")
                for photo in self.photoID {
                    // Create a reference to the file to delete
                    //let desertRef = storageRef.child("desert.jpg")
                    let imageRef = storageRef.child("\(userID)/\(merchantToDel.collection)/\(merchantToDel.name)/\(photo)")
                    
                    
                    // Delete the file
                    imageRef.delete { error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print("err deleting => \(error)")
                        } else {
                            // File deleted successfully
                            print("successfully delete")
                        }
                    }
                    
                    print("photo \(photo) deleted");
                    self.db.collection("users").document(userID).collection(merchantToDel.collection).document(merchantToDel.documentId).collection("photos").document(photo).delete() {err in
                        if let err = err {
                            print("Error removing photo: \(err)")
                        } else {
                            print("photos! successfully removed!")
                        }
                    }
                }
                
                self.db.collection("users").document(userID).collection(merchantToDel.collection).document(merchantToDel.documentId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let smv = segue.destination as! SpecificMerchantView
        smv.merchantInfo = sender as! Merchant
    }
    
    var photoID = [String] ()
    var parentCollectionName = String()
    var db : Firestore!
    var merchants = [Merchant] ()
    var merchantsName = [String] ()
    var searchMerchants = [String] ()
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        searchBar.delegate = self
        
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
                        let merchant = Merchant(name: document.get("name") as! String, documentId: document.documentID, collection: self.parentCollectionName)
                        merchant.description = document.get("description") as! String
                        merchant.comment = document.get("comment") as! String
                        merchant.reminder = document.get("reminder") as! String
                        merchant.address = document.get("address") as! String
                        self.merchants.append(merchant)
                        
                        self.merchantsName.append(merchant.name)
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
