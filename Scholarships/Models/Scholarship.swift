//
//  Scholarship.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/19/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit

class Scholarship : NSObject {
    
    /// scholarship id
    var scholarshipId = String()
    
    /// scholarship title
    var scholarshipTitle = String()
    
    /// scholarship deadline
    var scholarshipDeadline = String()
    
    /// scholarship country
    var scholarshipCountry = String()
    
    /// scholarship study level
    var scholarshipStudyLevel = String()
    
    /// scholarship description
    var scholarshipDescription = String()
    
    /// scholarship eligibility
    var scholarshipEligibility = String()
    
    /// scholarship field of study
    var scholarshipFieldOfStudy = String()
    
    /// scholarship host institution
    var scholarshipHostInstitution = String()
    
    /// scholarship application instructions
    var scholarshipInstructions = String()
    
    /// number of scholarships
    var scholarshipNumbers = String()
    
    /// scholarship target group
    var scholarshipTargetGroup = String()
    
    /// scholarship benefits
    var scholarshipBenefits = String()
    
    /// scholarship official website url
    var scholarshipWebUrl = String()
    
    /// scholarship share url
    var scholarshipShareUrl = String()
    
    /// scholarship list image URL
    var scholarshipListImageURL = String()
    
    /// scholarship detail image URL
    var scholarshipDetailImageURL = String()

    
    func initWithDictionary(dic: NSDictionary) -> Scholarship {
        
        self.scholarshipId = dic["id"] as! String
        self.scholarshipTitle = dic["title"] as! String
        self.scholarshipDeadline = dic["deadline"] as! String
        
        // scholarship countries
        var countryString = ""
        let countryArray = dic["country"] as! NSArray
        
        for i in 0..<countryArray.count {
            if i == 0 {
                countryString += (countryArray[i] as! NSDictionary)["country_name"] as! String
            } else {
                countryString += ", " + ((countryArray[i] as! NSDictionary)["country_name"] as! String)
            }
        }

        self.scholarshipCountry =  countryString
        self.scholarshipDescription = dic["description"] as! String
        self.scholarshipStudyLevel = dic["study_level_name"] as! String
        self.scholarshipListImageURL = dic["image"] as! String
        self.scholarshipDetailImageURL = dic["image_detail"] as! String
        self.scholarshipHostInstitution = dic["hostInstitution"] as! String
        self.scholarshipFieldOfStudy = dic["fieldOfStudy"] as! String
        self.scholarshipNumbers = dic["numberOfScholarships"] as! String
        self.scholarshipTargetGroup = dic["targetGroup"] as! String
        self.scholarshipBenefits = dic["benefits"] as! String
        self.scholarshipEligibility = dic["eligibility"] as! String
        self.scholarshipInstructions = dic["instructions"] as! String
        self.scholarshipWebUrl = dic["website"] as! String
        self.scholarshipShareUrl = dic["url"] as! String
        
        return self
    }
    
    func initWithObject(result: AnyObject) -> Scholarship {
        
        self.scholarshipId = result.valueForKey("id") as! String
        self.scholarshipTitle = result.valueForKey("title") as! String
        self.scholarshipDeadline = result.valueForKey("deadline") as! String
        self.scholarshipCountry = result.valueForKey("country") as! String
        self.scholarshipStudyLevel = result.valueForKey("studyLevel") as! String
        self.scholarshipDescription = result.valueForKey("desc") as! String
        self.scholarshipListImageURL = result.valueForKey("imageUrl") as! String
        self.scholarshipDetailImageURL = result.valueForKey("detailImageUrl") as! String
        self.scholarshipHostInstitution = result.valueForKey("hostInstitution") as! String
        self.scholarshipNumbers = result.valueForKey("number") as! String
        self.scholarshipFieldOfStudy = result.valueForKey("fieldOfStudy") as! String
        self.scholarshipTargetGroup = result.valueForKey("target") as! String
        self.scholarshipBenefits = result.valueForKey("benefits") as! String
        self.scholarshipEligibility = result.valueForKey("eligibility") as! String
        self.scholarshipInstructions = result.valueForKey("instructions") as! String
        self.scholarshipWebUrl = result.valueForKey("website") as! String
        self.scholarshipShareUrl = result.valueForKey("url") as! String
        
        return self
    }
}















