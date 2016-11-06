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
    
    let menuItemList = [MenuItem("Profile"), MenuItem("TimeLine"), MenuItem("Mentions")]
    
    var viewControllers: [UIViewController] = []
    private var profileNavigationController: UIViewController!
    private var timelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        timelineNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        hamburgerViewController.contentViewController = profileNavigationController
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
        tableView.deselectRow(at: indexPath, animated: true)
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
