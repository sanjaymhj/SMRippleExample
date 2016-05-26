//
//  ViewController.swift
//  SMRippleExample
//
//  Created by Sanjay Maharjan on 5/25/16.
//  Copyright © 2016 Sanjay Maharjan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var baseView: UIView!
    
    var rippleView: SMRippleView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let fillColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        rippleView = SMRippleView(frame: baseView.frame, rippleColor: UIColor.clearColor(), rippleThickness: 0.2, rippleTimer: 1, fillColor: fillColor, animationDuration: 3, parentFrame: self.view.frame)
        self.view.addSubview(rippleView!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rippleView?.center = self.baseView.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

