//
//  MentionsViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/6/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, TweetsListingsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tweetsStoryboard = UIStoryboard(name: "Tweets", bundle: nil)
        
        // add tweets view controller
        let tweetsViewController = tweetsStoryboard.instantiateViewController(withIdentifier: "TweetsStoryboardViewController") as! TweetsViewController
        tweetsViewController.tweetsListingsDelegate = self
        //tweetsViewController.getTweetsFunction = self.getTweetsFunction
        
        // use this to connect tweetsViewController to current navigationController
        // allows it to hook into nav history and use correct segues
        self.addChildViewController(tweetsViewController)
        tweetsViewController.willMove(toParentViewController: self)
        self.view.addSubview(tweetsViewController.view)
        tweetsViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // callback to fetch mentions timeline tweets
    func getTweetsFunction(success: @escaping ([Tweet]) -> (), failure: @escaping (Error)->()){
        TwitterClient.sharedInstance?.mentionsTimeLine(success: { (tweets: [Tweet]) -> ()in
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
