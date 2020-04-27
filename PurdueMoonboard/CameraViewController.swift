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
import MessageInputBar

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MessageInputBarDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var vGradeLabel: UILabel!
    @IBOutlet weak var routeNameField: UITextField!
    
    var commentBar = MessageInputBar()
    var showsCommentBar = false
    var currentField: UITextField!
    var openingCamera = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Set"
        commentBar.delegate = self
        
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object:  nil)
    }
    override var inputAccessoryView: UIView? {
        if !openingCamera {
            return commentBar
        } else {
            return nil
        }
    }
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
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
        
        let query = PFQuery(className: "UserInfo")
        query.whereKey("username", equalTo: PFUser.current()!["username"] as Any)
        query.findObjectsInBackground() { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                print("got user info \(objects.count)")
                for object in objects {
                    post["userInfo"] = object
                    object.add(post, forKey: "posts")
                    object.saveInBackground { (succes, error) in
                        if succes {
                            print("post was saved")
                        } else {
                            print("Comment wasnt saved")
                        }
                    }
                }
                
            }
        }
        
        
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
        
        openingCamera = true
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .fullScreen
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
    
    @objc func keyboardWillBeHidden(note: Notification) {
           commentBar.inputTextView.text = nil
           showsCommentBar = false
           becomeFirstResponder()
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        currentField.text = text
        //Clear and dismiss input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    @IBAction func onRouteName(_ sender: UITextField) {
        openingCamera = false
        currentField = sender
        showsCommentBar = true
        sender.becomeFirstResponder()
        sender.resignFirstResponder()
        commentBar.inputTextView.becomeFirstResponder()
        if self.traitCollection.userInterfaceStyle == .dark {
            commentBar.inputTextView.textColor = .black
        }
        
        
    }
    @IBAction func onCaption(_ sender: UITextField) {
        openingCamera = false
        currentField = sender
        showsCommentBar = true
        sender.becomeFirstResponder()
        sender.resignFirstResponder()
        commentBar.inputTextView.becomeFirstResponder()
        if self.traitCollection.userInterfaceStyle == .dark {
            commentBar.inputTextView.textColor = .black
        }
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
