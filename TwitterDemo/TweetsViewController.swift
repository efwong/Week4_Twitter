//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/29/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateTweetDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets:[Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        
        // Initialize UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // get tweets
        getTweets(){}
        // Do any additional setup after loading the view.
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }

    // MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO get list of tweets
        return tweets.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.TweetTableViewCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets[indexPath.row]
        
        return cell
    }
    
    // Refresh lists of tweets
    func refreshControlAction(refreshControl: UIRefreshControl){
        getTweets(){
            () in
            refreshControl.endRefreshing()
        }
    }
    
    
    // get first 20 tweets
    func getTweets(completion: @escaping () -> ()){
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> ()in
            self.tweets = tweets
            self.tableView.reloadData() // update table view data
            completion()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }
    
    // MARK: CreateTweetDelegate
    // fire when saving tweet
    func createTweet() {
        // reload tweets
        getTweets(){}
    }
    
    // Unwind segue to reload table view
    @IBAction func unwindToTweetsView(segue: UIStoryboardSegue){
        getTweets(){}
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToTweetDetailView"{
            if let destinationVC = segue.destination as? TweetViewController,
                let cell = sender as? TweetTableViewCell{
                destinationVC.tweet = cell.tweet
            }
        } else if segue.identifier == "ToCreateTweet" {
            if let navigationCtrl = segue.destination as? UINavigationController{
                if let createTweetModal = navigationCtrl.topViewController as? CreateTweetViewController{
                    createTweetModal.delegate = self
                    createTweetModal.replyTweet = nil
                    createTweetModal.displayUser = User.currentUser
                }
            }
        }
    }
 

}
