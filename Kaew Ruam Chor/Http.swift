//
//  http.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 9/22/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import Foundation
import UIKit

class Http: NSObject {
    
    private let baseUrl = "https://reg.ssru.ac.th/ssru80th/api/"
    
    public func getBaseUrl() -> String {
        return baseUrl
    }
  
   
}
