//
//  TestTableViewCell.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 17/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var myText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
