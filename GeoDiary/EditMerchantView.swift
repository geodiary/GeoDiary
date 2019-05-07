//
//  EditMerchantView.swift
//  GeoDiary
//
//  Created by YangLingqin on 28/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class EditMerchantView: UIViewController {
    
    var merchantInfo = Merchant()
    var db : Firestore!

    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var editDescription: UITextView!
    @IBOutlet weak var editReminder: UITextView!
    @IBOutlet weak var editComment: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        editName.text = merchantInfo.name
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        if(UserDefaults.standard.isLoggedIn()) {
            let userID = Auth.auth().currentUser!.uid
            let merchantRef = db.collection("users").document(userID).collection(merchantInfo.collection).document(merchantInfo.documentId)
            
            // Set the "capital" field of the city 'DC'
            merchantRef.updateData([
                "name": editName.text
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editIsDimissed"), object: nil)
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
