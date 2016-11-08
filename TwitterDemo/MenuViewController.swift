//
//  MenuViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/5/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    let menuItemList = [MenuItem("Profile", "profile"), MenuItem("TimeLine", "timeline"), MenuItem("Mentions", "mentions")]
    
    var viewControllers: [UIViewController] = []
    private var profileNavigationController: UINavigationController!
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = 75
        self.tableView.tableFooterView = UIView()
        
        // load profile Image and label
        if let user = User.currentUser{
            self.profileImageView.setImageWith(user.profileURL!)
            self.nameLabel.text = user.name
        }
        
        let homeTimelineStoryboard = UIStoryboard(name: "HomeTimeline", bundle: nil)
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let mentionsStoryboard = UIStoryboard(name: "Mentions", bundle: nil)
        
        
        profileNavigationController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController

        let profileViewController = profileNavigationController.topViewController as? ProfileViewController
        profileViewController?.user = User.currentUser
//        let profileViewController = ((profileNavigationController.topViewController) as? ProfileViewController) {
//            
//        }
        
        timelineNavigationController = homeTimelineStoryboard.instantiateViewController(withIdentifier: "HomeTimelineNavigationController")
        mentionsNavigationController = mentionsStoryboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = timelineNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.menuItem", for: indexPath) as! MenuItemTableViewCell
        
        cell.menuItem = menuItemList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
