//
//  ScholarshipsTableViewController.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/9/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class SavedTableViewController: UITableViewController, GADInterstitialDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var savedTableView: UITableView!
    
    /// the scholarships
    private var scholarships = [Scholarship]()
    
    // interstitial ad
    var interstitial: GADInterstitial!
    
    // 
    var emptyView : EmptyStorageView!
    
    override func viewDidLoad() {
        
        savedTableView.dataSource = self
        savedTableView.delegate = self
        detailViewControllerPopped = false
        
        emptyView = EmptyStorageView(frame: CGRectMake(0, -64, WINDOW_FRAME.width, WINDOW_FRAME.height))
        emptyView.hidden = true
        self.view.addSubview(emptyView)
        
        self.interstitial = createAndLoadInterstitial()

        loadSavedScholarships()
        setAsSidebarFrontView()
        setNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if detailViewControllerPopped {
            detailViewControllerPopped = false
        }
        
        self.loadSavedScholarships()
        
        if self.interstitial.isReady {
            let readCount = NSUserDefaults.standardUserDefaults().integerForKey("ReadCount")
            if (readCount < 20 && readCount % 3 == 0) || (readCount > 20 && readCount < 40 && readCount % 2 == 1) || readCount >= 40 {
                self.interstitial.presentFromRootViewController(self)
            }
        }
    }
    
    /**
     setting view as the front view of slide out
     navigation front view
     */
    func setAsSidebarFrontView() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(self.revealViewController().revealToggle)
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = WINDOW_FRAME.width - 60
        self.revealViewController().shouldUseFrontViewOverlay = true
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone && WINDOW_FRAME.height == 667.0 {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "img_nav_bar-667h@2x"), forBarMetrics: .Default)
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "img_nav_bar"), forBarMetrics: .Default)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scholarships.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScholarshipCell") as! ScholarshipCell
        cell.initWithScholarship(scholarships[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("savedToDetailsSeque", sender: self)
    }
    
    func loadSavedScholarships() {
        
        self.scholarships = []
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Scholarship")
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            
            // success ...
            if fetchResults.count != 0 {
                emptyView.hidden = true
                fetchResults[0].valueForKey("id")
                
                for result in fetchResults {
                    let scholarship = Scholarship()
                    scholarships.append(scholarship.initWithObject(result))
                }
                
            } else {
                emptyView.hidden = false
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        savedTableView.reloadData()

    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-9320749271483514/7399176982")
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.interstitial = createAndLoadInterstitial()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "savedToDetailsSeque" {
    
            let detailViewController =  segue.destinationViewController as! ScholarshipDetailsViewController
    
            // Pass the selected object to the new view controller.
            let path = self.tableView.indexPathForSelectedRow
            let scholarship = self.scholarships[path!.row]
    
            detailViewController.scholarship = scholarship
            detailViewController.isSaved = true
        }
    }
}
