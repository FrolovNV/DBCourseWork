//
//  UITextField+Extension.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 29.11.2020.
//

import UIKit


extension UITextField {
    convenience init(font: UIFont?, colorText: UIColor?) {
        self.init()
        self.font = font
        self.textColor = colorText
    }
}
