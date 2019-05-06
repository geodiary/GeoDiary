//
//  ViewController.swift
//  GeoDiary
//
//  Created by YangLingqin on 19/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    var db : Firestore!
    
    private func getCollection () {
        if(UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            print(userID)
            db.collection("users").document(userID).collection("Brunch").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        getCollection()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.standard.isLoggedIn()) {
            performSegue(withIdentifier: "loggedin", sender: self)
        }
    }
    
    
    @IBAction func signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    


}

