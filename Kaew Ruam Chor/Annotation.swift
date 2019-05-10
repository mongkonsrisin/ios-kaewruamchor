//
//  Annotation.swift
//  Kaew Ruam Chor
//
//  Created by Mongkon Srisin on 6/26/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject,MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    var image:UIImage?
    var myid:String

    
    init(coordinate:CLLocationCoordinate2D, title:String, subtitle:String, image:UIImage?,myid:String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.myid = myid
    }
    
    
   
    }



