//
//  ProductTableView+CustomTableViewCell.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 10.12.2020.
//

import UIKit

class ProductTableViewAddingProducts: UITableViewController {
    
    var array = [(product: Products, isChange: Bool)]()
    let db = ProductsModelDB()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ProductsTableViewCell.self, forCellReuseIdentifier: "contactCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        array = db.selectProductsWithZeroCount().map{($0, false)}
    }
}

//MARK:-Save selector
extension ProductTableViewAddingProducts {
    
    @objc func saveAction(_ sender: UIButton) {
        for elem in array {
            if elem.isChange {
                db.updateProduct(product: elem.product)
            }
        }
        array = db.selectProductsWithZeroCount().map{($0, false)}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:-Table functions
extension ProductTableViewAddingProducts {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ProductsTableViewCell
        cell.product = array[indexPath.row].product
        cell.minusButton.tag = indexPath.row
        cell.plusButton.tag = indexPath.row
        
        cell.minusButton.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        cell.plusButton.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(array[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK:-SwiftUI
import SwiftUI

struct PTVCVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let addingPersonVC = ProductTableViewAddingProducts()
        
        func makeUIViewController(context: Context) -> ProductTableViewAddingProducts {
            return addingPersonVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

//MARK:-Actions for Button
extension ProductTableViewAddingProducts {
    @objc func minusButtonAction(_ sender: UIButton){
        if array[sender.tag].product.count == 0 {
            return
        }
        array[sender.tag].product.count -= 1
        array[sender.tag].isChange = true
        let index = IndexPath(row: sender.tag, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [index], with: .none)
        }
    }
    
    @objc func plusButtonAction(_ sender: UIButton){
        array[sender.tag].product.count += 1
        array[sender.tag].isChange = true
        let index = IndexPath(row: sender.tag, section: 0)
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [index], with: .none)
        }
    }
}
