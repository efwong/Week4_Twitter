//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/6/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, TweetsListingsDelegate {

    @IBOutlet weak var usersTimelineView: UIView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!{
        didSet{
            // load view
            self.view.layoutIfNeeded()
            
            // attach text to view
            self.nameLabel.text = user.name
            self.screenNameLabel.text = "@\(user.screenName!)"
            self.tweetsCountLabel.text = "\(user.tweetsCount)"
            self.followingCountLabel.text = "\(user.followingCount)"
            self.followersCountLabel.text = "\(user.followersCount)"
            
            // load image view
            if let userImageUrl = user.profileURL{
                self.userImageView.setImageWith(userImageUrl)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tweetsStoryboard = UIStoryboard(name: "Tweets", bundle: nil)
        /*
        
        let testViewController = tweetsStoryboard.instantiateViewController(withIdentifier: "Test123")
        
        self.addChildViewController(testViewController)
        testViewController.willMove(toParentViewController: self)
        // forces views to load
        self.view.layoutIfNeeded()
        //self.view.layoutSubviews()
        self.usersTimelineView.addSubview(testViewController.view)
        //self.view.addSubview(testViewController.view)
        testViewController.didMove(toParentViewController: self)*/
        
        
        // add tweets view controller
        let tweetsViewController = tweetsStoryboard.instantiateViewController(withIdentifier: "TweetsStoryboardViewController") as! TweetsViewController
        tweetsViewController.tweetsListingsDelegate = self
        
        // use this to connect tweetsViewController to current navigationController
        // allows it to hook into nav history and use correct segues
        self.addChildViewController(tweetsViewController)
        tweetsViewController.willMove(toParentViewController: self)
        self.view.layoutIfNeeded()
        //self.view.addSubview(tweetsViewController.view)
        self.usersTimelineView.addSubview(tweetsViewController.view)
        tweetsViewController.didMove(toParentViewController: self)
        
        
        // load User Profile Banner
        loadProfileBanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // callback to fetch user timeline tweets
    func getTweetsFunction(success: @escaping ([Tweet]) -> (), failure: @escaping (Error)->()){
        //let userId = User.currentUser?.userIdStr
        //userTimeLine(userId: userId!,
        TwitterClient.sharedInstance?.userTimeLine(userId: nil, success: { (tweets: [Tweet]) -> ()in
            success(tweets)
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
                failure(error)
        })
    }
    
    func loadProfileBanner(){
        if user != nil{
            TwitterClient.sharedInstance?.getUserProfileBanner(userIdString: user.userIdStr, success: { (url: URL) in
                    self.bannerImageView.setImageWith(url)
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
