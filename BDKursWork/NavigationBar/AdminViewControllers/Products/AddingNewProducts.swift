//
//  AddingNewProducts.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 08.12.2020.
//

import UIKit


class AddingNewProductsViewControllers: UIViewController {
    //MARK:-All label and field, and viewDidLoad()
    var titleLabel = UILabel(text: "Title")
    var countLabel = UILabel(text: "Count")
    var sellerLabel = UILabel(text: "Seller Price")
    var boughtLabel = UILabel(text: "Bought Price")
    var titleField = UITextField()
    var countField = UITextField()
    var sellerField = UITextField()
    var boughtField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.title = "Add Product"
        super.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewProduct))
        super.navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleField.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        countField.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        sellerField.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        boughtField.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        
        setUpConstraint()
    }
}

//MARK:-Adding Action
extension AddingNewProductsViewControllers {
    
    @objc func addNewProduct(_ sender: UIButton) {
        if checkAllField() {
            creatingPeople()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func checkAllField()->Bool {
        let array = [titleField, countField, sellerField, boughtField]
        for element in array {
            if element.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    func creatingPeople() {
        let title = titleField.text
        let count = countField.text
        let seller = sellerField.text
        let bought = boughtField.text
        let db = ProductsModelDB()
        if checkAllField() {
            guard let countP = Int(count!) else {return}
            guard let seller_cost = Double(seller!) else {return}
            guard let bought_cost = Double(bought!) else {return}
            let prod = Products(id: 0, title: title!, count: countP, sellPrice: Double(seller_cost), boughtPrice: Double(bought_cost), id_worker: 3, day_of_bought: "20.02.2020", workerName: "")
            db.insertProduct(product: prod)
        }
    }
    
    @objc func fieldChange() {
        if checkAllField() {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            return
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

//MARK:-Set Up Constraint
extension AddingNewProductsViewControllers {
    func setUpConstraint() {
        titleField.font = .avenir20()
        countField.font = .avenir20()
        sellerField.font = .avenir20()
        boughtField.font = .avenir20()
        
        countField.keyboardType = .numberPad
        sellerField.keyboardType = .numberPad
        boughtField.keyboardType = .numberPad
        
        titleField.placeholder = "Insert title of product..."
        countField.placeholder = "Insert count of product..."
        sellerField.placeholder = "Insert seller cost of product..."
        boughtField.placeholder = "Insert bought cost of product..."
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        countField.translatesAutoresizingMaskIntoConstraints = false
        sellerField.translatesAutoresizingMaskIntoConstraints = false
        boughtField.translatesAutoresizingMaskIntoConstraints = false
        
        titleField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        countField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sellerField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        boughtField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        sellerLabel.translatesAutoresizingMaskIntoConstraints = false
        boughtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sellerLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        boughtLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let stackTitle = UIStackView(arrangedSubviews: [titleLabel, titleField], axis: .horizontal, spacing: 10)
        let stackCount = UIStackView(arrangedSubviews: [countLabel, countField], axis: .horizontal, spacing: 10)
        let stackSeller = UIStackView(arrangedSubviews: [sellerLabel, sellerField], axis: .horizontal, spacing: 10)
        let stackBought = UIStackView(arrangedSubviews: [boughtLabel, boughtField], axis: .horizontal, spacing: 10)
        
        let stack = UIStackView(arrangedSubviews: [stackTitle, stackCount, stackSeller, stackBought], axis: .vertical, spacing: 60)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
    }
}


//MARK:-SwiftUI
import SwiftUI

struct AddingProductVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let addingProduct = AddingNewProductsViewControllers()
        
        func makeUIViewController(context: Context) -> AddingNewProductsViewControllers {
            return addingProduct
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
