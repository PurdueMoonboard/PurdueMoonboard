//
//  CameraViewControllerViewController.swift
//  PurdueMoonboard
//
//  Created by Sam on 4/5/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var vGradeLabel: UILabel!
    @IBOutlet weak var routeNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["VGrade"] = vGradeLabel.text!
        post["route_name"] = routeNameField.text!
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()
        
        let imageData = imageView.image!.pngData()
        let imageName:String = "\(Int.random(in:  0..<1000000))image.png"
        let file = PFFileObject(name: imageName, data: imageData!)
        
        post["image"] = file
        
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                
                print("saved")
            } else {
                print("notsaved error")
            }
        }
    }
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        if currentValue < 1 {
            vGradeLabel.textColor = .purple
        } else if currentValue < 3 {
            vGradeLabel.textColor = .blue
        } else if currentValue < 5 {
            vGradeLabel.textColor = .green
        } else if currentValue < 6 {
            vGradeLabel.textColor = .yellow
        } else if currentValue < 9 {
            vGradeLabel.textColor = .red
        } else {
            vGradeLabel.textColor = .orange
        }
        vGradeLabel.text = "V\(currentValue)"
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
