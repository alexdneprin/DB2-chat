//
//  Channel.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 01.07.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import Foundation
import UIKit

class Channel {
    
    var id: NSInteger = 0
    var unreadCount: NSInteger = 0
    var createdDate: String = "" //Date = Date() This should be changed
    var isRead: Bool = true
    
    var lastMessageText = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var photo: String = ""
    var userName: String = ""
    
}
