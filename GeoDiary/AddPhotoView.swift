//
//  AddPhotoView.swift
//  GeoDiary
//
//  Created by YangLingqin on 4/5/2019.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

import Firebase

import GoogleSignIn

class AddPhotoView: UIViewController {
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    var db : Firestore!
    var textViewPlaceholderText = "What's on your mind?"
    var takenImage: UIImage!
    
    var merchantInfo = Merchant()
    var imagePicker: UIImagePickerController!
    var didShowCamera = false
    var photoID = String()
    var downloadURL = String()
    
    var addedPhoto = Media()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didShowCamera {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
            } else {
                imagePicker.sourceType = .photoLibrary
            }
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        
        
        captionTextView.text = textViewPlaceholderText
        captionTextView.textColor = .lightGray
        captionTextView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func save (merchant: Merchant) {
        
        
        let userID = Auth.auth().currentUser!.uid
        //Get a photo id first from cloud Firestore.
        // Add a new document with a generated id.
        print("users/\(userID)/\(merchant.collection)/\(merchant.documentId)/photos")
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(userID).collection(merchant.collection).document(merchant.documentId).collection("photos").addDocument(data: ["imageDownloadURL":"", "caption":captionTextView.text])
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
            }
        }
        self.photoID = ref!.documentID
        
        // Points to the root reference
        print(self.photoID)
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("\(userID)/\(merchant.collection)/\(merchant.name)/\(self.photoID)")
        print(imageRef)
        //let imageRef = storageRef.child("whatthefuck.jpg")
        if let imageData = self.takenImage.jpegData(compressionQuality: 1.0) {
            
            let metadata = StorageMetadata()
            
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("error: \(error)")
                    return
                }
                print("error: \(error)")
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                imageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                        
                    }
                    self.downloadURL = url?.absoluteString ?? "can't get url"
                    print("url is \(self.downloadURL)")
                    //Update the photo download URL in cloud Firestore.
                    self.db.collection("users").document(userID).collection(merchant.collection).document(merchant.documentId).collection("photos").document(self.photoID)
                        .updateData([
                            "imageDownloadURL": self.downloadURL
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                    }
                }
                
            }
        }
        
        

    }
    
    @IBAction func uploadPhotos(_ sender: Any) {
        if captionTextView.text != textViewPlaceholderText && captionTextView.text != "" && takenImage != nil {
            //let newPost = imagePost(image: self.takenImage, caption: self.captionTextView.text)
            //newPost.save(merchant: self.merchantInfo)
            save(merchant: merchantInfo)
            
            self.dismiss(animated: true, completion: nil)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        addedPhoto.downloadURL = self.downloadURL
        addedPhoto.caption = self.captionTextView.text
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddPhotoView : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholderText {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

extension AddPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.takenImage = image
            self.postImageView.image = takenImage
            didShowCamera = true
            self.dismiss(animated: true, completion: nil)
            
        } else {
            print("Not able to get an image")
        }
        
    }
}
