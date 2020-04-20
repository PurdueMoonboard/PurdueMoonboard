//
//  ProfileImageViewController.swift
//  PurdueMoonboard
//
//  Created by user921389 on 4/20/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUpdateButton(_ sender: Any) {
        let query = PFQuery(className: "UserInfo")
        query.getObjectInBackground(withId: PFUser.current()!.objectId!){
            (user: PFObject?,error: Error?) in
             if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                let imageData = self.profileImage.image!.pngData()
                let imageName:String = "\(Int.random(in:  0..<1000000))image.png"
                let file = PFFileObject(name: imageName, data: imageData!)
                
                user["profileImage"] = file
                user.saveInBackground()
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        profileImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
