//
//  HomeTimelineViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/6/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController {

    private var tweetsViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tweetsStoryboard = UIStoryboard(name: "Tweets", bundle: nil)
        
        // add tweets view controller
        tweetsViewController = tweetsStoryboard.instantiateViewController(withIdentifier: "TweetsStoryboardViewController")
        
        // use this to connect tweetsViewController to current navigationController
        // allows it to hook into nav history and use correct segues
        self.addChildViewController(tweetsViewController)
        //tweetsViewController.navigationController = self.navigationController
        tweetsViewController.willMove(toParentViewController: self)
        self.view.addSubview(tweetsViewController.view)
        tweetsViewController.didMove(toParentViewController: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
