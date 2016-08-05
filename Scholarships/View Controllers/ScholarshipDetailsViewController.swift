//
//  ScholarshipDetailsViewController.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/23/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit
import CoreData

class ScholarshipDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //whether the view controller is presented from home or saved
    var isSaved = false
    
    //scholarship
    var scholarship = Scholarship()
    
    //managed object
    var scholarshipManagedObject : NSManagedObject?
    
    //scholarship detail picture
    var detailImageView = UIImageView()
    
    //Scholarship title
    var detailTitleLabel = UILabel()
    
    //Degree level view
    var degreeLevelView = UIView()
    
    //Deadline view
    var deadlineView = UIView()
    
    //Country view
    var countryView = UIView()

    //Description view
    var descriptionView = UIView()
    
    //Host intitution view
    var hostInstitutionsView = UIView()
    
    //Field of Study view
    var fieldOfStudyView = UIView()
    
    //Number of scholarships view
    var numbersView = UIView()
    
    //Target group view
    var targetView = UIView()
    
    //Benefits view
    var benefitsView = UIView()
    
    //Eligibility view
    var eligibilityView = UIView()
    
    //Instructions view
    var instrucionsView = UIView()
    
    //Official website view
    var websiteView = UIView()
    
    //Seperators
    let titleSeperator = UIView()
    
    //facebook share content
    var content = FBSDKShareLinkContent()
    
    //facebook share dialog
    var dialog = FBSDKShareDialog()
    
    //refresh control
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        setUpNavigationBar()
        setUpViews()
        setUpShareLinkContent()
        
        let readCount = NSUserDefaults.standardUserDefaults().integerForKey("ReadCount")
        NSUserDefaults.standardUserDefaults().setInteger(readCount + 1, forKey: "ReadCount")
    }
    
    func setUpNavigationBar(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let shareButton = UIBarButtonItem(image: UIImage(named: "ic_share"), style: .Plain, target: self, action: #selector(share))
        var saveOrDeleteButton = UIBarButtonItem()
        if isSaved{
            saveOrDeleteButton = UIBarButtonItem(image: UIImage(named: "ic_delete"), style: .Plain, target: self, action: #selector(deleteClick))
        } else {
            saveOrDeleteButton = UIBarButtonItem(image: UIImage(named: "ic_save"), style: .Plain, target: self, action: #selector(save))
        }
        self.navigationItem.rightBarButtonItems = [shareButton, saveOrDeleteButton]
    }
    
    func goBack()
    {
        detailViewControllerPopped = true
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(){
        
        print(self.content.contentTitle)
        
        dialog.show()
        
        print("sahre")
        
    }
    
    func save(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Scholarship")
        fetchRequest.predicate = NSPredicate(format: "id = %@", self.scholarship.scholarshipId)
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
            
            // success ...
            if fetchResults.count != 0 {
                
                let savedAlert = UIAlertController(title: "Already saved!", message: "This scholarship has already been saved in your phone", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok",
                    style: .Default) { (action: UIAlertAction) -> Void in
                }
                
                savedAlert.addAction(okAction)
                self.presentViewController(savedAlert, animated: true, completion: nil)
                
            } else {
                let entity =  NSEntityDescription.entityForName("Scholarship",
                    inManagedObjectContext:managedContext)
                
                let scholarship = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedContext)
                
                scholarship.setValue(self.scholarship.scholarshipId, forKey: "id")
                scholarship.setValue(self.scholarship.scholarshipTitle, forKey: "title")
                scholarship.setValue(self.scholarship.scholarshipDeadline, forKey: "deadline")
                scholarship.setValue(self.scholarship.scholarshipCountry, forKey: "country")
                scholarship.setValue(self.scholarship.scholarshipStudyLevel, forKey: "studyLevel")
                scholarship.setValue(self.scholarship.scholarshipDescription, forKey: "desc")
                scholarship.setValue(self.scholarship.scholarshipListImageURL, forKey: "imageUrl")
                scholarship.setValue(self.scholarship.scholarshipDetailImageURL, forKey: "detailImageUrl")
                scholarship.setValue(self.scholarship.scholarshipHostInstitution, forKey: "hostInstitution")
                scholarship.setValue(self.scholarship.scholarshipNumbers, forKey: "number")
                scholarship.setValue(self.scholarship.scholarshipFieldOfStudy, forKey: "fieldOfStudy")
                scholarship.setValue(self.scholarship.scholarshipTargetGroup, forKey: "target")
                scholarship.setValue(self.scholarship.scholarshipBenefits, forKey: "benefits")
                scholarship.setValue(self.scholarship.scholarshipEligibility, forKey: "eligibility")
                scholarship.setValue(self.scholarship.scholarshipInstructions, forKey: "instructions")
                scholarship.setValue(self.scholarship.scholarshipWebUrl, forKey: "website")
                scholarship.setValue(self.scholarship.scholarshipShareUrl, forKey: "url")
                
                do {
                    try managedContext.save()
                    
                    let savedAlert = UIAlertController(title: "Saved!", message: "This scholarship is saved in your phone", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "Ok",
                        style: .Default) { (action: UIAlertAction) -> Void in
                    }
                    
                    savedAlert.addAction(okAction)
                    self.presentViewController(savedAlert, animated: true, completion: nil)
                    
                    
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func deleteClick() {
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Do you want to delete this scholarship?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes",
            style: .Default) { (action: UIAlertAction) -> Void in
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Scholarship")
                fetchRequest.predicate = NSPredicate(format: "id = %@", self.scholarship.scholarshipId)
                
                do {
                    let fetchResults = try managedContext.executeFetchRequest(fetchRequest)
                    
                    // success ...
                    if fetchResults.count != 0 {
                        managedContext.deleteObject(fetchResults[0] as! NSManagedObject)
                        do {
                            try managedContext.save()
                        } catch let error as NSError {
                            print("Deletion failed: \(error.localizedDescription)")
                        }
                    }
                } catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                
                detailViewControllerPopped = false
                self.navigationController?.popViewControllerAnimated(true)
        }
        
        let noAction = UIAlertAction(title: "No",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        deleteAlert.addAction(yesAction)
        deleteAlert.addAction(noAction)
        
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    func setUpViews(){
        
        //Setting up image
        self.detailImageView.frame = CGRectMake(0, 0, WINDOW_FRAME.width, 200)
        self.detailImageView.contentMode = .ScaleAspectFit
        self.scrollView.addSubview(detailImageView)
        
        self.detailImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: scholarship.scholarshipDetailImageURL)!), placeholderImage: UIImage(named: "logo_menu"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
            self.detailImageView.frame = CGRectMake(0, 0,  WINDOW_FRAME.width, WINDOW_FRAME.width * image.size.height / image.size.width)
            self.detailImageView.image = image
            self.repositionViews()
            }, failure: nil)
        
        //Setting up title
        detailTitleLabel.text = scholarship.scholarshipTitle
        detailTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        detailTitleLabel.numberOfLines = 0
        let titleSize : CGSize = (detailTitleLabel.text)!.boundingRectWithSize(
                    CGSizeMake(WINDOW_FRAME.width - 20, CGFloat.infinity),
                    options: .UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName: detailTitleLabel.font],
                    context: nil).size
        detailTitleLabel.frame = CGRectMake(10, CGRectGetMaxY(detailImageView.frame) + 10, WINDOW_FRAME.width - 20, titleSize.height)
        self.scrollView.addSubview(detailTitleLabel)
        
        titleSeperator.frame = CGRectMake(0, CGRectGetMaxY(detailTitleLabel.frame) + 10, WINDOW_FRAME.width, 1)
        titleSeperator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.scrollView.addSubview(titleSeperator)
        
        //Setting up degree level view
        degreeLevelView = setUpView("DEGREE LEVEL", description: scholarship.scholarshipStudyLevel, attributed: false, backgroundColored: true)
        degreeLevelView.frame = CGRectMake(0, CGRectGetMaxY(titleSeperator.frame), WINDOW_FRAME.width, degreeLevelView.frame.height)
        self.scrollView.addSubview(degreeLevelView)
        
        //Setting up deadline view
        deadlineView = setUpView("DEADLINE", description: scholarship.scholarshipDeadline, attributed: false, backgroundColored: false)
        deadlineView.frame = CGRectMake(0, CGRectGetMaxY(degreeLevelView.frame), WINDOW_FRAME.width, deadlineView.frame.height)
        self.scrollView.addSubview(deadlineView)
        
        //Setting up country view
        countryView = setUpView("COUNTRY", description: scholarship.scholarshipCountry, attributed: false, backgroundColored: true)
        countryView.frame = CGRectMake(0, CGRectGetMaxY(deadlineView.frame), WINDOW_FRAME.width, countryView.frame.height)
        self.scrollView.addSubview(countryView)
        
        //Setting up description view
        descriptionView = setUpView("DESCRIPTION", description: scholarship.scholarshipDescription, attributed: true, backgroundColored: false)
        descriptionView.frame = CGRectMake(0, CGRectGetMaxY(countryView.frame), WINDOW_FRAME.width, descriptionView.frame.height)
        self.scrollView.addSubview(descriptionView)
        
        //Setting up host institutions view
        hostInstitutionsView = setUpView("HOST INSTITUTIONS", description: scholarship.scholarshipHostInstitution, attributed: true, backgroundColored: true)
        hostInstitutionsView.frame = CGRectMake(0, CGRectGetMaxY(descriptionView.frame), WINDOW_FRAME.width, hostInstitutionsView.frame.height)
        self.scrollView.addSubview(hostInstitutionsView)
        
        //Setting up field of study view
        fieldOfStudyView = setUpView("FIELD OF STUDY", description: scholarship.scholarshipFieldOfStudy, attributed: true, backgroundColored: false)
        fieldOfStudyView.frame = CGRectMake(0, CGRectGetMaxY(hostInstitutionsView.frame), WINDOW_FRAME.width, fieldOfStudyView.frame.height)
        self.scrollView.addSubview(fieldOfStudyView)
        
        //Setting up number of scholarships view
        numbersView = setUpView("NUMBER OF SCHOLARSHIPS", description: scholarship.scholarshipNumbers, attributed: true, backgroundColored: true)
        numbersView.frame = CGRectMake(0, CGRectGetMaxY(fieldOfStudyView.frame), WINDOW_FRAME.width, numbersView.frame.height)
        self.scrollView.addSubview(numbersView)
        
        //Setting target group view
        targetView = setUpView("TARGET GROUP", description: scholarship.scholarshipTargetGroup, attributed: true, backgroundColored: false)
        targetView.frame = CGRectMake(0, CGRectGetMaxY(numbersView.frame), WINDOW_FRAME.width, targetView.frame.height)
        self.scrollView.addSubview(targetView)
        
        //Setting up benefits view
        benefitsView = setUpView("BENEFITS", description: scholarship.scholarshipBenefits, attributed: true, backgroundColored: true)
        benefitsView.frame = CGRectMake(0, CGRectGetMaxY(targetView.frame), WINDOW_FRAME.width, benefitsView.frame.height)
        self.scrollView.addSubview(benefitsView)
        
        //Setting up eligibility view
        eligibilityView = setUpView("ELIGIBILITY", description: scholarship.scholarshipEligibility, attributed: true, backgroundColored: false)
        eligibilityView.frame = CGRectMake(0, CGRectGetMaxY(benefitsView.frame), WINDOW_FRAME.width, eligibilityView.frame.height)
        self.scrollView.addSubview(eligibilityView)
        
        //Setting up instructions view
        instrucionsView = setUpView("HOW TO APPLY", description: scholarship.scholarshipInstructions, attributed: true, backgroundColored: true)
        instrucionsView.frame = CGRectMake(0, CGRectGetMaxY(eligibilityView.frame), WINDOW_FRAME.width, instrucionsView.frame.height)
        self.scrollView.addSubview(instrucionsView)
        
        //Setting up official website view
        websiteView = setUpOfficialWebView()
        websiteView.frame = CGRectMake(0, CGRectGetMaxY(instrucionsView.frame), WINDOW_FRAME.width, websiteView.frame.height)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(websiteTapped))
        websiteView.addGestureRecognizer(tapGestureRecognizer)
        self.scrollView.addSubview(websiteView)
        
        scrollView.contentSize = CGSizeMake(WINDOW_FRAME.width, CGRectGetMaxY(websiteView.frame))
        
    }
    
    func setUpView(title: String, description: String, attributed: Bool, backgroundColored: Bool) -> UIView {
        let parentView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        
        let attributedDescriptionLabel = DTAttributedLabel()
        
        var seperatorView = UIView()
        
        //title view
        titleLabel.text = title
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        titleLabel.textColor = UIColor.hx_colorWithHexString("3498DB")
        
        let titleSize : CGSize = (titleLabel.text)!.boundingRectWithSize(
            CGSizeMake(WINDOW_FRAME.width - 20, CGFloat.infinity),
            options: .UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: titleLabel.font],
            context: nil).size
        titleLabel.frame = CGRectMake(10, 10, WINDOW_FRAME.width - 20, titleSize.height)
        parentView.addSubview(titleLabel)
        
        //description view
        
        if attributed {
            
            let html : NSString = description
            let data : NSData = html.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let attrString : NSAttributedString = NSAttributedString(HTMLData: data, documentAttributes: nil)
            attributedDescriptionLabel.attributedString = attrString
            
            /// Finding size for attributed string
            let layouter : DTCoreTextLayouter = DTCoreTextLayouter(attributedString: attrString)
            
            let maxRect : CGRect = CGRectMake(10, 20, WINDOW_FRAME.width - 20, CGFloat(CGFLOAT_HEIGHT_UNKNOWN))
            let entireString = NSMakeRange(0, attrString.length)
            let layoutFrame : DTCoreTextLayoutFrame = layouter.layoutFrameWithRect(maxRect, range: entireString)
            
            attributedDescriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 5, WINDOW_FRAME.width - 20, layoutFrame.frame.size.height)
            
            if backgroundColored {
                attributedDescriptionLabel.backgroundColor = UIColor.hx_colorWithHexString("EDF5FA")
            }
            
            parentView.addSubview(attributedDescriptionLabel)

            
            seperatorView = UIView(frame: CGRectMake(0, CGRectGetMaxY(attributedDescriptionLabel.frame) + 9, WINDOW_FRAME.width, 1))
            seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.25)
            parentView.addSubview(seperatorView)
            
            
        } else {
            descriptionLabel.text = description
            descriptionLabel.font = UIFont(name: "HelveticaNeue", size: 12)
            
            let descriptionSize : CGSize = (descriptionLabel.text)!.boundingRectWithSize(
                CGSizeMake(WINDOW_FRAME.width - 20, CGFloat.infinity),
                options: .UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: descriptionLabel.font],
                context: nil).size
            descriptionLabel.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 5, WINDOW_FRAME.width - 20, descriptionSize.height)
            parentView.addSubview(descriptionLabel)
            
            ///Seperator view
            seperatorView = UIView(frame: CGRectMake(0, CGRectGetMaxY(descriptionLabel.frame) + 9, WINDOW_FRAME.width, 1))
            seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.25)
            parentView.addSubview(seperatorView)
        }
        
        if backgroundColored {
            parentView.backgroundColor = UIColor.hx_colorWithHexString("EDF5FA")
        }
        
        parentView.frame = CGRectMake(0, 0, WINDOW_FRAME.width, CGRectGetMaxY(seperatorView.frame))
        
        return parentView
    }
    
    func setUpOfficialWebView() -> UIView{
        
        let parentView = UIView()
        
        let websiteLabel = UILabel()
        websiteLabel.numberOfLines = 0
        websiteLabel.text = scholarship.scholarshipWebUrl
        websiteLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
        websiteLabel.textColor = UIColor.hx_colorWithHexString("3498DB")
        
        let webLinkSize : CGSize = (websiteLabel.text)!.boundingRectWithSize(
            CGSizeMake(WINDOW_FRAME.width - 70, CGFloat.infinity),
            options: .UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: websiteLabel.font],
            context: nil).size
        websiteLabel.frame = CGRectMake(60, 10, WINDOW_FRAME.width - 70, webLinkSize.height)
        parentView.addSubview(websiteLabel)
        
        
        let officialLabel = UILabel()
        officialLabel.numberOfLines = 0
        officialLabel.text = "Official website"
        officialLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        officialLabel.textColor = UIColor(white: 0, alpha: 0.25)
        
        let officialLabelSize : CGSize = (officialLabel.text)!.boundingRectWithSize(
            CGSizeMake(WINDOW_FRAME.width - 70, CGFloat.infinity),
            options: .UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: officialLabel.font],
            context: nil).size
        officialLabel.frame = CGRectMake(60, CGRectGetMaxY(websiteLabel.frame) + 5, WINDOW_FRAME.width - 70, officialLabelSize.height)
        parentView.addSubview(officialLabel)
        
        let image = UIImageView(image: UIImage(named: "ic_web"))
        image.frame = CGRectMake(10, 10, 40, 40)
        parentView.addSubview(image)
        
        let maxY = CGRectGetMaxY(officialLabel.frame) > CGRectGetMaxY(image.frame) ? CGRectGetMaxY(officialLabel.frame) : CGRectGetMaxY(image.frame)
        var seperatorView = UIView()
        seperatorView = UIView(frame: CGRectMake(0, maxY + 9, WINDOW_FRAME.width, 1))
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.25)
        parentView.addSubview(seperatorView)
        
        parentView.frame = CGRectMake(0, 0, WINDOW_FRAME.width, CGRectGetMaxY(seperatorView.frame))
        return parentView
    }
    
    func websiteTapped(){
        UIApplication.sharedApplication().openURL(NSURL(string: scholarship.scholarshipWebUrl)!)
    }
    
    func repositionViews(){
        
        // Repositioning title
        detailTitleLabel.frame = CGRectMake(10, CGRectGetMaxY(detailImageView.frame) + 10, WINDOW_FRAME.width - 20, detailTitleLabel.bounds.height)
        titleSeperator.frame = CGRectMake(0, CGRectGetMaxY(detailTitleLabel.frame) + 10, WINDOW_FRAME.width, 1)
        
        // Reposition degree level view
        degreeLevelView.frame = CGRectMake(0, CGRectGetMaxY(titleSeperator.frame), WINDOW_FRAME.width, degreeLevelView.frame.height)
        
        // Repositioning deadline view
        deadlineView.frame = CGRectMake(0, CGRectGetMaxY(degreeLevelView.frame), WINDOW_FRAME.width, deadlineView.frame.height)
        
        // Repositioning country view
        countryView.frame = CGRectMake(0, CGRectGetMaxY(deadlineView.frame), WINDOW_FRAME.width, countryView.frame.height)
        
        // Repositioning description view
        descriptionView.frame = CGRectMake(0, CGRectGetMaxY(countryView.frame), WINDOW_FRAME.width, descriptionView.frame.height)
        
        // Repositioning host institutions view
        hostInstitutionsView.frame = CGRectMake(0, CGRectGetMaxY(descriptionView.frame), WINDOW_FRAME.width, hostInstitutionsView.frame.height)
        
        ///Repositioning field of study view
        fieldOfStudyView.frame = CGRectMake(0, CGRectGetMaxY(hostInstitutionsView.frame), WINDOW_FRAME.width, fieldOfStudyView.frame.height)
        
        ///Repositioning nuber of scholarships view
        numbersView.frame = CGRectMake(0, CGRectGetMaxY(fieldOfStudyView.frame), WINDOW_FRAME.width, numbersView.frame.height)
        
        ///Repositioning target group view
        targetView.frame = CGRectMake(0, CGRectGetMaxY(numbersView.frame), WINDOW_FRAME.width, targetView.frame.height)
        
        ///Repositioning benefits view
        benefitsView.frame = CGRectMake(0, CGRectGetMaxY(targetView.frame), WINDOW_FRAME.width, benefitsView.frame.height)
        
        ///Repositioning eligibility view
        eligibilityView.frame = CGRectMake(0, CGRectGetMaxY(benefitsView.frame), WINDOW_FRAME.width, eligibilityView.frame.height)
        
        ///Repositioning instructions view
        instrucionsView.frame = CGRectMake(0, CGRectGetMaxY(eligibilityView.frame), WINDOW_FRAME.width, instrucionsView.frame.height)
        
        ///Repositioning website view
        websiteView.frame = CGRectMake(0, CGRectGetMaxY(instrucionsView.frame), WINDOW_FRAME.width, websiteView.frame.height)
        
        scrollView.contentSize = CGSizeMake(WINDOW_FRAME.width, CGRectGetMaxY(websiteView.frame))
    }
    
    func setUpShareLinkContent() {
        
        content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: scholarship.scholarshipShareUrl)
        content.imageURL = NSURL(string: scholarship.scholarshipDetailImageURL)
        content.contentTitle = scholarship.scholarshipTitle
        
        
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
