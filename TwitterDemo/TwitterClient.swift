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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeLine(success:@escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let dictionaries = response as? [NSDictionary]{
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
            }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    func currentAccount(){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
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
    
    
    // Run this to login
    func login(success: @escaping () -> (), failure: @escaping (Error) -> () ){
        self.loginSuccess = success
        self.loginFailure = failure
        
        self.deauthorize()
        self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            // request token
            //print("I got a token")
            if let unwrappedToken = requestToken?.token{
                let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(unwrappedToken)"
                let url = URL(string: urlString)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
                if let error = error{
                    self.loginFailure?(error)
                }
            }
        )
    }
    
    func handleOpenUrl(url: URL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // get access token
        // can make api requests with access tokens
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { ( accessToken: BDBOAuth1Credential?) in
            print("login success, got access token")
            self.loginSuccess?()
            
            
            //self.currentAccount()
            
//            client?.homeTimeLine(success: { (tweets: [Tweet]) -> ()in
//                for tweet in tweets {
//                    print(tweet.text)
//                }
//                }, failure: { (error: Error) -> () in
//                    print(error.localizedDescription)
//            })
            
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
                if let error = error{
                    self.loginFailure?(error)
                }
            }
        )
        
    }
}
