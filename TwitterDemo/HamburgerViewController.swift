//
//  HamburgerViewController.swift
//  TwitterDemo
//
//  Created by Edwin Wong on 11/5/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    // controls menu view controller
    var menuViewController: UIViewController!{
        didSet(oldMenuViewController){
            // lazy load view
            view.layoutIfNeeded()
            if oldMenuViewController != nil{
                // will not move
                oldMenuViewController.willMove(toParentViewController: nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMove(toParentViewController: nil)
            }
            // tell controller it will move (calls willAppear)
            menuViewController.willMove(toParentViewController: self)
            // pull out view and attach to menu
            menuView.addSubview(menuViewController.view)
            // tell controller it did move
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    // controls which content view controller to display
    var contentViewController: UIViewController!{
        didSet(oldContentViewController){
            view.layoutIfNeeded()
            
            if oldContentViewController != nil{
                // will not move
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            // tell controller it will move (calls willAppear)
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            // tell controller it did move
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create menu first before setting self.menuViewController to prevent crash
        let localMenuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        localMenuViewController.hamburgerViewController = self
        self.menuViewController = localMenuViewController
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        if sender.state == .began{
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed{
            if velocity.x > 0 && self.leftMarginConstraint.constant < self.view.frame.size.width - 200{
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            }else if velocity.x < 0 && self.leftMarginConstraint.constant > 0{
                leftMarginConstraint.constant = originalLeftMargin + translation.x
            }
    
        } else if sender.state == .ended{
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0{
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 200
                } else{// if velocity.x < 0{
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
//
//            UIView.animate(withDuration: 0.3, animations: {
//                if velocity.x > 0{
//                    self.leftMarginConstraint.constant = self.view.frame.size.width - 200
//                } else if velocity.x < 0{
//                    self.leftMarginConstraint.constant = 0
//                }
//                self.view.layoutIfNeeded()
//            })
            
            
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
