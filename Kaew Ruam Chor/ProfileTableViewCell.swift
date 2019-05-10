//
//  ProfileTableViewCell.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 18/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var myFullName: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
