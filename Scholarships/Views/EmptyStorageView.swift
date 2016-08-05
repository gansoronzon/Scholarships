//
//  EmptyStorageView.swift
//  Scholarships
//
//  Created by Gansoronzon on 5/24/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit


class EmptyStorageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.autoresizingMask = .FlexibleHeight
        self.backgroundColor = UIColor.whiteColor()
        
        let image = UIImageView(image: UIImage(named: "img_no_data"))
        image.center = self.center
        image.contentMode = .Center
        image.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
