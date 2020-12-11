//
//  DetailAboutProductViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 08.12.2020.
//

import UIKit

class DetailAboutProductViewController: UIViewController {
    //MARK:-All var and view did load.
    var product: Products?
    
    var titleLabel = UILabel(text: "Title")
    var countLabel = UILabel(text: "Count")
    var sellerCostLabel = UILabel(text: "Seller Cost")
    var boughtCostLabel = UILabel(text: "Bought Cost")
    var agentNameLabel = UILabel(text: "Who bought")
    var dateLabel = UILabel(text: "Date")
    
    var titleField = UITextField()
    var countField = UITextField()
    var sellerCostField = UITextField()
    var boughtCostField = UITextField()
    var agentNameField = UITextField()
    var dateField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeProduct))
        
        self.navigationItem.title = "Details Info"
        
        titleField.isUserInteractionEnabled = false
        countField.isUserInteractionEnabled = false
        sellerCostField.isUserInteractionEnabled = false
        boughtCostField.isUserInteractionEnabled = false
        agentNameField.isUserInteractionEnabled = false
        dateField.isUserInteractionEnabled = false
        
        titleField.addTarget(self, action: #selector(changeFieldText), for: .allEditingEvents)
        countField.addTarget(self, action: #selector(changeFieldText), for: .allEditingEvents)
        sellerCostField.addTarget(self, action: #selector(changeFieldText), for: .allEditingEvents)
        boughtCostField.addTarget(self, action: #selector(changeFieldText), for: .allEditingEvents)
        
        updateInfo()
        setUpConstraint()
    }
}

//MARK:-Action Section
extension DetailAboutProductViewController {
    
    @objc func changeProduct() {
        changeEdingMode(flag: true)
        changeColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "End Changing", style: .plain, target: self, action: #selector(endChanging))
        
    }
    
    @objc func endChanging(_ sender: UIButton) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeProduct))
        changeEdingMode(flag: false)
        if checkAllField() {
            product?.title = titleField.text!
            product?.count = Int(countField.text!) ?? product!.count
            product?.boughtPrice = Double(boughtCostField.text!) ?? product!.boughtPrice
            product?.sellPrice = Double(sellerCostField.text!) ?? product!.sellPrice
            
            let db = ProductsModelDB()
            db.updateProduct(product: product!)
        }
    }
    
    func checkAllField()->Bool {
        let array = [titleField, countField, sellerCostField, boughtCostField]
        for element in array {
            if element.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    func changeEdingMode(flag: Bool) {
        titleField.isUserInteractionEnabled = flag
        countField.isUserInteractionEnabled = flag
        sellerCostField.isUserInteractionEnabled = flag
        boughtCostField.isUserInteractionEnabled = flag
        agentNameField.isUserInteractionEnabled = flag
        dateField.isUserInteractionEnabled = flag
        if !flag {
            titleLabel.backgroundColor = .white
            titleField.backgroundColor = .white
            
            countLabel.backgroundColor = .white
            countField.backgroundColor = .white
            
            sellerCostLabel.backgroundColor = .white
            sellerCostField.backgroundColor = .white
            
            boughtCostLabel.backgroundColor = .white
            boughtCostField.backgroundColor = .white
        }
    }
    
    func changeColor() {
        if titleField.text == product?.title {
            titleLabel.backgroundColor = .systemGreen
            titleField.backgroundColor = .systemGreen
        } else {
            titleLabel.backgroundColor = .systemRed
            titleField.backgroundColor = .systemRed
        }
        
        if countField.text == String(product!.count) {
            countLabel.backgroundColor = .systemGreen
            countField.backgroundColor = .systemGreen
        } else {
            countLabel.backgroundColor = .systemRed
            countField.backgroundColor = .systemRed
        }
        
        if sellerCostField.text == String(product!.sellPrice) {
            sellerCostLabel.backgroundColor = .systemGreen
            sellerCostField.backgroundColor = .systemGreen
        } else {
            sellerCostLabel.backgroundColor = .systemRed
            sellerCostField.backgroundColor = .systemRed
        }
        
        if boughtCostField.text == String(product!.boughtPrice) {
            boughtCostLabel.backgroundColor = .systemGreen
            boughtCostField.backgroundColor = .systemGreen
        } else {
            boughtCostLabel.backgroundColor = .systemRed
            boughtCostField.backgroundColor = .systemRed
        }
    }
    
    @objc func changeFieldText(_ sender: Any) {
        changeColor()
    }
}

//MARK:- Update Function
extension DetailAboutProductViewController {
    func updateInfo() {
        if product != nil {
            titleField.text = product?.title
            countField.text = String(product!.count)
            sellerCostField.text = String(product!.sellPrice)
            boughtCostField.text = String(product!.boughtPrice)
            agentNameField.text = product?.workerName
            dateField.text = product?.day_of_bought
        }
    }
}

//MARK:- Set Up Constraints
extension DetailAboutProductViewController {
    func setUpConstraint() {
        titleField.font = .avenir20()
        countField.font = .avenir20()
        sellerCostField.font = .avenir20()
        boughtCostField.font = .avenir20()
        agentNameField.font = .avenir20()
        dateField.font = .avenir20()
        
        countField.keyboardType = .numberPad
        sellerCostField.keyboardType = .numberPad
        boughtCostField.keyboardType = .numberPad
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        countField.translatesAutoresizingMaskIntoConstraints = false
        sellerCostField.translatesAutoresizingMaskIntoConstraints = false
        boughtCostField.translatesAutoresizingMaskIntoConstraints = false
        agentNameField.translatesAutoresizingMaskIntoConstraints = false
        dateField.translatesAutoresizingMaskIntoConstraints = false
        
        titleField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        countField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        sellerCostField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        boughtCostField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        agentNameField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        dateField.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        sellerCostLabel.translatesAutoresizingMaskIntoConstraints = false
        boughtCostLabel.translatesAutoresizingMaskIntoConstraints = false
        agentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sellerCostLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        boughtCostLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        agentNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let stackTitle = UIStackView(arrangedSubviews: [titleLabel, titleField], axis: .horizontal, spacing: 0)
        let stackCount = UIStackView(arrangedSubviews: [countLabel, countField], axis: .horizontal, spacing: 0)
        let stackSeller = UIStackView(arrangedSubviews: [sellerCostLabel, sellerCostField], axis: .horizontal, spacing: 0)
        let stackBought = UIStackView(arrangedSubviews: [boughtCostLabel, boughtCostField], axis: .horizontal, spacing: 0)
        let stackAgent = UIStackView(arrangedSubviews: [agentNameLabel, agentNameField], axis: .horizontal, spacing: 0)
        let stackDate = UIStackView(arrangedSubviews: [dateLabel, dateField], axis: .horizontal, spacing: 0)
        
        let stack = UIStackView(arrangedSubviews: [stackTitle, stackCount, stackSeller, stackBought, stackAgent, stackDate], axis: .vertical, spacing: 60)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
    }
}


//MARK:-SwiftUI
import SwiftUI

struct DetailsProductVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let product = DetailAboutProductViewController()
        
        func makeUIViewController(context: Context) -> DetailAboutProductViewController {
            return product
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
