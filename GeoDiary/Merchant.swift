//
//  Merchant.swift
//  GeoDiary
//
//  Created by YangLingqin on 28/4/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

class Merchant {
    var name = String()
    var documentId = String()
    var collection = String()
    var description = String()
    var reminder = String()
    var comment = String()
    
    init(name: String, documentId: String, collection: String) {
        self.name = name
        self.documentId = documentId
        self.collection = collection
    }
    
    init() {
        self.name = ""
    }
    
}
