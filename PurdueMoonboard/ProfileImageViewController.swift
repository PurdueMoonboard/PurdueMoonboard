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

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onUpdateButton(_ sender: Any) {
        let query = PFQuery(className: "UserInfo")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
        if error != nil {
            print(error)
        } else {
            let user = objects![0]
            let imageData = self.imageView.image!.pngData()
            let imageName:String = "\(Int.random(in:  0..<1000000))image.png"
            let file = PFFileObject(name: imageName, data: imageData!)
            
            user["profileImage"] = file
            user.saveInBackground()
            self.dismiss(animated: true, completion: nil)

        }
            
        }

    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        print("YET")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
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
