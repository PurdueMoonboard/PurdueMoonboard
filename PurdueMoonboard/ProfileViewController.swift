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

class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    fileprivate let headerId = "headerId"
    
    var posts = [PFObject]()
    var user = [PFObject]()
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
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.posts = self.posts.reversed()
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderView", for: indexPath) as! ProfileHeaderView
        
        header.Username.text = PFUser.current()?.username
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
