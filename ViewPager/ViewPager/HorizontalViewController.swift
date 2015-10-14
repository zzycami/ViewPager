//
//  HorizontalViewController.swift
//  ViewPager
//
//  Created by damingdan on 15/5/14.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit
import UIViewPager

class HorizontalViewController: UIViewController, UIHorizontalLayoutDataSource {

    @IBOutlet weak var horizontalLayout: UIHorizontalLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add child view controller
        let viewController1 = storyboard?.instantiateViewControllerWithIdentifier("ViewController1");
        let viewController2 = storyboard?.instantiateViewControllerWithIdentifier("ViewController2");
        let viewController3 = storyboard?.instantiateViewControllerWithIdentifier("ViewController3");
        addChildViewController(viewController1!);
        addChildViewController(viewController2!);
        addChildViewController(viewController3!);
        
        
        horizontalLayout.dataSource = self
        horizontalLayout.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfControllers(layout: UIHorizontalLayout) -> Int {
        return self.childViewControllers.count
    }
    
    func controller(layout: UIHorizontalLayout, index: Int) -> UIViewController {
        return self.childViewControllers[index];
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
