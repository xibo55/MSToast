//
//  MSToast.swift
//  MSToast
//
//  Created by Michael Shang on 1/12/17.
//  Copyright © 2017 Michael Shang. All rights reserved.
//

import UIKit


public class MSToast: NSObject {
    // the singleton
    static let shared: MSToast = MSToast()
    
    // styles
    /// the horizontal margin on each side between toast container view and device side edges
    static var minimumOutsideHorizontalMargin: CGFloat = 20.0;
    /// the vertical margin at the bottom between toast container view and device bottom edge
    static var minimumOutsideVerticalMargin: CGFloat = 20.0;
    /// the horizontal padding on left&right sides between the outside toast container view rect and the inside message label rect
    static var minimumInsideHorizontalPadding: CGFloat = 20.0;
    /// the vertical padding on top&bottom sides between the outside toast container view rect and the inside message label rect
    static var minimumInsideVerticalPadding: CGFloat = 10.0;
    
    /// the containers background color. use this to set its background opacity as well
    static var containerBackgroundColor: UIColor = MSHelpers.rgba(0, g: 0, b: 0, a: 0.8);
    static var containerCornerRadius: CGFloat = 5.0;
    static var messageFont: UIFont = UIFont.systemFont(ofSize: 15.0);
    static var messageTextColor: UIColor = UIColor.white;
    
    /// the gradual show/hide animation duration
    static var showHideAnimationDuration = 0.2;

    // array that holds all current toasts
    static var toasts: [UIView] = [UIView]();
    
    // the timer for hiding
    static var hideTimer: Timer?

    /// Show Toast
    /// - parameter targetView: the target container view to be displaying the toast, usually the vc.view
    /// - parameter text: the message to be displayed
    /// - parameter duration: for the toast to display
    public class func showToast(_ targetView: UIView, text: String, duration: TimeInterval) {
        
        let font = MSToast.messageFont;
        
        /************************************************/
        /********** Constructing Message Label **********/
        /************************************************/
        
        // calculating the bounds for the label based on text
        let textString = text as NSString
        let textAttributes = [NSFontAttributeName: font]
        
        let maxLabelWidth = MSHelpers.getDeviceWidth() - 2 * MSToast.minimumInsideHorizontalPadding - 2 * MSToast.minimumOutsideHorizontalMargin;
        
        let boundingRect = textString.boundingRect(with: CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil);
        
        // construct the label
        let messageLabel = UILabel(frame: CGRect(x: MSToast.minimumInsideHorizontalPadding, y: MSToast.minimumInsideVerticalPadding, width: boundingRect.width, height: boundingRect.height));
        messageLabel.text = text;
        messageLabel.textAlignment = .center;
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = .byWordWrapping;
        messageLabel.textColor = MSToast.messageTextColor;
        messageLabel.font = font;
        
        /************************************************/
        /********** Constructing Container View *********/
        /************************************************/
        
        let containerOriginX = max(MSToast.minimumOutsideHorizontalMargin, (MSHelpers.getDeviceWidth() - 2 * MSToast.minimumInsideHorizontalPadding - boundingRect.width) / 2) ;
        let containerOriginY = MSHelpers.getDeviceHeight() - MSToast.minimumOutsideVerticalMargin - boundingRect.height - 2 * MSToast.minimumInsideVerticalPadding;
        
        // container width
        let maxContainerWidth = MSHelpers.getDeviceWidth() - 2 * MSToast.minimumOutsideHorizontalMargin;
        let containerWidth = min(maxContainerWidth, boundingRect.width + 2 * MSToast.minimumInsideHorizontalPadding);
        
        // container height
        let containerHeight = boundingRect.height + 2 * MSToast.minimumInsideVerticalPadding;
        
        let containerView = UIView(frame: CGRect(x: containerOriginX, y: containerOriginY, width: containerWidth, height: containerHeight));
        containerView.backgroundColor = MSToast.containerBackgroundColor;
        containerView.layer.cornerRadius = MSToast.containerCornerRadius;
        containerView.clipsToBounds = true;
        containerView.layer.opacity = 0.0;

