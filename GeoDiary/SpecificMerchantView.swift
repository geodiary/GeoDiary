//
//  SpecificMerchantView.swift
//  GeoDiary
//
//  Created by YangLingqin on 28/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class SpecificMerchantView: UIViewController {
    
    var merchantInfo = Merchant()

    

    @IBOutlet weak var addPhotos: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var merchantDescription: UITextView!
    @IBOutlet weak var merchantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    
        
        merchantName.text = merchantInfo.name
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhotos(_ sender: Any) {
        performSegue(withIdentifier: "addPhoto", sender: merchantInfo)
    }
    
    
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editMerchant", sender: merchantInfo)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editMerchant") {
        let emv = segue.destination as! EditMerchantView
            emv.merchantInfo = sender as! Merchant}
        else if(segue.identifier == "addPhoto") {
            let apv = segue.destination as! AddPhotoView
            apv.merchantInfo = sender as! Merchant
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
