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
    
    public weak var delegate:UIViewPagerDelegate?
    
    public weak var dataSource:UIViewPagerDataSource?
    
    public var currentIndex:Int = 0
    
    private var previousIndex:Int = 0
    
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
        var contentFrame = CGRectMake(0, 0, bounds.width, bounds.height - tabHostsContainer.frame.height)
        // Layout content views
        for var i=0;i<contentViews.count;i++ {
            var view = contentViews[i];
            var frame = contentFrame;
            frame.x = i*frame.width;
            view.frame = frame;
            view.layoutSubviews();
        }
        var width = contentViews.count*contentView.bounds.width;
        var height = contentView.bounds.height;
        contentView.contentSize = CGSizeMake(width, height);
        contentView.setContentOffset(CGPointMake(bounds.width*self.currentIndex, 0), animated: true);
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
        if let ds = self.dataSource {
            var contentFrame = CGRectMake(0, 0, bounds.width, bounds.height - tabHostsContainer.frame.height)
            var capacity = ds.numberOfItems(self);
            contentViews = [];
            for i in 0...capacity - 1 {
                var controller = ds.controller(self, index: i);
                var view = controller.view;
                var frame = contentFrame;
                frame.x = i*frame.width;
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
            if let ds = self.dataSource {
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
            return self.dataSource?.titleForItem?(self, index: index);
        }else {
            return "";
        }
    }
    
    public func viewAtIndex(index: Int, container: UITabHostsContainer) -> UIView? {
        if container == tabHostsContainer {
            return dataSource?.tabHostView?(self, index: index);
        }else {
            return nil;
        }
    }
    
    //MARK:UITabHostsDelegate
    public func didSelectTabHost(index: Int, container: UITabHostsContainer) {
        if currentIndex != index {
            currentIndex = index;
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                var point = self.contentViews[index].frame.origin;
                self.contentView.contentOffset = point;
            });
            
            if let delegate = self.delegate {
                delegate.tabHostClicked?(self, index: index);
                delegate.didMove?(self, fromIndex: previousIndex, toIndex: currentIndex);
            }
        }
    }
    
    //MARK:UIScrollViewDelegate
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == contentView {
            previousIndex = currentIndex;
            var nearestIndex = Int(targetContentOffset.memory.x/scrollView.bounds.width + 0.5);
            nearestIndex = max(min(nearestIndex, contentViews.count - 1), 0);
            delegate?.willMove?(self, fromIndex: previousIndex, toIndex: nearestIndex);
            currentIndex = nearestIndex;
        }
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentView {
            if let ds = self.dataSource {
                var capacity = ds.numberOfItems(self);
                if currentIndex >= 0 && currentIndex < capacity {
                    delegate?.didMove?(self, fromIndex: previousIndex, toIndex: currentIndex);
                    tabHostsContainer.unselectAllTabHost();
                    tabHostsContainer.moveToCorrectPointOfScrollView(currentIndex);
                    tabHostsContainer.setSelected(currentIndex);
                }
                contentView.setContentOffset(CGPointMake(bounds.width*self.currentIndex, 0), animated: true);
            }
        }
    }
}
