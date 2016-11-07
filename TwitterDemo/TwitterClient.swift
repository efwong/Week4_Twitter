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
    
    var loginSuccess: (() -> ())? // login Success callback, just prints a statement and segues into TweetsView
    var loginFailure: ((Error) -> ())?
    
    // get home timeline tweets
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
    
    
    // Get Mentions Tweet
    func mentionsTimeLine(success:@escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let dictionaries = response as? [NSDictionary]{
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
            }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    // Get User Tweets
    func userTimeLine(userId: String? = nil, success:@escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        
        var parameters: [String : AnyObject] = [:]//"user_id": userId as AnyObject]
        if userId != nil{
            parameters["user_id"] = userId as AnyObject
        }
        
        get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let dictionaries = response as? [NSDictionary]{
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
            }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    // get user profile banner
    func getUserProfileBanner(userIdString: String, success: @escaping (URL) -> (), failure: @escaping (Error) -> ()){
        
        let parameters = ["user_id": userIdString as AnyObject]
        
        get("1.1/users/profile_banner.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let dictionary = response as? NSDictionary{
                if let sizesDictionary = dictionary["sizes"] as? NSDictionary{
                    if let mobileRetina = sizesDictionary["mobile_retina"] as? NSDictionary{
                        if let url = mobileRetina["url"] as? String{
                            success(URL(string: url)!)
                        }
                    }
                }
                
            }
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
                print("failed verification")
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            if let userDictionary = response as? NSDictionary{
                let user = User(dictionary: userDictionary)
                success(user)
                
                print("name: \(user.name)")
                print("screen_name: \(user.screenName)")
                print("profile_url: \(user.profileURL)")
            }
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
                print("failed verification")
        })
    }
    
    // post retweet
    func retweet(idStr: String, success: @escaping () -> () , failure: @escaping (Error) -> ()) {
        let relativeURL:String = "1.1/statuses/retweet/\(idStr).json"
        let parameters: [String : AnyObject] = ["id": idStr as AnyObject]
        
        post(relativeURL, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                success()
//            if let userDictionary = response as? NSDictionary{
//                success(user)
//            }
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
                print("failed retweet")
        })
    }
    
    // post Tweet
    // can be used to reply to another Tweet
    func statusUpdate(status: String, replyStatusID: String? = nil, success: @escaping () -> () , failure: @escaping (Error) -> ()) {
        let relativeURL:String = "1.1/statuses/update.json"
        var parameters: [String : AnyObject] = ["status": status as AnyObject]
        
        if let replyStatusID = replyStatusID{
            parameters["in_reply_to_status_id"] = (replyStatusID as AnyObject)
        }
        
        post(relativeURL, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
                print("failed status update")
        })
    }
    
    
    func favorite(idStr: String, success: @escaping () -> () , failure: @escaping (Error) -> ()) {
        let relativeURL:String = "https://api.twitter.com/1.1/favorites/create.json"
        let parameters = ["id": idStr]
        
        post(relativeURL, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            //            if let userDictionary = response as? NSDictionary{
            //                success(user)
            //            }
            
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
                print("failed retweet")
        })
    }
    
    // Run this to login
    func login(success: @escaping () -> (), failure: @escaping (Error) -> () ){
        self.loginSuccess = success
        self.loginFailure = failure
        
        self.deauthorize()
        self.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            // request token
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
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        // user NSNotification center to tell appdelegate to logout and segue back to Login storyboard
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // get access token
        // can make api requests with access tokens
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { ( accessToken: BDBOAuth1Credential?) in
            print("login success, got access token")
            
            // get the user info
            
            self.loginSuccess?()
            
            
            // grab current user
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: Error) in
                   self.loginFailure?(error)
            })

            
            }, failure: { (error: Error?) in
                print("error: \(error?.localizedDescription)")
                if let error = error{
                    self.loginFailure?(error)
                }
            }
        )
        
    }
}
