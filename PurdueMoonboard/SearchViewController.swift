//
//  SearchViewController.swift
//  PurdueMoonboard
//
//  Created by Reese Crowell on 4/19/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [PFObject]()
    var searchedPosts = [PFObject]()

    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var vGrade: UILabel!
    @IBOutlet weak var searchTabs: UISegmentedControl!
    
    @IBOutlet weak var gradeSlider: UISlider!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        vGrade.text = "V0"
        vGrade.textColor = findVGradeColor(vGrade: vGrade.text ?? "V0")
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author", "VGrade", "route_name"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.posts = self.posts.reversed()
                self.tableView.reloadData()
            }
        }
    }
    //MARK: Keyboard functions
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        dismissKeyboard()
    }
    
    //MARK: Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ran \(searchedPosts.count)")
        return searchedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        let post = searchedPosts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.vGrade.text = post["VGrade"] as? String
        cell.vGrade.textColor = findVGradeColor(vGrade: cell.vGrade.text ?? "V0")
        let routeName = post["route_name"] as? String
        cell.routeNameLabel.text = "Route: " + (routeName ?? "No Name")
        return cell
    }
    //MARK: Search functions
    @IBAction func onSearch(_ sender: Any) {
        searchedPosts = [PFObject]()
        if searchTabs.selectedSegmentIndex == 2 {
            let grade = Int(gradeSlider.value)
            for i in 0..<posts.count {
                let post = posts[i]
                var mutatedGrade: String = post["VGrade"] as? String ?? "V0"
                mutatedGrade.remove(at: mutatedGrade.firstIndex(of: "V") ?? mutatedGrade.startIndex)
                
                let postGrade = Int(mutatedGrade)
                if postGrade == grade {
                    print("found one")
                    searchedPosts.append(post)
                }
            }
        } else if searchTabs.selectedSegmentIndex == 1 {
            for i in 0..<posts.count {
                let post = posts[i]
                var routeName = searchBar.text ?? ""
                routeName = routeName.lowercased()
                var postRouteName = post["route_name"] as? String ?? "no name"
                postRouteName = postRouteName.lowercased()
                if postRouteName.contains(routeName) {
                    searchedPosts.append(post)
                }
            }
        } else {
            // This needs to be changed to loop through users instead of posts
            for i in 0..<posts.count {
                let post = posts[i]
                var username = searchBar.text ?? ""
                username = username.lowercased()
                var postName = post["author"] as? String ?? ""
                postName = postName.lowercased()
                if postName.contains(username) {
                    searchedPosts.append(post)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    //MARK: Slider Functions
    @IBAction func onSliderChanged(_ sender: Any) {
        let vGradeValue = round(gradeSlider.value)
        gradeSlider.setValue(vGradeValue, animated: false)
        vGrade.text = "V\(Int(vGradeValue))"
        vGrade.textColor = findVGradeColor(vGrade: vGrade.text ?? "V0")
        
        vGrade.reloadInputViews()
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        if searchTabs.selectedSegmentIndex == 2 {
            searchBar.isHidden = true;
            gradeSlider.isHidden = false;
            vGrade.isHidden = false;
        } else {
            searchBar.isHidden = false;
            gradeSlider.isHidden = true;
            vGrade.isHidden = true;
        }
        self.reloadInputViews()
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
