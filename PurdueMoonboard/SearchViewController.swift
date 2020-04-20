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
    
    @IBOutlet weak var vGrade: UILabel!
    @IBOutlet weak var searchTabs: UISegmentedControl!
    
    @IBOutlet weak var gradeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vGrade.text = "V0"
        vGrade.textColor = findVGradeColor(vGrade: vGrade.text ?? "V0")
        
        // Do any additional setup after loading the view.
    }
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
