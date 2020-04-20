//
//  SearchCell.swift
//  PurdueMoonboard
//
//  Created by Sam on 4/20/20.
//  Copyright © 2020 tarrGames(). All rights reserved.
//

import UIKit

class SearchPostCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var vGrade: UILabel!
    @IBOutlet weak var routeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
