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
    @IBOutlet weak var tabHostCustom: UITabHost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabHost.bottomColor = UIColor.blueColor();
        self.tabHost.selectedColor = UIColor.greenColor();
        self.tabHost.titleColor = UIColor.blackColor();
        self.tabHost.title = "THIS IS A TITLE";
        self.tabHost.onClick = {(tabHost:UITabHost) in
            println("\(tabHost.title) has been clicked");
        }
        
        self.tabHostLarge.bottomColor = UIColor.greenColor();
        self.tabHostLarge.selectedColor = UIColor.purpleColor();
        self.tabHostLarge.titleColor = UIColor.redColor();
        self.tabHostLarge.title = "THIS IS A LARGE TITLE";
        
        self.tabHostSelected.bottomColor = UIColor.purpleColor();
        self.tabHostSelected.selectedColor = UIColor.greenColor();
        self.tabHostSelected.titleColor = UIColor.blueColor();
        self.tabHostSelected.selected = true;
        self.tabHostSelected.title = "THIS IS A SELECTED TAB HOST";
        
        var button:UIButton = UIButton(frame: tabHostCustom.bounds);
        button.setTitle("This is A Button", forState: UIControlState.Normal);
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.tabHostCustom.contentView = button;
        self.tabHostCustom.bottomColor = UIColor.purpleColor();
        self.tabHostCustom.selectedColor = UIColor.greenColor();
        self.tabHostCustom.titleColor = UIColor.blueColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

