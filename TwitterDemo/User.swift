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
    //var profileBannerURL: URL?
    var tagLine: String?
    var userIdStr: String
    var followersCount: Int
    var tweetsCount: Int // statuses_count
    var followingCount: Int // friends_count
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        // models take care of serialization of data
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagLine = dictionary["description"] as? String
        userIdStr = (dictionary["id_str"] as? String) ?? ""
        
        tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
        
        if let profileURLString = dictionary["profile_image_url_https"] as? String{
            profileURL = URL(string: profileURLString)
        }
        
//        if let profileBackgroundURLString = dictionary["profile_background_image_url_https"] as? String{
//            profileBackgroundURL = URL(string: profileBackgroundURLString)
//        }
    }
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")

    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if _currentUser == nil{
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let localDictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    if let localDictionary = localDictionary{
                        _currentUser = User(dictionary: localDictionary)
                    }
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            // cheese turn user back into json
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(data, forKey: "currentUserData")
                
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
            
            //defaults.synchronize() // save to disk
        }
    }
}
