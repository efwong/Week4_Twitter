//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/29/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "RiicizFj4o1dmSgPgldMzi3am", consumerSecret: "h8WkmYl7xbTCT7PV5HlO6r8VeuDkmzKScMFBqlFbxyzt21vmdp")
    
    func homeTimeLine(){
        this.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let dictionaries = response as? [NSDictionary]{
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                for tweet in tweets{
                    print("\(tweet.text)")
                }
            }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print("failed home timeline")
        })
    }
    
    func currentAccount(){
        this.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let userDictionary = response as? NSDictionary{
                let user = User(dictionary: userDictionary)
                
                print("name: \(user.name)")
                print("screen_name: \(user.screenName)")
                print("profile_url: \(user.profileURL)")
            }
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print("failed verification")
        })
    }
}
