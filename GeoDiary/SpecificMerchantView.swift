//
//  SpecificMerchantView.swift
//  GeoDiary
//
//  Created by YangLingqin on 28/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class SpecificMerchantView: UIViewController {
    
    var merchantInfo = Merchant()

    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var merchantDescription: UITextView!
    @IBOutlet weak var merchantName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchantName.text = merchantInfo.name
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "editMerchant", sender: nil)
        
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
