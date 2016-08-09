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
    public var titleFont:UIFont = UIFont.systemFont(ofSize: 14) {
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
                contentView!.backgroundColor = UIColor.clear;
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
    
    - parameter label:
    */
    func adjustLabel(_ label:UILabel) {
        var size = label.sizeThatFits(bounds.size);
        if size.width > frame.width {
            size.width = frame.width;
        }
        var titleFrame = label.frame;
        titleFrame.size = size;
        label.frame = titleFrame;
        label.textAlignment = NSTextAlignment.center;
        label.adjustsFontSizeToFitWidth = true;
        label.center = CGPoint(x: bounds.width/2, y: bounds.height/2);
    }
    
    public override func layoutSubviews() {
        if let label = contentView as? UILabel {
            self.adjustLabel(label);
        }else {
            contentView?.layoutSubviews();
        }
    }
    
    public var contentView:UIView? {
        didSet {
            if let view = oldValue {
                view.removeFromSuperview();
            }
            if let view = contentView {
                addSubview(view);
                bringSubview(toFront: view);
            }
        }
    }
    
    public var onClick:OnClickCallBack?
    
    //MARK: Initials
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupTabHost();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setupTabHost();
    }
    
    private func setupTabHost() {
        backgroundColor = UIColor.clear;
    }
    
    //MARK: Draws
    override public func draw(_ rect: CGRect) {
        drawTopLine(UIBezierPath(), rect: rect);
        drawBottomLine(UIBezierPath(), rect: rect);
        if isSelected() {
            drawSelectedLine(UIBezierPath(), rect: rect);
        }
    }
    
    private func drawTopLine(_ bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.move(to: CGPoint.zero);
        bezierPath.addLine(to: CGPoint(x: rect.width, y: 0));
        self.topColor.setStroke();
        bezierPath.lineWidth = 1;
        bezierPath.stroke();
    }
    
    private func drawBottomLine(_ bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.move(to: CGPoint(x: 0, y: rect.height));
        bezierPath.addLine(to: CGPoint(x: rect.width, y: rect.height));
        self.bottomColor.setStroke();
        bezierPath.lineWidth = 1;
        bezierPath.stroke();
    }
    
    private func drawSelectedLine(_ bezierPath:UIBezierPath, rect:CGRect) {
        bezierPath.move(to: CGPoint(x: 0, y: rect.height));
        bezierPath.addLine(to: CGPoint(x: rect.width, y: rect.height));
        self.selectedColor.setStroke();
        bezierPath.lineWidth = 5;
        bezierPath.stroke();
    }
    
    //MARK: Actions
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let onClick = self.onClick {
            onClick(tabHost: self);
        }
    }
}

@objc public protocol UITabHostDataSource:NSObjectProtocol {
    func numberOfTabHostsWithContainer(_ container:UITabHostsContainer)->Int;
    
    @objc optional func titleAtIndex(_ index:Int, container:UITabHostsContainer)->String?;
    @objc optional func viewAtIndex(_ index:Int, container:UITabHostsContainer)->UIView?;
}

@objc public protocol UITabHostDelegate:NSObjectProtocol {
    @objc optional func didSelectTabHost(_ index:Int, container:UITabHostsContainer);
    
    @objc optional func topColorForTabHost(_ index:Int, container:UITabHostsContainer)->UIColor;
    @objc optional func bottomColorForTabHost(_ index:Int, container:UITabHostsContainer)->UIColor;
    @objc optional func selectedColorForTabHost(_ index:Int, container:UITabHostsContainer)->UIColor;
    @objc optional func titleColorForTabHost(_ index:Int, container:UITabHostsContainer)->UIColor;
    @objc optional func titleFontForTabHost(_ index:Int, container:UITabHostsContainer)->UIFont;
}


public class UITabHostsContainer: UIView {
    var scrollView:UIScrollView!
    
    public weak var dataSource:UITabHostDataSource?
    
    public weak var delegate:UITabHostDelegate?
    
    /// Current selected index of tab host
    public var selectedIndex:Int = 0
    
