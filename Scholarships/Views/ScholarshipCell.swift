//
//  ScholarshipCell.swift
//  Scholarships
//
//  Created by Gansoronzon on 1/18/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit

class ScholarshipCell: UITableViewCell {
    
    ///outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDeadline: UILabel!
    @IBOutlet weak var cellCountry: UILabel!
    @IBOutlet weak var cellStudyLevel: UILabel!
    
    var scholarship = Scholarship()
    
    func initWithScholarship(scholarship: Scholarship){
        self.scholarship = scholarship
    }
    
    override func layoutSubviews() {
        self.cellTitle.text = scholarship.scholarshipTitle
        self.cellDeadline.text = scholarship.scholarshipDeadline
        self.cellCountry.text = scholarship.scholarshipCountry
        self.cellStudyLevel.text = scholarship.scholarshipStudyLevel
        
        self.cellImage.setImageWithURL(NSURL(string: scholarship.scholarshipListImageURL)!, placeholderImage: UIImage(named: "logo_menu"))
    }

}
