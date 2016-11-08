//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/29/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

@objc protocol TweetsListingsDelegate{
    @objc func getTweetsFunction(success: @escaping ([Tweet]) -> (), failure: @escaping (Error)->())
}

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var tweetsListingsDelegate: TweetsListingsDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets:[Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.tableFooterView = UIView()
        
        
        // Initialize UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // get tweets
        reloadDataAndTable()
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTweetProfileImageTap(_:)))
        cell.userImageView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    // Refresh lists of tweets
    func refreshControlAction(refreshControl: UIRefreshControl){
        
        self.getTweets(success: {}, always: {
            refreshControl.endRefreshing()
        })
    }
    
    
    // get first 20 tweets
    func getTweets(success: @escaping () -> (), always: @escaping () -> ()){
        self.tweetsListingsDelegate?.getTweetsFunction(success: { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
                success()
                always()
            }, failure: { (error: Error) in
                always()
        })
    }
    
    // Reload data and update table with new tweets
    func reloadDataAndTable(){
        self.getTweets(success: {}, always: {})
    }
    
    // Unwind segue to reload table view
//    @IBAction func unwindToTweetsView(segue: UIStoryboardSegue){
//        reloadDataAndTable()
//    }
    
    
    // Triggered when tapping the profile image of a tweet
    // segue into profile view for that user
    func onTweetProfileImageTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: tapLocation){
            let cell = self.tableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: "ToProfileView", sender: cell)
        }
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
        }
        else if segue.identifier == "ToProfileView"{
            if let destinationVC = segue.destination as? ProfileViewController,
                let cell = sender as? TweetTableViewCell{
                destinationVC.user = cell.tweet.user
                destinationVC.IsFromExternalViewController = true
            }
        }
    }
 

}