    // Cash for tab hosts
    private var tabArray:[UITabHost] = []
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupTabHostsContainer();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
        setupTabHostsContainer();
    }
    
    /**
    Init and setup the subviews.
    */
    func setupTabHostsContainer() {
        // init scroll view
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height));
        scrollView.backgroundColor = UIColor.clear;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.isScrollEnabled = false;
        addSubview(scrollView);
    }
    
    public override func layoutSubviews() {
        adjustScrolView();
        
        for i in 0 ..< tabArray.count {
            let tabHost = tabArray[i];
            let width = tabHostWidthWithCapacity(tabArray.count);
            tabHost.frame = CGRect(x: width*i, y: 0, width: width, height: scrollView.frame.height);
            tabHost.layoutSubviews();
        }
    }
    
    /**
    When the the data source is changed, the view will not change right now, you should call this method to make the view changes
    */
    public func reloadData() {
        // Remove All the sub views in the scroll view
        for view in scrollView.subviews {
            view.removeFromSuperview();
        }
        // Add new pages
        createTabs();
    }
    
    func createTabs() {
        if let dataSource = self.dataSource {
            let capacity = dataSource.numberOfTabHostsWithContainer(self);
            if capacity > 0 {
                for i:Int in 0..<capacity {
                    createView(i, capacity: capacity);
                }
            }
        }
        adjustScrolView();
        // Set the first selected
        tabArray[0].selected = true;
        selectedIndex = 0;
    }
    
    func adjustScrolView() {
        let width = self.tabHostWidthWithCapacity(tabArray.count) * tabArray.count;
        let height = scrollView.frame.height;
        scrollView.contentSize = CGSize(width: width, height: height);
        scrollView.frame = self.bounds;
    }
    
    func createView(_ index:Int, capacity:Int){
        var tabHost:UITabHost!;
        if let view = dataSource?.viewAtIndex?(index, container: self) {
            tabHost = createTabHostWithView(view, index: index, capacity: capacity);
        }else if let title = dataSource?.titleAtIndex?(index, container: self){
            tabHost = createTabHostWithTitle(title, index:index, capacity: capacity);
        }
        
        scrollView.addSubview(tabHost);
        tabArray.append(tabHost);
        
        // response to delegate
        if let delegate = self.delegate {
            tabHost.onClick = {(tabHost:UITabHost) ->Void in
                //Move to the right position
                self.moveToCorrectPointOfScrollView(index);
                self.unselectAllTabHost();
                tabHost.selected = true;
                self.selectedIndex = index;
                delegate.didSelectTabHost?(index, container: self);
            }
        }
    }
    
    public func setSelected(_ index:Int) {
        if index < 0 || index > tabArray.count {
            return;
        }
        tabArray[index].selected = true;
    }
    
    public func moveToCorrectPointOfScrollView(_ index:Int) {
        if Int(index) < tabArray.count - 1 && Int(index) > 0 {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.scrollView.contentOffset = self.tabArray[index - 1].frame.origin;
            })
        }
    }
    
    public func unselectAllTabHost() {
        for tabHost in tabArray {
            tabHost.selected = false;
        }
    }
    
    func createTabHostWithTitle(_ title:String, index:Int, capacity:Int)->UITabHost {
        let width = tabHostWidthWithCapacity(capacity);
        let tabHost = UITabHost(frame: CGRect(x: width*index, y: 0, width: width, height: self.frame.height));
        if let title = dataSource?.titleAtIndex?(index, container: self) {
            tabHost.title = title;
        }
        customizeTabHost(tabHost, index: index);
        return tabHost;
    }
    
    func createTabHostWithView(_ view:UIView, index:Int, capacity:Int)->UITabHost {
        let width = tabHostWidthWithCapacity(capacity);
        let tabHost = UITabHost(frame: CGRect(x: width*index, y: 0, width: width, height: self.frame.height));
        if let view = self.dataSource?.viewAtIndex?(index, container: self)  {
            tabHost.contentView = view;
        }
        return tabHost;
    }
    
    /**
    Apply the delegate's appearance setting
    
    - parameter tabHost: the UITabHost to be setting
    - parameter index: the index of UITabHost
    */
    func customizeTabHost(_ tabHost:UITabHost, index:Int) {
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
    
    - parameter capacity: tab host count
    
    - returns: single tab host's width
    */
    func tabHostWidthWithCapacity(_ capacity:Int)->CGFloat {
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
