//
//  AppDelegate.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 10/29/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
        let hamburgerViewController = window!.rootViewController as! HamburgerViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuViewController
        */
        

        // go straight to tweets if not nil (skip login & authentication with Twitter)
        if User.currentUser != nil{
            // set root view controller
            print("There is a current user")
            // But update current user object to get latest data
            TwitterClient.sharedInstance?.currentAccount(success: { (user: User) in
                User.currentUser = user
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // from Main.storyboard
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            self.window?.rootViewController = hamburgerViewController
            
            
        }else{
            // proceed to login view
            print("There is no current user")
        }
        
        // from TwitterClient Logout
        NotificationCenter.default.addObserver(forName: User.userDidLogoutNotification, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            
            // callback below will fire when logging out
            
            // reinitialize storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // from Main.storyboard
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
 
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.description)
        // load twitter client
        let client = TwitterClient.sharedInstance
        
        // take care of url redirected to this app
        client?.handleOpenUrl(url: url)
        
        return true;
    }


}

