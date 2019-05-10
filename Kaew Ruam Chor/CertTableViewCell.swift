//
//  CertTableViewCell.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 26/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit

class CertTableViewCell: UITableViewCell {

    @IBOutlet weak var facultyLabel: UILabel!
    
    @IBOutlet weak var majorLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
