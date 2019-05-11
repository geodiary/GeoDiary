//
//  LocationInfoView.swift
//  GeoDiary
//
//  Created by Sabah Siddique on 5/10/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class LocationInfoView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addRoundedCornersAndShadows() {
        layer.cornerRadius = 8
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
}
