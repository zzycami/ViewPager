//
//  UIViewPager.swift
//  ViewPager
//
//  Created by damingdan on 15/2/10.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

public class UIViewPager: UIView, UITabHostDataSource, UITabHostDelegate {
    /// Default tabHostsContaner, It's on the top of viewpager and default height is 44. you can custom the tab host container
    public var tabHostsContainer:UITabHostsContainer!
    
    public var contentView:UIScrollView!
    
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupViewPager();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setupViewPager();
    }
    
    func setupViewPager() {
        if tabHostsContainer == nil {
            tabHostsContainer = UITabHostsContainer(frame: CGRectMake(0, 0, bounds.width, 44));
            tabHostsContainer.dataSource = self;
            tabHostsContainer.delegate = self;
        }
    }
    
    public func reloadData() {
    }
    
    public func numberOfTabHostsWithContainer(container: UITabHostsContainer) -> Int {
        return 0;
    }
}
