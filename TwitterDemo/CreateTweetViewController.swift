//
//  CreateTweetViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/31/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

@objc protocol CreateTweetDelegate{
    @objc func createTweet()
}

class CreateTweetViewController: UIViewController {

    weak var delegate:CreateTweetDelegate?
    
    var displayUser: User?
    var replyTweet: Tweet? // optional for when replying to a tweet
    
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyTweetImageView: UIImageView!
    @IBOutlet weak var replyTweetName: UILabel!
    @IBOutlet weak var replyTweetScreenName: UILabel!
    @IBOutlet weak var replyTweetDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserDisplay()
        loadReplyDisplay()
        
        if self.replyTweet == nil{
            self.navigationItem.title = "Compose"
        }else{
            self.navigationItem.title = "Reply"
        }
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetButtonTapped))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetTap(_ sender: AnyObject) {
        let replyMessage = messageTextBox.text
        let replyTweetId = replyTweet?.idStr
        
        TwitterClient.sharedInstance?.statusUpdate(status: replyMessage ?? "", replyStatusID: replyTweetId, success: {
            () in
            print("success message")
            self.delegate?.createTweet()
            self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("\(error.localizedDescription)")
        })
    }
    
    @IBAction func onCancelTap(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // load user UI
    func loadUserDisplay(){
        self.nameLabel.text = self.displayUser?.name
        self.screenNameLabel.text = "@\((self.displayUser?.screenName) ?? "" )"
        
        if let imageURL = self.displayUser?.profileURL{
            self.userImageView.setImageWith(imageURL)
        }
    }
    
    func loadReplyDisplay(){
        if self.replyTweet != nil{
            self.replyView.isHidden = false
            self.replyTweetName.text = self.replyTweet?.user?.name
            self.replyTweetScreenName.text = "@\((self.replyTweet?.user?.screenName) ?? "" )"
            self.replyTweetDescription.text = self.replyTweet?.text
            
            if let imageURL = self.replyTweet?.user?.profileURL{
                self.replyTweetImageView.setImageWith(imageURL)
            }
            
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
