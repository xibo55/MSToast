# MSToast
A simple android-like toast written in Swift 3.0

How to install?
Cocoapod: pod 'MSToast'
Manual: drag MSToast.swift file into your project. Done.

How to use?
// display "Sample Mesasge" at the bottom of targetView for 2 seconds
MSToast.showToast(targetView, text: "Sample Message", duration: 2); 
//  hide all toasts in display
MSToast.hideAllToasts(); 

Styles

Change a style like this: 
    MSToast.minimumOutsideHorizontalMargin = 21.0;
The change will be global and encouraged to put this in AppDelegate.

    /// the horizontal margin on each side between toast container view and device side edges
    public static var minimumOutsideHorizontalMargin: CGFloat = 20.0;
    /// the vertical margin at the bottom between toast container view and device bottom edge
    public static var minimumOutsideVerticalMargin: CGFloat = 20.0;
    /// the horizontal padding on left&right sides between the outside toast container view rect and the inside message label rect
    public static var minimumInsideHorizontalPadding: CGFloat = 20.0;
    /// the vertical padding on top&bottom sides between the outside toast container view rect and the inside message label rect
    public static var minimumInsideVerticalPadding: CGFloat = 10.0;
    
    /// the containers background color. use this to set its background opacity as well
    public static var containerBackgroundColor: UIColor = MSHelpers.rgba(0, g: 0, b: 0, a: 0.8);
    public static var containerCornerRadius: CGFloat = 5.0;
    public static var messageFont: UIFont = UIFont.systemFont(ofSize: 15.0);
    public static var messageTextColor: UIColor = UIColor.white;
    
    /// the gradual show/hide animation duration
    public static var showHideAnimationDuration = 0.2;

