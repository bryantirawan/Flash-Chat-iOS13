//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Bryant Irawan on 2/28/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation

struct K { //often developers name this struct K instead of struct Constants
    static let appName = "FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
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

//static lets you avoid having to do something like let constantsManager = Constants()
//instead, you can just do Constants.registerSegue in RegisterViewController
//static also works for functions such as static func method() in struct Constants{}
