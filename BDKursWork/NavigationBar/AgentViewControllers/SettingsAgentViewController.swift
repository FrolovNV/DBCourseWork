//
//  SettingsAgentViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 09.12.2020.
//

import UIKit

class SettingsAgentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButtonAction))
        super.navigationItem.title = "Settings"
        super.view.backgroundColor = .white
    }
}

//MARK:-Actions for bar button
extension SettingsAgentViewController {
    
    @objc func exitButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
