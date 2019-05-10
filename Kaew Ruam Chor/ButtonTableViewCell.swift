//
//  ButtonTableViewCell.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 18/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var myButton: UIButton!
    var onButtonTapped : (() -> Void)? = nil

    @IBAction func onClicked(_ sender: Any) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
