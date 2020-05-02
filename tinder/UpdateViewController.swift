//
//  UpdateViewController.swift
//  tinder
//
//  Created by Semi Ismaili on 5/1/20.
//  Copyright © 2020 Semi Ismaili. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isInterestedInWomen, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFileObject{
            photo.getDataInBackground(block: { (data, error) in
                if let imageData = data{
                    if let image = UIImage(data: imageData){
                        self.profileImageView.image = image
                    }
                }
            })
        }
    }

    @IBAction func updateImageTapped(_ sender: Any) {	
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image {
            if let imageData = UIImagePNGRepresentation(image){
                
                PFUser.current()?["photo"] =  PFFileObject(name: "profile.png", data: imageData)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Update Failed - Try Again"
                        
                        if let newError =  error as NSError?{
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage =  detailError
                            }
                        }
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                        
                    }else{
                        print("Update succesful!")
                        self.performSegue(withIdentifier: "updateToSwipeSegue", sender: nil)
                    }
                })
            }
        }
        
    }
    
}
