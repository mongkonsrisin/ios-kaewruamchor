//
//  CustomActivityIndicator.swift
//  Kaew Ruam Chor
//
//  Created by Mongkon Srisin on 7/3/2560 BE.
//  Copyright © 2560 SSRU. All rights reserved.
//



import UIKit

@discardableResult




func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    
    
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = false
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor.black
    viewBackgroundLoading.alpha = 0.5
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
   if startAnimate!{
        viewBackgroundLoading.addSubview(activityIndicatorView)
    
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        
        activityIndicatorView.startAnimating()
   }else{
    for subview in viewContainer.subviews{
           if subview.tag == 789456123{
               subview.removeFromSuperview()
           }
    }
}
    return activityIndicatorView
}
