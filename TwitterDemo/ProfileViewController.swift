//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/6/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, TweetsListingsDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    var IsFromExternalViewController:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !IsFromExternalViewController{
            // add bar button item
            let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutButton))
            self.navigationItem.leftBarButtonItem = logoutButton
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        // load User Profile Banner
        loadProfileBanner()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // callback to fetch user timeline tweets
    func getTweetsFunction(success: @escaping ([Tweet]) -> (), failure: @escaping (Error)->()){
        let userId = user.userIdStr
        //userTimeLine(userId: userId!,
        TwitterClient.sharedInstance?.userTimeLine(userId: userId, success: { (tweets: [Tweet]) -> ()in
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTweetsViewController"{
            if let destinationVC = segue.destination as? TweetsViewController{
                destinationVC.tweetsListingsDelegate = self
            }
        }
    }

    func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
}
