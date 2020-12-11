//
//  UILable+Extension.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit

extension UILabel {
    convenience init(text: String , font: UIFont = UIFont(name: "avenir", size: 20)!) {
        self.init()
        self.text = text
        self.font? = font
    }
}
