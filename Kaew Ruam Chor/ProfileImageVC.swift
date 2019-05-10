//
//  ProfileImageVC.swift
//  Kaew Ruam Chor
//
//  Created by Mongkon Srisin on 7/25/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit
import Alamofire


class ProfileImageVC: UIViewController {
    
    let defaultValues = UserDefaults.standard
    var photo = ""
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (photo != "") {
            if let decodedData = Data(base64Encoded: photo, options: .ignoreUnknownCharacters) {
                self.profileImg.image = UIImage(data: decodedData)

            } else {
                self.profileImg.image = UIImage(named:"profile.png")

            }
        } else {
            self.profileImg.image = UIImage(named:"profile.png")

        }
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
 

}
