//
//  PeacherViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit

class PeacherViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3776089847, alpha: 1)
        
        viewControllers = [
            generateViewController(rootViewController: ProductsAgentViewController(style: .insetGrouped), image: #imageLiteral(resourceName: "search"), title: "Working"),
            generateViewController(rootViewController: ProductTableViewAddingProducts(style: .insetGrouped), image: #imageLiteral(resourceName: "Add"), title: "Products")
        ]
    }
}


//MARK:- Set Up View Controllers
extension PeacherViewController {
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
