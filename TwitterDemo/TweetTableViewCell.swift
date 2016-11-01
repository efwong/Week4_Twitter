//
//  TweetTableViewCell.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/31/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var tweet: Tweet!{
        didSet{
            self.nameLabel.text = tweet.user?.name
            self.screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            self.descriptionLabel.text = tweet.text
            
            // load image view
            if let userImageUrl = tweet.user?.profileURL{
                self.userImageView.setImageWith(userImageUrl)
            }
            
            if let dateObj = tweet.timeStamp{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat="MM-dd-yyyy"
                self.dateLabel.text = dateFormatter.string(from: dateObj)
            }
        }
    }
    
    var hasRetweeted: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        // Add tap gesture recognizer to reply, retweet, favorite
        
        let retweetTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onRetweetTapped(gestureRecognizer:)))
        self.retweetImage.addGestureRecognizer(retweetTapGestureRecognizer)
        
        let replyTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onReplyTapped(gestureRecognizer:)))
        self.replyImage.addGestureRecognizer(replyTapGestureRecognizer)
        
        let favoriteTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(onFavoriteTapped(gestureRecognizer:)))
        self.favoriteImage.addGestureRecognizer(favoriteTapGestureRecognizer)
    }
    
    func onRetweetTapped(gestureRecognizer: UITapGestureRecognizer){
        // retweet this
        if hasRetweeted == false{
            TwitterClient.sharedInstance?.retweet(idStr: tweet.idStr, success: {
                () in
                    print(1)
                    self.hasRetweeted = true
                }, failure: { 
                (error: Error) in
                    print("\(error.localizedDescription)")
            })
        }

    }
    
    func onReplyTapped(gestureRecognizer: UITapGestureRecognizer){
         print(21)
    }
    
    func onFavoriteTapped(gestureRecognizer: UITapGestureRecognizer){
         TwitterClient.sharedInstance?.favorite(idStr: tweet.idStr, success: { 
            () in
                print(1)
            }, failure: {
                (error: Error) in
                print("\(error.localizedDescription)")
         })
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
