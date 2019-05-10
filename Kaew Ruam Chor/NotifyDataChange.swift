//
//  NotifyDataChange.swift
//  Kaew Ruam Chor
//
//  Created by Lapp on 20/12/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//

import Foundation
class NotifyDataChange {
    static let sharedInstance =  NotifyDataChange()
    var shouldReload:Bool = false
    var shouldReloadMap:Bool = false
    var shouldReloadPhoto:Bool = false
}
