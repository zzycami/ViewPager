//
//  UITabHost.swift
//  ViewPager
//
//  Created by damingdan on 15/2/10.
//  Copyright (c) 2015年 kuteng. All rights reserved.
//

import UIKit

let defaultColor = UIColor(white: 0.7725, alpha: 0.75)

public typealias OnClickCallBack = (tabHost:UITabHost)->Void;

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
            if let label = contentView as? UILabel {
                label.textColor = titleColor;
            }
        }
    }
    
    /// text's font
    public var titleFont:UIFont = UIFont.systemFontOfSize(14) {
        didSet {
            if let label = contentView as? UILabel {
                label.font = titleFont;
            }
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
            if let label = contentView as? UILabel {
                label.text = newValue;
                adjustLabel(label);
            }
        }
        
        get {
            if let label = contentView as? UILabel {
                return label.text;
            }else {
                return "";
            }
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
    
    public var contentView:UIView? {
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
    
    public var onClick:OnClickCallBack?
    
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
    
    //MARK: Actions
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let onClick = self.onClick {
            onClick(tabHost: self);
        }
    }
}

@objc protocol UITabHostDataSource:NSObjectProtocol {
    func numberOfTabHostsWithContainer(container:UITabHostsContainer)->UInt;
    
    optional func titleAtIndex(index:UInt, container:UITabHostsContainer)->String;
    optional func viewAtIndex(index:UInt, container:UITabHostsContainer)->UIView;
}

@objc protocol UITabHostDelegate:NSObjectProtocol {
    optional func didSelectTabHost(index:UInt, container:UITabHostsContainer);
    
    optional func topColorForTabHost(index:UInt, container:UITabHostsContainer)->UIColor;
    optional func bottomColorForTabHost(index:UInt, container:UITabHostsContainer)->UIColor;
    optional func selectedColorForTabHost(index:UInt, container:UITabHostsContainer)->UIColor;
    optional func titleColorForTabHost(index:UInt, container:UITabHostsContainer)->UIColor;
    optional func titleFontForTabHost(index:UInt, container:UITabHostsContainer)->UIFont;
}


class UITabHostsContainer: UIView {
    var scrollView:UIScrollView!
    var dataSource:UITabHostDataSource?
    var delegate:UITabHostDelegate?
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
        if let dataSource = self.dataSource {
            var capacity = dataSource.numberOfTabHostsWithContainer(self);
            for i:UInt in 0...capacity {
                createView(i, capacity: capacity);
            }
        }
        
    }
    
    func createView(index:UInt, capacity:UInt){
        var tabHost:UITabHost!;
        if let view = dataSource?.viewAtIndex?(index, container: self) {
            tabHost = createTabHostWithView(view, index: index, capacity: capacity);
        }else if let title = dataSource?.titleAtIndex?(index, container: self){
            tabHost = createTabHostWithTitle(title, index:index, capacity: capacity);
        }
        
        scrollView.addSubview(tabHost);
        tabArray.append(tabHost);
        //TODO: response to delegate
    }
    
    func unselectAllTabHost() {
        for tabHost in tabArray {
            tabHost.selected = false;
        }
    }
    
    func createTabHostWithTitle(title:String, index:UInt, capacity:UInt)->UITabHost {
        var width = tabHostWidthWithCapacity(capacity);
        var tabHost = UITabHost(frame: CGRectMake(width*index, 0, width, self.frame.height));
        customizeTabHost(tabHost, index: index);
        if let title = dataSource?.titleAtIndex?(index, container: self) {
            tabHost.title = title;
        }
        return tabHost;
    }
    
    func createTabHostWithView(view:UIView, index:UInt, capacity:UInt)->UITabHost {
        var width = tabHostWidthWithCapacity(capacity);
        var tabHost = UITabHost(frame: CGRectMake(width*index, 0, width, self.frame.height));
        if let view = self.dataSource?.viewAtIndex?(index, container: self)  {
            tabHost.contentView = view;
        }
        return tabHost;
    }
    
    /**
    Apply the delegate's appearance setting
    
    :param: tabHost the UITabHost to be setting
    :param: index the index of UITabHost
    */
    func customizeTabHost(tabHost:UITabHost, index:UInt) {
        if let delegate = self.delegate {
            if let color = delegate.topColorForTabHost?(index, container: self) {
                tabHost.topColor = color;
            }
            
            if let color = delegate.bottomColorForTabHost?(index, container: self) {
                tabHost.bottomColor = color;
            }
            
            if let color = delegate.selectedColorForTabHost?(index, container: self) {
                tabHost.selectedColor = color;
            }
            
            if let color = delegate.titleColorForTabHost?(index, container: self) {
                tabHost.titleColor = color;
            }
            
            if let font = delegate.titleFontForTabHost?(index, container: self) {
                tabHost.titleFont = font;
            }
        }
    }
    
    /**
    Calculate the tab host width, the max count is 3.
    
    :param: capacity tab host count
    
    :returns: single tab host's width
    */
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