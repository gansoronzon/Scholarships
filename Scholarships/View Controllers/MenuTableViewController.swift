//
//  MenuTableViewController.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/9/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit
import StoreKit

class MenuTableViewController: UITableViewController {
    
    //facebook share content
    var content = FBSDKShareLinkContent()
    
    //facebook share dialog
    var dialog = FBSDKShareDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpShareLinkContent()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/scholarshipfinderforinternationalstudents/")!)
        } else if indexPath.row == 4 {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/scholarships-for-international/id1063789185?mt=8")!)
            //rate
        } else if indexPath.row == 5 {
            //share & remove ads
            dialog.show();
        }
    }
    
    //settin up share link content
    
    func setUpShareLinkContent() {
        
        content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://findscholarshipsabroad.com/")
        content.imageURL = NSURL(string: "https://scontent-ord1-1.xx.fbcdn.net/hphotos-xap1/v/t1.0-9/10404913_1640903602836782_4775685113719868480_n.jpg?oh=07bb496ac19b2a46f378a4c1a886f726&oe=574BCE69")
        content.contentTitle = "Scholarships for International Students: Find Scholarships and Fund for your Higher Degree"
        
        
        dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = self.content
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fbauth2://")!) {
            dialog.mode = .Native
        } else {
            dialog.mode = .Browser
        }
    }
}
