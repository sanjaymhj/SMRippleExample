//
//  RippleCellTableViewCell.swift
//  SMRippleExample
//
//  Created by Sanjay Maharjan on 5/7/17.
//  Copyright © 2017 Sanjay Maharjan. All rights reserved.
//

import UIKit

class RippleCell: UITableViewCell {
    
    override var bounds: CGRect {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    @IBOutlet weak var rippleViewPlaceholder: UIView!
    var ripplePlaceHolder: UIView!
    
    var rippleView: SMRippleView!

    @IBOutlet weak var centerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let frame = self.centerImageView?.bounds ?? self.frame
        
        rippleView = SMRippleView(frame:frame, rippleColor: UIColor.black, rippleThickness: 1, rippleTimer: 0.3, fillColor: UIColor.black, animationDuration: 2, parentFrame: CGRect(x: self.bounds.maxX, y: self.bounds.maxX, width: self.bounds.size.width, height: self.bounds.size.width ))
        
        self.clipsToBounds = true
        self.contentView.insertSubview(rippleView, belowSubview: centerImageView)//addSubview(rippleView)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        rippleView.originalFrame = centerImageView.frame
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
