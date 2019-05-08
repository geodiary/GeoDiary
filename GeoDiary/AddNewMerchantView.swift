//
//  AddNewMerchantView.swift
//  GeoDiary
//
//  Created by YangLingqin on 3/5/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class AddNewMerchantView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var db : Firestore!
    var collectionNames = [String] ()
    var newMerchant = Merchant()
    var location = Location()
    
    @IBOutlet weak var collectionName: UITextField!
    @IBOutlet weak var currentCollection: UIPickerView!
    @IBOutlet weak var addComment: UITextView!
    @IBOutlet weak var addReminder: UITextView!
    @IBOutlet weak var addDescription: UITextView!
    @IBOutlet weak var addName: UITextField!
    @IBOutlet weak var address: UITextField!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return collectionNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return collectionNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        collectionName.text = collectionNames[row]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        currentCollection.dataSource = self
        currentCollection.delegate = self
        
        addName.text = location.locationName
        address.text = location.locationAddress

        // Do any additional setup after loading the view.
        newMerchant.name = location.locationName
//        newMerchant.address = location.locationAddress
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submitNew(_ sender: Any) {
        if(UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            
            let a = "users/"
            let b = "/"
            var path = String()
            path = a + userID + b + collectionName.text!
            
            let data: [String:Any] = [:]
            
            if(collectionNames.contains(collectionName.text ?? "") == false) {
                db.collection("users").document(userID).collection("CollectionNames").document(collectionName.text ?? "").setData(data)
            }
            
            
            // Add a new document with a generated id.
            var ref: DocumentReference? = nil
            ref = db.collection(path).addDocument(data:[
                "name":addName.text,
                "description": addDescription.text,
                "reminder": addReminder.text,
                "comment": addComment.text,
                "address": address.text
            ])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
            }
            
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
