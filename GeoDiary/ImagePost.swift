//
//  ImagePost.swift
//  GeoDiary
//
//  Created by YangLingqin on 4/5/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation

import UIKit

class imagePost {
    
    var image = UIImage()
    var downloadURL = String()
    var caption = String()
    
    init(image: UIImage, caption: String) {
        self.image = image
        self.caption = caption
    }
    
    func save() {
        
    }
    
}

