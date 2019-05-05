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

    
    var textViewPlaceholderText = "What's on your mind?"
    var takenImage: UIImage!
    
    var merchantInfo = Merchant()
    var imagePicker: UIImagePickerController!
    var didShowCamera = false
    
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

    @IBAction func uploadPhoto(_ sender: Any) {
        if captionTextView.text != textViewPlaceholderText && captionTextView.text != "" && takenImage != nil {
            //let newPost = Post(image: self.takenImage, caption: self.captionTextView.text)
            //newPost.save()
            
            self.dismiss(animated: true, completion: nil)
        }
        
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
            textView.textColor = .white
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
