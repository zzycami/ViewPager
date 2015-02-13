//
//  ViewController.swift
//  ViewPager
//
//  Created by damingdan on 15/2/12.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit
import UIViewPager

class ViewController: UIViewController {
    @IBOutlet weak var tabHost: UITabHost!
    @IBOutlet weak var tabHostLarge: UITabHost!
    @IBOutlet weak var tabHostSelected: UITabHost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabHost.bottomColor = UIColor.blueColor();
        self.tabHost.selectedColor = UIColor.greenColor();
        self.tabHost.titleColor = UIColor.blackColor();
        self.tabHost.title = "THIS IS A TITLE";
        
        self.tabHostLarge.bottomColor = UIColor.greenColor();
        self.tabHostLarge.selectedColor = UIColor.purpleColor();
        self.tabHostLarge.titleColor = UIColor.redColor();
        self.tabHostLarge.title = "THIS IS A LARGE TITLE";
        
        self.tabHostSelected.bottomColor = UIColor.purpleColor();
        self.tabHostSelected.selectedColor = UIColor.greenColor();
        self.tabHostSelected.titleColor = UIColor.blueColor();
        self.tabHostSelected.selected = true;
        self.tabHostSelected.title = "THIS IS A SELECTED TAB HOST";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

