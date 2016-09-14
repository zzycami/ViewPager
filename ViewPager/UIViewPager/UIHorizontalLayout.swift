//
//  UIHorizontalLayout.swift
//  ViewPager
//
//  Created by damingdan on 15/5/14.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

@objc public protocol UIHorizontalLayoutDataSource:NSObjectProtocol {
    func numberOfControllers(_ layout:UIHorizontalLayout)->Int
    
    func controller(_ layout:UIHorizontalLayout, index:Int)->UIViewController
}

public class UIHorizontalLayout: UIView {
    public var contentView:UIScrollView!
    
    public var dataSource:UIHorizontalLayoutDataSource?
    
    private var contentViews:[UIView] = []
    
    private var containerView:UIView = UIView(frame: CGRect.zero)
    
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
        contentView = UIScrollView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height));
        contentView.backgroundColor = UIColor.clear
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.bounces = false
        contentView.isPagingEnabled = false
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
        for i in 0 ..< contentViews.count {
            let view = contentViews[i]
            var frame = bounds
            frame.size.width = self.singleWidth
            frame.x = i*self.singleWidth
            view.frame = frame
            view.layoutSubviews()
        }
        let width = contentViews.count*self.singleWidth
        let height = contentView.bounds.height
        contentView.contentSize = CGSize(width: width, height: height)
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
                view?.frame = frame
                contentViews.append(view!)
                contentView.addSubview(view!)
            }
            let width = contentViews.count*self.singleWidth
            let height = contentView.bounds.height
            contentView.contentSize = CGSize(width: width, height: height)
        }
    }
}
