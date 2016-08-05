//
//  NoConnectionView.swift
//  Scholarships
//
//  Created by Gansoronzon on 5/24/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

import UIKit

protocol NocConnectionViewDelegate {
    func retry()
}

class NoConnectionView: UIView {
    
    var delegate : NocConnectionViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.autoresizingMask = .FlexibleHeight
        self.backgroundColor = UIColor.whiteColor()
        
        let image = UIImageView(image: UIImage(named: "img_no_internet"))
        image.center = self.center
        image.contentMode = .Center
        image.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(image)
        
        //retry button
        let retryButton = UIButton(type: .Custom)
        retryButton.frame = CGRectMake((self.bounds.size.width-220)/2, self.bounds.size.height-60, 220, 28)
        retryButton.autoresizingMask = .FlexibleTopMargin
        retryButton.setTitle("RETRY", forState: .Normal)
        retryButton.setTitleColor(UIColor.hx_colorWithHexString("a1aeb7"), forState: .Normal)
        retryButton.layer.borderWidth = 1
        retryButton.layer.cornerRadius = 3
        retryButton.layer.borderColor = UIColor.hx_colorWithHexString("a1aeb7")!.CGColor
        retryButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        retryButton.addTarget(self, action: #selector(retryClicked), forControlEvents: .TouchUpInside)
        self.addSubview(retryButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func retryClicked() {
        delegate.retry()
    }
}
