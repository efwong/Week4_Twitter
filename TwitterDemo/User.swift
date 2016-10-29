//
//  User.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/29/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenName: String?
    var profileURL: URL?
    var tagLine: String?
    
    init(dictionary: NSDictionary){
        // models take care of serialization of data
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagLine = dictionary["description"] as? String
        if let profileURLString = dictionary["profile_image_url_https"] as? String{
            profileURL = URL(string: profileURLString)
        }
    }
}
