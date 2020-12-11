//
//  OneLineTextField.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit

class OneLineTextField: UITextField {
    
    convenience init(font: UIFont? = .avenir20()) {
        self.init()
        self.font = font
        self.borderStyle = .none
        var bottomView = UIView()
        bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .black
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

