//
//  ScholarshipsViewController.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/18/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit
import GoogleMobileAds

///get scholarships link
let getScholarshipsURL = "http://www.findscholarshipsabroad.com/admin/json/scholarshipsList.php"
var detailViewControllerPopped = false

class ScholarshipsViewController: UIViewController, GADInterstitialDelegate {
    
    /// outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scholarshipsTableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    /// the scholarships
    private var scholarships = [Scholarship]()
    
    /// load next data state
    private var isLoading: Bool = false
    
    /// flag used to define either load next page or not: true - will not load next page, false - will try to load
    private var isFullListLoaded = false
    
    // refresh control for scholarshipsTableView
    private var refreshControl : UIRefreshControl!
    
    /// the last page index used to request the list of challenges
    private var pageIndex: Int = 0
    
    // interstitial ad
    var interstitial: GADInterstitial!

    // no connection view
    var noConnectionView : NoConnectionView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setAsSidebarFrontView()
        setNavigationBar()
        
        self.interstitial = createAndLoadInterstitial()
        
        noConnectionView = NoConnectionView(frame: CGRectMake(0, 0, WINDOW_FRAME.width, WINDOW_FRAME.height))
        noConnectionView.delegate = self
        noConnectionView.hidden = true
        self.view.addSubview(noConnectionView)
        
        ///table view
        scholarshipsTableView.delegate = self
        scholarshipsTableView.dataSource = self
        scholarshipsTableView.registerClass(LoadingTableViewCell.classForCoder(), forCellReuseIdentifier: "loadingcell")

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        scholarshipsTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if detailViewControllerPopped {
            detailViewControllerPopped = false
        }
        
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
    
    /**
     Load next data
     */
    func loadNextData(){
        
        if isLoading || isFullListLoaded {
            return
        }
        
        isLoading = true
        
        // request a subset of the scholarships
        let manager : AFHTTPSessionManager = AFHTTPSessionManager()
        var param = NSDictionary()
        pageIndex += 1
        print(pageIndex)
        param = ["page": pageIndex]
        
        manager.POST(getScholarshipsURL, parameters: param, success: {
            (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
            self.noConnectionView.hidden = true
            let scholarshipsArray = responseObject as! NSArray
            for object in scholarshipsArray{
                
                let scholarship = Scholarship()
                self.scholarships.append(scholarship.initWithDictionary(object as! NSDictionary))
            }
            
            self.isLoading = false
            self.isFullListLoaded = (scholarshipsArray.count < 10) ? true : false
            self.scholarshipsTableView.reloadData()
            self.refreshControl.endRefreshing()
            
            }, failure: {
                (task: NSURLSessionDataTask?, error: NSError) in
                self.refreshControl.endRefreshing()
                print(error)
                self.noConnectionView.hidden = false
                print("failure!!!!!!!!!!!!")
        })
    }
    
    
    
    /**
     Pull to refresh
     */
    
    func refresh(){
        self.scholarships.removeAll()
        self.scholarshipsTableView.reloadData()
        self.isFullListLoaded = false
        self.isLoading = false
        self.pageIndex = 0
        
        loadNextData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "listToDetail" {
                
            var detailViewController =  segue.destinationViewController as! ScholarshipDetailsViewController
                
            // Pass the selected object to the new view controller.
            let path = self.scholarshipsTableView.indexPathForSelectedRow
            let scholarship = self.scholarships[path!.row]
                
            detailViewController.scholarship = scholarship
            detailViewController.isSaved = false
            } else {
                let backItem = UIBarButtonItem()
                backItem.title = "Home"
                navigationItem.backBarButtonItem = backItem
        }
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
}

extension ScholarshipsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return scholarships.count
        }
        else {
            if !isFullListLoaded && !isLoading {
                return 1
            }
            else {
                return 0
            }
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScholarshipCell") as! ScholarshipCell
            cell.initWithScholarship(scholarships[indexPath.row])
            return cell
        } else {
            let cell:LoadingTableViewCell = tableView.dequeueReusableCellWithIdentifier("loadingcell") as! LoadingTableViewCell
            cell.selectionStyle = .None
            cell.addView()
            if !isFullListLoaded {
                self.loadNextData()
            }
            return cell
        }
        
    }
}

extension ScholarshipsViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("listToDetail", sender: self)
        
    }

}

extension ScholarshipsViewController : NocConnectionViewDelegate {
    func retry() {
        self.noConnectionView.hidden = true
        self.refresh()
    }
}





























