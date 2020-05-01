//
//  Constants.swift
//  Flash Chat
//
//  Created by Shikhar Kumar on 1/20/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import Foundation

struct K {
    static let appName = "⚡️FlashChat"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let chatCellIdentifier = "ReusableCell"
    static let chatNibName = "MessageCell"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