        // adding the views together
        containerView.addSubview(messageLabel);
        targetView.addSubview(containerView);
        
        // invalidate the timer immediately before animations
        if self.hideTimer != nil {
            self.hideTimer?.invalidate();
        }
        
        // if there are any toasts already showing
        // hide current toast and show
        if toasts.count > 0 {
            MSHelpers.hideToastWithAnimation(toasts[toasts.count - 1], duration: MSToast.showHideAnimationDuration, callback: {
                
                // remove the hided one from array
                toasts.remove(at: toasts.count - 1);
                
                // show the new one
                MSHelpers.showToastWithAnimation(containerView, duration: MSToast.showHideAnimationDuration);
                toasts.append(containerView);
                
                // add the timer for auto-hide
                self.hideTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(hideAllToasts), userInfo: nil, repeats: false);
            });
            
        // if there are no toast currently showing
        // just show the new one
        } else {
            MSHelpers.showToastWithAnimation(containerView, duration: MSToast.showHideAnimationDuration);
            toasts.append(containerView);
            
            // add the timer for auto-hide
            self.hideTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(hideAllToasts), userInfo: nil, repeats: false);
        }
        
    }
    
    
    /// hide all toasts that are currently showing
    public class func hideAllToasts() {
        // after all toast views have started hiding, just clear the array because we don't need the references to toast views any more
        for toast in toasts.enumerated() {
            print("\(toast.offset) in \(toasts.count)");
            MSHelpers.hideToastWithAnimation(toast.element, duration: MSToast.showHideAnimationDuration);
        }
        toasts.removeAll();
    }
    
    

}






/*****************************************************/
/**************** Following are Helpers **************/
/*****************************************************/

/// overloads -/+ between a cgfloat on the left and an int/double on the right
func - (left: CGFloat, right: Double) -> CGFloat {
    return left - CGFloat(right);
}

func - (left: CGFloat, right: Int) -> CGFloat {
    return left - CGFloat(right);
}

func + (left: CGFloat, right: Double) -> CGFloat {
    return left + CGFloat(right);
}

func + (left: CGFloat, right: Int) -> CGFloat {
    return left + CGFloat(right);
}

class MSHelpers: NSObject {
    
    /**************************************************************************************/
    /***************************************  TOOLS  ****************************************/
    /**************************************************************************************/
    
    // MARK: - TOOLS
    class func getDeviceWidth()-> CGFloat {
        let mainWindow = (UIApplication.shared.windows as NSArray).object(at: 0)
        return (mainWindow as AnyObject).frame.size.width
    }
    
    class func getDeviceHeight()-> CGFloat {
        let mainWindow = (UIApplication.shared.windows as NSArray).object(at: 0)
        return (mainWindow as AnyObject).frame.size.height
    }
    
    
    /// RGBa helper
    /// input based on 255
    class func rgba(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a);
    }
    
    
    
    // 动态显示一个View
    class func showToastWithAnimation(_ targetView: UIView, duration: TimeInterval) {
        targetView.isHidden = false;
        targetView.layer.opacity = 0;
        UIView.animate(withDuration: duration, animations: {
            targetView.layer.opacity = 1;
        });
    }
    
    // 动态隐藏一个View
    /// remove the view from superview completely
    class func hideToastWithAnimation(_ targetView: UIView, duration: TimeInterval) {
        
        MSHelpers.hideToastWithAnimation(targetView, duration: duration) {
            
        }
        
    }
    
    // 动态隐藏一个View
    /// remove the view from superview completely
    class func hideToastWithAnimation(_ targetView: UIView, duration: TimeInterval, callback: @escaping ()->Void ) {
        
        targetView.isHidden = false;
        targetView.layer.opacity = 1;
        
        UIView.animate(withDuration: duration, animations: {
            targetView.layer.opacity = 0;
        }, completion: { (finished: Bool) in
            targetView.isHidden = true;
            targetView.removeFromSuperview();
            callback();
        })
        
    }
    
    
    
    
}

