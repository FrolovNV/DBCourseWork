//
//  ProductsViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 09.12.2020.
//

import UIKit


class ProductsAgentViewController: UITableViewController {
    let items = ["All", "Popular", "Unpopular"]
    var segment: UISegmentedControl?
    
    let db = ProductsModelDB()
    var arrayOfProduct = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButtonAction))
        super.navigationItem.title = "All Products"
        self.view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        arrayOfProduct = db.selectAllFromProducts()
        setUpSegmentView()
    }
}

//MARK:- All table view functions
extension ProductsAgentViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int {
        return arrayOfProduct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "\(arrayOfProduct[indexPath.row].title) \n price:\(arrayOfProduct[indexPath.row].sellPrice)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailAboutProductViewController()
        vc.product = arrayOfProduct[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
}

//MARK:-Set up SegmentViewController
extension ProductsAgentViewController {
    func setUpSegmentView() {
        segment = UISegmentedControl(items: items)
        segment?.selectedSegmentIndex = 0
        segment?.addTarget(self, action: #selector(changeSegmentViewController), for: .valueChanged)
        self.tableView.tableHeaderView = segment
    }
    
    @objc func changeSegmentViewController(_ sender: UISegmentedControl) {
        let index = segment?.selectedSegmentIndex
        if index == 0 {
            arrayOfProduct = db.selectAllFromProducts()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if index == 1 {
            arrayOfProduct = db.selectPopularProducts()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if index == 2 {
            arrayOfProduct = db.selectUnpopularProducts()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK:-Actions for bar button
extension ProductsAgentViewController {
    
    @objc func exitButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK:-SwiftUI
import SwiftUI

struct PAGVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let addingPersonVC = ProductsAgentViewController()
        
        func makeUIViewController(context: Context) -> ProductsAgentViewController {
            return addingPersonVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
