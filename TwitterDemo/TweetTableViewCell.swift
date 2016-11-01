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

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            self.nameLabel.text = tweet.user?.name
            self.screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            self.descriptionLabel.text = tweet.text
            self.retweetLabel.text = "\(tweet.retweetCount)"
            self.favoritesLabel.text = "\(tweet.favoriteCount)"
            
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

}
