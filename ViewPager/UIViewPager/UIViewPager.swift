//
//  UIViewPager.swift
//  ViewPager
//
//  Created by damingdan on 15/2/10.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

@objc
public enum UIViewPagerStyle:Int {
    case tabHost
    case normal
}

/**
*  This View Pager use the UIViewController as the child view. You can use add child UIViewController to add the subviews
*/
@objc public protocol UIViewPagerDataSource: NSObjectProtocol {
    func numberOfItems(_ viewPager:UIViewPager)->Int;
    
    func controller(_ viewPager:UIViewPager, index:Int)->UIViewController;
    
    @objc optional func titleForItem(_ viewPager:UIViewPager, index:Int)->String;
    
    @objc optional func tabHostView(_ viewPager:UIViewPager, index:Int)->UIView;
}

@objc public protocol UIViewPagerDelegate: NSObjectProtocol {
    @objc optional func tabHostClicked(_ viewPager:UIViewPager, index:Int);
    
    @objc optional func willMove(_ viewPager:UIViewPager, fromIndex:Int, toIndex:Int);
    
    @objc optional func didMove(_ viewPager:UIViewPager, fromIndex:Int, toIndex:Int);
}

public class UIViewPager: UIView, UITabHostDataSource, UITabHostDelegate, UIScrollViewDelegate {
    /// Default tabHostsContaner, It's on the top of viewpager and default height is 44. you can custom the tab host container
    public var tabHostsContainer:UITabHostsContainer?
    
    public var contentView:UIScrollView!
    
    public weak var delegate:UIViewPagerDelegate?
    
    public weak var dataSource:UIViewPagerDataSource?
    
    public var style:UIViewPagerStyle = UIViewPagerStyle.tabHost {
        didSet {
            if self.style == UIViewPagerStyle.normal {
                self.tabHostsContainer = nil
                self.tabHostsHeight = 0
            }else if self.style == UIViewPagerStyle.tabHost {
                setupTabHostContainer()
            }
        }
    }
    
    public var currentIndex:Int = 0
    
    private var previousIndex:Int = 0
    
    private var contentViews:[UIView] = [];
    
