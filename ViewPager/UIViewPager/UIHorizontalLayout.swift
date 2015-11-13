//
//  UIHorizontalLayout.swift
//  ViewPager
//
//  Created by damingdan on 15/5/14.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

@objc public protocol UIHorizontalLayoutDataSource:NSObjectProtocol {
    func numberOfControllers(layout:UIHorizontalLayout)->Int
    
    func controller(layout:UIHorizontalLayout, index:Int)->UIViewController
}

public class UIHorizontalLayout: UIView {
    public var contentView:UIScrollView!
    
    public var dataSource:UIHorizontalLayoutDataSource?
    
    private var contentViews:[UIView] = []
    
    private var containerView:UIView = UIView(frame: CGRectZero)
    
    public var singleWidth:CGFloat = 400
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHorizontalLayout()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupHorizontalLayout()
    }
    
    func setupHorizontalLayout() {
        // Cretae content view
        contentView = UIScrollView(frame: CGRectMake(0, 0, bounds.width, bounds.height));
        contentView.backgroundColor = UIColor.clearColor()
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.bounces = false
        contentView.pagingEnabled = false
        contentView.decelerationRate = UIScrollViewDecelerationRateFast
        addSubview(contentView)
    }
    
    public func reloadData() {
        // Remove all subviews
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        createPages()
    }
    
    public override func layoutSubviews() {
        // Layout content views
        for var i=0;i<contentViews.count;i++ {
            let view = contentViews[i]
            var frame = bounds
            frame.size.width = self.singleWidth
            frame.x = i*self.singleWidth
            view.frame = frame
            view.layoutSubviews()
        }
        let width = contentViews.count*self.singleWidth
        let height = contentView.bounds.height
        contentView.contentSize = CGSizeMake(width, height)
    }
    
    func createPages() {
        if let ds = self.dataSource {
            let capacity = ds.numberOfControllers(self);
            if capacity <= 0 {
                return
            }
            contentViews = [];
            for i in 0...capacity - 1 {
                let controller = ds.controller(self, index: i)
                let view = controller.view
                var frame = bounds
                frame.size.width = self.singleWidth
                frame.x = i*self.singleWidth
                view.frame = frame
                contentViews.append(view)
                contentView.addSubview(view)
            }
            let width = contentViews.count*self.singleWidth
            let height = contentView.bounds.height
            contentView.contentSize = CGSizeMake(width, height)
        }
    }
}
