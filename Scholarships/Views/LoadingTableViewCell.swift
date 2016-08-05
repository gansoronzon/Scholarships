//
//  LoadingTableViewCell.swift
//  bondooloi
//
//  Created by Gantulga Tsendsuren on 2015-09-01.
//  Copyright (c) 2015 Sorako, LLC. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    var indicator:UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       self.addView()
        
    }
    func addView () {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.backgroundColor = UIColor.clearColor()
        indicator.frame = CGRectMake((self.contentView.bounds.size.width-44)/2, 0, 44, 44)
        indicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        indicator.startAnimating()
        self.contentView.addSubview(indicator)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
