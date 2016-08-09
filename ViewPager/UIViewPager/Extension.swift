//
//  ViewController+Extension.swift
//  MobileMap
//
//  Created by damingdan on 15/2/7.
//  Copyright (c) 2015年 Kingoit. All rights reserved.
//

import UIKit



extension UIDevice {
    public class func systemVersionFloatValue()->Float {
        return (UIDevice.current.systemVersion as NSString).floatValue;
    }
}

extension CGRect {
    var x:CGFloat {
        get {
            return origin.x;
        }
        set {
            origin.x = newValue;
        }
    }
    
    var y:CGFloat {
        get {
            return origin.y;
        }
        set {
            origin.y = newValue;
        }
    }
}

extension UIViewController {
    
    /**
    Add the keyboard notification to current view that when keyboard showing, the view will shift to make the first responder view can be seen.
    */
    public func bindKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    /**
    When the keyboard show, make the view shit so that the responder text field can be seen. IOS7 and IOS8 have some diffirent in rect of the views at diffirent orientation.
    
    - parameter notification:
    */
    func keyboardWillShow(_ notification:Notification) {
        let firstResponder = self.view.findFirstResponderView();
        if firstResponder == nil {
            return;
        }
        if !firstResponder!.isKind(of: UITextField.classForCoder()) {
            return;
        }
        let window = UIApplication.shared.keyWindow;
        if window == nil {
            return;
        }
        
        var responderFrame = window?.convert(firstResponder!.frame, from: firstResponder?.superview);
        
        var userInfo = (notification as NSNotification).userInfo;
        let value: NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue;
        var keyboardRect = value.cgRectValue;
        let animationDurationValue: NSValue = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSValue;
        var animationDuration:TimeInterval = 0;
        animationDurationValue.getValue(&animationDuration);
        
        
        let width = window!.frame.width;
        let height = window!.frame.height;
        var x:CGFloat = 0;
        var y:CGFloat = 0;
        
        if UIDevice.systemVersionFloatValue() > 8.0 {
            x = (keyboardRect.x == 0) ?0:(keyboardRect.x - responderFrame!.x - responderFrame!.height);
            y = (keyboardRect.y == 0) ?0:(keyboardRect.y - responderFrame!.y - responderFrame!.height);
            x = x > 0 ?0:x;
            y = y > 0 ?0:y;
        }else {
            let orientation = UIApplication.shared.statusBarOrientation;
            if orientation == UIInterfaceOrientation.portraitUpsideDown {
                x = 0;
                y = responderFrame!.y - keyboardRect.height;
            }else if orientation == UIInterfaceOrientation.landscapeLeft {
                x = keyboardRect.width - responderFrame!.x;
                y = 0;
            }else if orientation == UIInterfaceOrientation.landscapeRight {
                x = responderFrame!.x - keyboardRect.width;
                y = 0;
            }else if orientation == UIInterfaceOrientation.portrait {
                x = 0;
                y = keyboardRect.height - responderFrame!.y;
            }
        }
        
        let rect = CGRect(x: x, y: y, width: width, height: height);
        view.layoutIfNeeded();
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            window!.frame = rect;
        });
    }
    
    /**
    Reset the view controller's view
    
    - parameter notification:
    */
    func keyboardWillHide(_ notification:Notification) {
        let window = UIApplication.shared.keyWindow;
        if window == nil {
            return;
        }
        var userInfo = (notification as NSNotification).userInfo!;
        let animationDurationValue:NSValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSValue;
        var animationDuration:TimeInterval = 0;
        animationDurationValue.getValue(&animationDuration);
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            window!.frame = CGRect(x: 0, y: 0, width: window!.frame.width, height: window!.frame.height)
        });
    }
}

extension UIScrollView {
    public func bindKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let firstResponder = self.findFirstResponderView();
        if firstResponder == nil {
            return;
        }
        if !firstResponder!.isKind(of: UITextField.classForCoder()) {
            return;
        }
        
        let respnderFrame = self.convert(firstResponder!.frame, from: firstResponder!.superview);
        self.scrollRectToVisible(respnderFrame, animated: true);
    }
}

extension UIColor {
    class func colorWithRGB(_ value:Int)->UIColor {
        return self.colorWithRGB(value, alpha: 1)
    }
    
    class func colorWithRGB(_ value:Int, alpha:CGFloat)->UIColor {
        let redValue = CGFloat((value & 0xFF0000) >> 16)/255.0;
        let greenValue = CGFloat((value & 0x00FF00) >> 8)/255.0;
        let blueValue = CGFloat(value & 0x0000FF)/255.0;
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha);
    }
}

extension UIView {
    /**
    Find the first responder sub view
    
    - returns: the first responder view.
    */
    public func findFirstResponderView()->UIView? {
        if self.isFirstResponder {
            return self;
        }
        
        for subView in self.subviews {
            let view = subView.findFirstResponderView();
            if view != nil {
                return view;
            }
        }
        return nil;
    }
}

extension NSString {
    class public func isEmpty(_ string: NSString?)->Bool {
        if string == nil {
            return true;
        }
        
        if !string!.isKind(of: NSString.classForCoder()) {
            if string!.isKind(of: NSNull.classForCoder()) {
                return true;
            }else {
                return false;
            }
        }
        
        if string!.trim().length == 0 {
            return true;
        }
        return false;
    }
    
    public func trim()->NSString {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
    }
}
