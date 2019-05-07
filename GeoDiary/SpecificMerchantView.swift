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

class SpecificMerchantView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! photoCell
        
        cell.caption.text = photos[indexPath.row].caption
        cell.photo.image = photos[indexPath.row].image
        cell.caption.backgroundColor = .white

        //cell.setCustomImage(image: photos[indexPath.row].image)
        
        
        return cell
        
    }
    
   
    var db : Firestore!
    var merchantInfo = Merchant()
    var photos = [Media]()
    
  
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotos: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var merchantDescription: UITextView!
    @IBOutlet weak var merchantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    
        
        getPhotos()
        
        merchantName.text = merchantInfo.name
        
        
        // Do any additional setup after loading the view.
    }
    
 
    
    private func getPhotos() {
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection(merchantInfo.collection).document(merchantInfo.documentId).collection("photos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if( querySnapshot?.count ?? 0 > 0) {
                    for document in querySnapshot!.documents {
                        let media = Media()
                        media.caption = document.get("caption") as! String
                        media.downloadURL = document.get("imageDownloadURL") as! String
                        
                        print("\(document.documentID) & \(self.merchantInfo.name)=> \(media.downloadURL)")
                        
                        
                        // download image
                        if(media.downloadURL != "") {
                        let httpsReference = Storage.storage().reference(forURL: media.downloadURL)
                        httpsReference.getData(maxSize: 100 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("error => \(error)")
                            } else {
                                // Data for "images/island.jpg" is returned
                                print("image gotten")
                                let image = UIImage(data: data!)
                                media.image = image
                                if(!self.photos.contains(where: { $0.downloadURL == media.downloadURL }))
                                {
                                    if(media.downloadURL != "") {
                                        self.photos.append(media)
                                    }
                                }
                                    self.tableView.reloadData()
                            }
                            
                            }
                            
                        }
                    }
                }
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        }
    
        
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

class photoCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var caption: UILabel!

    
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                photo.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                photo.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setCustomImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: photo, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: caption, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        //aspectConstraint = constraint
        
        photo.image = image
    }
    
}


