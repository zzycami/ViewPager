//
//  UITabHost.swift
//  ViewPager
//
//  Created by damingdan on 15/2/10.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

let defaultColor = UIColor(white: 0.7725, alpha: 0.75)

public class UITabHost: UIView {
    //MARK: Properties
    public var selectedColor:UIColor = defaultColor
    
    
    /// Color of the top line
    public var topColor:UIColor = defaultColor
    
    /// Color of bottom line
    public var bottomColor:UIColor = defaultColor
    
    /// text's color
    public var titleColor:UIColor = defaultColor {
        didSet {
            contentView?.textColor = titleColor;
        }
    }
    
    /// text's font
    public var titleFont:UIFont = UIFont.systemFontOfSize(14) {
        didSet {
            contentView?.font = titleFont;
        }
    }
    
    public var selected:Bool = false {
        didSet {
            setNeedsDisplay();
        }
    }
    
    public func isSelected()->Bool {
        return selected;
    }
    
    /// Tab's host's title, binding to content view.
    public var title:String? {
        set {
            if contentView == nil {
                contentView = UILabel();
                contentView!.backgroundColor = UIColor.clearColor();
            }
            contentView!.text = newValue;
            adjustLabel(contentView!);
        }
        
        get {
            return contentView?.text;
        }
    }
    
    /**
    Calculate and set the label's frame. set label' title is fit it's size
    
    :param: label
    */
    func adjustLabel(label:UILabel) {
        var size = label.sizeThatFits(frame.size);
        if size.width > frame.width {
            size.width = frame.width;
        }
        var titleFrame = label.frame;
        titleFrame.size = size;
        label.frame = titleFrame;
        label.adjustsFontSizeToFitWidth = true;
        label.center = CGPointMake(bounds.width/2, bounds.height/2);
    }
    
    var contentView:UILabel? {
        didSet {
            if let view = oldValue {
                view.removeFromSuperview();
            }
            if let view = contentView {
                addSubview(view);
                bringSubviewToFront(view);
            }
        }
    }
    
    //MARK: Initials
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupTabHost();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setupTabHost();
    }
    
    private func setupTabHost() {
        backgroundColor = UIColor.clearColor();
    }
    
    //MARK: Draws
    override public func drawRect(rect: CGRect) {
        drawTopLine(UIBezierPath(), rect: rect);
        drawBottomLine(UIBezierPath(), rect: rect);
        if isSelected() {
            drawSelectedLine(UIBezierPath(), rect: rect);
        }
    }
    
    private func drawTopLine(bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.moveToPoint(CGPointZero);
        bezierPath.addLineToPoint(CGPointMake(rect.width, 0));
        self.topColor.setStroke();
        bezierPath.lineWidth = 1;
        bezierPath.stroke();
    }
    
    private func drawBottomLine(bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.moveToPoint(CGPointMake(0, rect.height));
        bezierPath.addLineToPoint(CGPointMake(rect.width, rect.height));
        self.bottomColor.setStroke();
        bezierPath.lineWidth = 1;
        bezierPath.stroke();
    }
    
    private func drawSelectedLine(bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.moveToPoint(CGPointMake(0, rect.height));
        bezierPath.addLineToPoint(CGPointMake(rect.width, rect.height));
        self.bottomColor.setStroke();
        bezierPath.lineWidth = 5;
        bezierPath.stroke();
    }
}

@objc protocol TabHostDataSource:NSObjectProtocol {
    func numberOfTabHostsWithContainer(container:UITabHostsContainer)->UInt;
    
    optional func titleAtIndex(index:UInt, container:UITabHostsContainer)->String;
    optional func viewAtIndex(index:UInt, container:UITabHostsContainer)->UIView;
}


class UITabHostsContainer: UIView {
    var scrollView:UIScrollView!
    var dataSource:TabHostDataSource?
    var selectedIndex:Int = 0
    
    // Cash for tab hosts
    private var tabArray:[UITabHost] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupTabHostsContainer();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupTabHostsContainer();
    }
    
    /**
    Init and setup the subviews.
    */
    func setupTabHostsContainer() {
        // init scroll view
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height));
        scrollView.backgroundColor = UIColor.clearColor();
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollEnabled = false;
        addSubview(scrollView);
    }
    
    /**
    When the the data source is changed, the view will not change right now, you should call this method to make the view changes
    */
    func reloadData() {
        // Remove All the sub views in the scroll view
        for view in scrollView.subviews {
            view.removeFromSuperview();
        }
        // Add new pages
        createTabs();
    }
    
    func createTabs() {
        var capacity = dataSource?.numberOfTabHostsWithContainer(self);
        
    }
    
    func createView(index:UInt, capacity:UInt){
        var tabHost:UITabHost!;
        if let view = dataSource?.viewAtIndex?(index, container: self) {
            tabHost = createTabHostByView(view, index: index, capacity: capacity);
        }else if let title = dataSource?.titleAtIndex?(index, container: self){
            tabHost = createTabHost(title, index:index, capacity: capacity);
        }
        
        scrollView.addSubview(tabHost);
        tabArray.append(tabHost);
        //TODO: response to delegate
    }
    
    func createTabHost(title:String, index:UInt, capacity:UInt)->UITabHost {
        var width = tabHostWidthWithCapacity(capacity);
        var tabHost = UITabHost(frame: CGRectMake(width*index, 0, width, self.frame.height));
        
        return tabHost;
    }
    
    func createTabHostByView(view:UIView, index:UInt, capacity:UInt)->UITabHost {
        return UITabHost(frame: CGRectMake(0, 0, 0, 0));
    }
    
    func tabHostWidthWithCapacity(capacity:UInt)->CGFloat {
        switch(capacity) {
        case 1:
            return self.frame.width;
        case 2:
            return self.frame.width/2;
        default:
            return CGFloat(ceilf(Float(self.frame.width/3)));
        }
    }
}