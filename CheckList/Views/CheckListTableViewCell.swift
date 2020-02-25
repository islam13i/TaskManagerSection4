//
//  CheckListTableViewCell.swift
//  CheckList
//
//  Created by Islam on 2/9/20.
//  Copyright © 2020 Islam. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var descTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
