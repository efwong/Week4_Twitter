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
        self.view.addSubview(tweetsViewController.view)
        //self.usersTimelineView = tweetsViewController.view
        tweetsViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // callback to fetch user timeline tweets
    func getTweetsFunction(success: @escaping ([Tweet]) -> (), failure: @escaping (Error)->()){
        let userId = User.currentUser?.userIdStr
        //userTimeLine(userId: userId!,
        TwitterClient.sharedInstance?.userTimeLine(userId: userId!, success: { (tweets: [Tweet]) -> ()in
            success(tweets)
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
                failure(error)
        })
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
