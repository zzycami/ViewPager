//
//  UIViewPager.swift
//  ViewPager
//
//  Created by damingdan on 15/2/10.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

/**
*  This View Pager use the UIViewController as the child view. You can use add child UIViewController to add the subviews
*/
@objc public protocol UIViewPagerDataSource: NSObjectProtocol {
    func numberOfItems(viewPager:UIViewPager)->Int;
    
    func controller(viewPager:UIViewPager, index:Int)->UIViewController;
    
    optional func titleForItem(viewPager:UIViewPager, index:Int)->String;
    
    optional func tabHostView(viewPager:UIViewPager, index:Int)->UIView;
}

@objc public protocol UIViewPagerDelegate: NSObjectProtocol {
    optional func tabHostClicked(viewPager:UIViewPager, index:Int);
    
    optional func willMove(viewPager:UIViewPager, fromIndex:Int, toIndex:Int);
    
    optional func didMove(viewPager:UIViewPager, fromIndex:Int, toIndex:Int);
}

public class UIViewPager: UIView, UITabHostDataSource, UITabHostDelegate, UIScrollViewDelegate {
    /// Default tabHostsContaner, It's on the top of viewpager and default height is 44. you can custom the tab host container
    public var tabHostsContainer:UITabHostsContainer!
    
    public var contentView:UIScrollView!
    
    public var delegate:UIViewPagerDelegate?
    
    public var dataSouce:UIViewPagerDataSource?
    
    public var currentIndex:Int = 0
    
    private var contentViews:[UIView] = [];
    
    
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
        }
        tabHostsContainer.dataSource = self;
        tabHostsContainer.delegate = self;
        addSubview(tabHostsContainer);
        
        // Cretae content view
        contentView = UIScrollView(frame: CGRectMake(0, tabHostsContainer.frame.height, bounds.width, bounds.height));
        contentView.backgroundColor = UIColor.clearColor();
        contentView.showsHorizontalScrollIndicator = false;
        contentView.bounces = false;
        contentView.pagingEnabled = true;
        contentView.decelerationRate = UIScrollViewDecelerationRateFast;
        contentView.delegate = self;
        addSubview(contentView);
    }
    
    public override func layoutSubviews() {
        tabHostsContainer.frame = CGRectMake(0, 0, bounds.width, 44);
        tabHostsContainer.layoutSubviews();
        contentView.frame = CGRectMake(0, tabHostsContainer.frame.height, bounds.width, bounds.height);
        
    }
    
    public func reloadData() {
        currentIndex = 0;
        tabHostsContainer.reloadData();
        tabHostsContainer.setSelected(currentIndex);
        // Remove all subviews
        for view in contentView.subviews {
            view.removeFromSuperview();
        }
        createPages();
    }
    
    func createPages() {
        if let ds = self.dataSouce {
            var capacity = ds.numberOfItems(self);
            contentViews = [];
            for i in 0...capacity - 1 {
                var controller = ds.controller(self, index: i);
                var view = controller.view;
                var frame = view.frame;
                frame.x = i*contentView.bounds.width;
                view.frame = frame;
                contentViews.append(view);
                contentView.addSubview(view);
            }
            var width = contentViews.count*contentView.bounds.width;
            var height = contentView.bounds.height;
            contentView.contentSize = CGSizeMake(width, height);
        }
    }
    
    //MARK: UITabHostsContainerDataSource
    public func numberOfTabHostsWithContainer(container: UITabHostsContainer) -> Int {
        if container == tabHostsContainer {
            if let ds = self.dataSouce {
                return ds.numberOfItems(self);
            }else {
                return 0;
            }
        }else {
            return 0;
        }
    }
    
    public func titleAtIndex(index: Int, container: UITabHostsContainer) -> String? {
        if container == tabHostsContainer {
            return self.dataSouce?.titleForItem?(self, index: index);
        }else {
            return "";
        }
    }
    
    public func viewAtIndex(index: Int, container: UITabHostsContainer) -> UIView? {
        if container == tabHostsContainer {
            return dataSouce?.tabHostView?(self, index: index);
        }else {
            return nil;
        }
    }
    
    //MARK:UITabHostsDelegate
    public func didSelectTabHost(index: Int, container: UITabHostsContainer) {
        if currentIndex != index {
            currentIndex = index;
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                var point = contentViewControllers[index].bounds.origin;
                self.contentView.contentOffset = point;
            });
            
            if let delegate = self.delegate {
                delegate.tabHostClicked?(self, index: index);
            }
        }
    }
    
    //MARK:UIScrollViewDelegate
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == contentView {
        }
    }
}
