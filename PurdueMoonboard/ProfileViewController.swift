//
//  ProfileViewController.swift
//  PurdueMoonboard
//
//  Created by user921389 on 4/15/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate let headerId = "headerId"
    
    var posts = [PFObject]()
    var users = [PFObject]()

    var selectedPost = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        
    
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear called")
        let query = PFQuery(className: "Posts")
        query.whereKey("author", equalTo: PFUser.current()!)
        query.includeKeys(["author", "comments", "comments.author", "VGrade", "route_name"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.posts = self.posts.reversed()
                self.collectionView.reloadData()
            }
        }
        let q2 = PFQuery(className:"UserInfo")
        q2.whereKey("username", equalTo: PFUser.current()!.username!)
        q2.includeKeys(["username", "user", "posts", "profileImage"])
        q2.findObjectsInBackground { (users, error) in
            print(users?.count) //User count will be wrapped in optional()
            if users != nil {
                self.users = users!
                self.collectionView.reloadData()
            }
        }
        self.collectionView.reloadData()
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        print("called update header")
        header.Username.text = PFUser.current()?.username
        if(users.count > 0){
            let user = users[0]
            if user["profileImage"] != nil{
                let imageFile = user["profileImage"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                
                header.ProfileImage.af_setImage(withURL: url)
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGridCell", for: indexPath) as! ProfileGridCell

        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
            
            
        cell.posterView.af_setImage(withURL: url)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPost = true
        self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        selectedPost = false
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let Width = collectionView.bounds.width/3.0
        let Height = Width

        return CGSize(width: Width, height: Height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if selectedPost {
            let indexPath = sender as! IndexPath
            
            let detailsViewController = segue.destination as! DetailPostViewController
            print(posts[indexPath.row])
            detailsViewController.post = posts[indexPath.row]
            
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        
        
    }
    

}
