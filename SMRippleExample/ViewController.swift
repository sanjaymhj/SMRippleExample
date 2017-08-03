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
        let fillColor: UIColor? = UIColor.black//UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        rippleView = SMRippleView(frame: baseView.bounds, rippleColor: UIColor.black, rippleThickness: 0.2, rippleTimer: 0.6, fillColor: fillColor, animationDuration: 4, parentFrame: self.view.frame)
        self.baseView.addSubview(rippleView!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //rippleView?.center = self.baseView.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

