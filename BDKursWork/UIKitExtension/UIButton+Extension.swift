//
//  UIButton+Extension.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit


extension UIButton {
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont?,
                     backgroundColor: UIColor,
                     isSwadow: Bool,
                     cornedRadius: CGFloat) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornedRadius
        
        if isSwadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
}
