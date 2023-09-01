//
//  UIView+Extension.swift
//  Parkee
//
//  Created by Adhitya Bagas on 31/08/23.
//

import Foundation
import UIKit

var spinnerView : UIView?

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
    
    func addSpinner() {
        spinnerView = UIView(frame: self.bounds)
        guard let spinnerView = spinnerView else {
            return
        }
        spinnerView.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        spinnerView.addSubview(activityIndicator)
        addSubview(spinnerView)
    }
    
    func removeSpinner() {
        spinnerView?.removeFromSuperview()
    }
}
