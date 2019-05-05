//
//  Media.swift
//  GeoDiary
//
//  Created by YangLingqin on 5/5/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

class Media {
    var caption = String()
    var downloadURL = String()
    var image : UIImage!
    
    init() {
        self.caption = ""
        self.downloadURL = ""
    }
    
    init(caption: String, downloadURL: String) {
        self.caption = caption
        self.downloadURL = downloadURL
    }
}

