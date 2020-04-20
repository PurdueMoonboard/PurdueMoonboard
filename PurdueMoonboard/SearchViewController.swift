//
//  SearchViewController.swift
//  PurdueMoonboard
//
//  Created by Reese Crowell on 4/19/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTabs: UISegmentedControl!
    
    @IBOutlet weak var gradeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        if searchTabs.selectedSegmentIndex == 2 {
            searchBar.isHidden = true;
            gradeSlider.isHidden = false;
        } else {
            searchBar.isHidden = false;
            gradeSlider.isHidden = true;
        }
        self.reloadInputViews()
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