    internal(set) var tabHostsHeight:CGFloat = 0
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupViewPager();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setupViewPager();
    }
    
    private func setupTabHostContainer() {
        tabHostsHeight = 44
        if tabHostsContainer == nil {
            tabHostsContainer = UITabHostsContainer(frame: CGRect(x: 0, y: 0, width: bounds.width, height: tabHostsHeight));
        }
        tabHostsContainer!.dataSource = self;
        tabHostsContainer!.delegate = self;
        addSubview(tabHostsContainer!);
    }
    
    func setupViewPager() {
        if style == UIViewPagerStyle.tabHost {
            setupTabHostContainer()
        }
        
        // Cretae content view
        contentView = UIScrollView(frame: CGRect(x: 0, y: tabHostsHeight, width: bounds.width, height: bounds.height));
        contentView.backgroundColor = UIColor.clear;
        contentView.showsHorizontalScrollIndicator = false;
        contentView.bounces = false;
        contentView.isPagingEnabled = true;
        contentView.decelerationRate = UIScrollViewDecelerationRateFast;
        contentView.delegate = self;
        addSubview(contentView);
    }
    
    public override func layoutSubviews() {
        if let tabHostsContainer = self.tabHostsContainer {
            tabHostsContainer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44);
            tabHostsContainer.layoutSubviews();
        }
        contentView.frame = CGRect(x: 0, y: tabHostsHeight, width: bounds.width, height: bounds.height);
        let contentFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - tabHostsHeight)
        // Layout content views
        for i in 0 ..< contentViews.count {
            let view = contentViews[i];
            var frame = contentFrame;
            frame.x = i*frame.width;
            view.frame = frame;
            view.layoutSubviews();
        }
        let width = contentViews.count*contentView.bounds.width;
        let height = contentView.bounds.height;
        contentView.contentSize = CGSize(width: width, height: height);
        contentView.setContentOffset(CGPoint(x: bounds.width*self.currentIndex, y: 0), animated: true);
    }
    
    public func reloadData() {
        currentIndex = 0;
        if let tabHostsContainer = self.tabHostsContainer {
            tabHostsContainer.reloadData();
            tabHostsContainer.setSelected(currentIndex);
        }
        // Remove all subviews
        for view in contentView.subviews {
            view.removeFromSuperview();
        }
        createPages();
    }
    
    func createPages() {
        if let ds = self.dataSource {
            let contentFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - tabHostsHeight)
            let capacity = ds.numberOfItems(self);
            contentViews = [];
            for i in 0...capacity - 1 {
                let controller = ds.controller(self, index: i);
                let view = controller.view;
                var frame = contentFrame;
                frame.x = i*frame.width;
                view?.frame = frame;
                contentViews.append(view!);
                contentView.addSubview(view!);
            }
            let width = contentViews.count*contentView.bounds.width;
            let height = contentView.bounds.height;
            contentView.contentSize = CGSize(width: width, height: height);
        }
    }
    
    //MARK: UITabHostsContainerDataSource
    public func numberOfTabHostsWithContainer(_ container: UITabHostsContainer) -> Int {
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
    
    public func titleAtIndex(_ index: Int, container: UITabHostsContainer) -> String? {
        if container == tabHostsContainer {
            return self.dataSource?.titleForItem?(self, index: index);
        }else {
            return "";
        }
    }
    
    public func viewAtIndex(_ index: Int, container: UITabHostsContainer) -> UIView? {
        if container == tabHostsContainer {
            return dataSource?.tabHostView?(self, index: index);
        }else {
            return nil;
        }
    }
    
    public func selectPage(_ index:Int, animated:Bool) {
        let count = self.dataSource?.numberOfItems(self)
        if index < 0 || index >= count {
            return;
        }
        currentIndex = index;
        
        if let tabHostsContainer = self.tabHostsContainer {
            tabHostsContainer.unselectAllTabHost();
            tabHostsContainer.moveToCorrectPointOfScrollView(index);
            tabHostsContainer.setSelected(index);
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                let point = self.contentViews[index].frame.origin;
                self.contentView.contentOffset = point;
            });
        }else {
            let point = self.contentViews[index].frame.origin;
            self.contentView.contentOffset = point;
        }
    }
    
    //MARK:UITabHostsDelegate
    public func didSelectTabHost(_ index: Int, container: UITabHostsContainer) {
        if currentIndex != index {
            currentIndex = index;
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                let point = self.contentViews[index].frame.origin;
                self.contentView.contentOffset = point;
            });
            
            if let delegate = self.delegate {
                delegate.tabHostClicked?(self, index: index);
                delegate.didMove?(self, fromIndex: previousIndex, toIndex: currentIndex);
            }
        }
    }
    
    //MARK:UIScrollViewDelegate
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == contentView {
            previousIndex = currentIndex;
            var nearestIndex = Int(targetContentOffset.pointee.x/scrollView.bounds.width + 0.5);
            nearestIndex = max(min(nearestIndex, contentViews.count - 1), 0);
            delegate?.willMove?(self, fromIndex: previousIndex, toIndex: nearestIndex);
            currentIndex = nearestIndex;
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == contentView {
            if let ds = self.dataSource {
                let capacity = ds.numberOfItems(self);
                if currentIndex >= 0 && currentIndex < capacity {
                    delegate?.didMove?(self, fromIndex: previousIndex, toIndex: currentIndex);
                    if let tabHostsContainer = self.tabHostsContainer {
                        tabHostsContainer.unselectAllTabHost();
                        tabHostsContainer.moveToCorrectPointOfScrollView(currentIndex);
                        tabHostsContainer.setSelected(currentIndex);
                    }
                }
                contentView.setContentOffset(CGPoint(x: bounds.width*self.currentIndex, y: 0), animated: true);
            }
        }
    }
}
