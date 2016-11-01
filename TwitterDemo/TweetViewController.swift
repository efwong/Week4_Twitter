//
//  TweetViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/31/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, CreateTweetDelegate {

    @IBOutlet weak var userImageVIew: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweetUI()
        // Do any additional setup after loading the view.
        
        
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onRetweetTapped(gestureRecognizer:)))
        self.retweetImage.addGestureRecognizer(retweetTapGestureRecognizer)
        
        let replyTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onReplyTapped(gestureRecognizer:)))
        self.replyImage.addGestureRecognizer(replyTapGestureRecognizer)
        
        let favoriteTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onFavoriteTapped(gestureRecognizer:)))
        self.favoriteImage.addGestureRecognizer(favoriteTapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTweetUI(){
        
        self.nameLabel.text = tweet?.user?.name
        self.screenNameLabel.text = "@\((tweet?.user?.screenName) ?? "")"
        self.descriptionLabel.text = tweet?.text
        self.retweetLabel.text = "\((tweet?.retweetCount) ?? 0)"
        self.favoritesLabel.text = "\((tweet?.favoriteCount) ?? 0)"
        
        // load image view
        if let userImageUrl = tweet?.user?.profileURL{
            self.userImageVIew.setImageWith(userImageUrl)
        }
        
        if let dateObj = tweet?.timeStamp{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat="MM-dd-yyyy"
            self.dateLabel.text = dateFormatter.string(from: dateObj)
        }
    }

    
    func onRetweetTapped(gestureRecognizer: UITapGestureRecognizer){
        if let idStr = tweet?.idStr{
            TwitterClient.sharedInstance?.retweet(idStr: idStr, success: {
                () in
                print(123)
                }, failure: {
                    (error: Error) in
                    print("\(error.localizedDescription)")
            })
        }
    }
    
    func onReplyTapped(gestureRecognizer: UITapGestureRecognizer){
        performSegue(withIdentifier: "ToCreateTweet", sender: nil)
    }
    
    func onFavoriteTapped(gestureRecognizer: UITapGestureRecognizer){
        if let idStr = tweet?.idStr{
            TwitterClient.sharedInstance?.favorite(idStr: idStr, success: {
                () in
                print(1)
                }, failure: {
                    (error: Error) in
                    print("\(error.localizedDescription)")
            })
        }
    }
    
    func createTweet(){
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ToCreateTweet" {
            if let navigationCtrl = segue.destination as? UINavigationController{
                if let createTweetModal = navigationCtrl.topViewController as? CreateTweetViewController{
                    createTweetModal.delegate = self
                    createTweetModal.replyTweet = self.tweet
                    createTweetModal.displayUser = self.tweet?.user
                }
            }
        }

    }

}
