//
//  ViewController.swift
//  ViewPager
//
//  Created by damingdan on 15/2/12.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit
import UIViewPager

class ViewController: UIViewController, UITabHostDataSource, UITabHostDelegate {
    @IBOutlet weak var tabHostContainer: UITabHostsContainer!
    
    var dataSource:[String] = ["Title A", "Title B", "Title C", "Title D", "Title E"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabHostContainer.dataSource = self;
        self.tabHostContainer.delegate = self;
        self.tabHostContainer.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfTabHostsWithContainer(container: UITabHostsContainer) -> Int {
        return dataSource.count;
    }
    
    func titleAtIndex(index: Int, container: UITabHostsContainer) -> String {
        return dataSource[index];
    }
    
    func titleColorForTabHost(index: Int, container: UITabHostsContainer) -> UIColor {
        return UIColor.redColor();
    }
    
    func selectedColorForTabHost(index: Int, container: UITabHostsContainer) -> UIColor {
        return UIColor.blueColor();
    }
}

