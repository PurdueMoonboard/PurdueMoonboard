//
//  DetailPostViewController.swift
//  PurdueMoonboard
//
//  Created by Sam on 4/22/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class DetailPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate  {
    
    var showsCommentBar = false
    let commentBar = MessageInputBar()
    
    var post: PFObject?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object:  nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = self.post
        let comments = (post?["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.post
        let comments = (post?["comments"] as? [PFObject]) ?? []
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            
            let user = post?["author"] as! PFUser
            cell.usernameLabel.text = user.username
            cell.vGrade.text = post?["VGrade"] as? String
            cell.vGrade.textColor = findVGradeColor(vGrade: cell.vGrade.text ?? "V0")
            let routeName = post?["route_name"] as? String
            cell.routeName.text = "Route: " + (routeName ?? "No Name")
            cell.commentLabel.text = post?["caption"] as? String
            
            let imageFile = post?["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.usernameLabel.text = user.username
        
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comments = (post?["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            if self.traitCollection.userInterfaceStyle == .dark {
                commentBar.inputTextView.textColor = .black
            }
        }
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = post
        comment["author"] = PFUser.current()!

        post?.add(comment, forKey: "comments")
        
        post?.saveInBackground { (succes, error) in
            if succes {
                print("Comment was saved \(String(describing: comment["text"]))")
            } else {
                print("Comment wasnt saved")
            }
        }
        tableView.reloadData()
        //Clear and dismiss input bar
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func findVGradeColor(vGrade: String) -> UIColor{
        var mutatedGrade = vGrade
        mutatedGrade.remove(at: mutatedGrade.firstIndex(of: "V") ?? mutatedGrade.startIndex)
        
        let grade = Int(mutatedGrade) ?? 0
        if grade < 1 {
            return .purple
        } else if grade < 3 {
            return .blue
        } else if grade < 5 {
            return .green
        } else if grade < 6 {
            return .yellow
        } else if grade < 9 {
            return .red
        } else {
            return .orange
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
