//
//  UIStackView+Extension.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit


extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
    
}
