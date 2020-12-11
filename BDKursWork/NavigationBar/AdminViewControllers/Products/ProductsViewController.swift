//
//  ProductsViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 08.12.2020.
//

import UIKit


class ProductsViewController: UITableViewController {
    
    let db = ProductsModelDB()
    
    var arrayProducts = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButton))
        arrayProducts.append(contentsOf: db.selectAllFromProducts())
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int {
        return arrayProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "\(arrayProducts[indexPath.row].title) \n price:\(arrayProducts[indexPath.row].sellPrice)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailAboutProductViewController()
        vc.product = arrayProducts[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
}

extension ProductsViewController {
    
    @objc func addAction(_ sender: UIButton) {
        let vc = AddingNewProductsViewControllers()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func exitButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ProductsViewController {
    func updateArray() {
        arrayProducts = [Products]()
        arrayProducts.append(contentsOf: db.selectAllFromProducts())
    }
}


extension ProductsViewController {
    override func viewWillAppear(_ animated: Bool) {
        updateArray()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
