//
//  ProductsTableViewCell.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 10.12.2020.
//

import UIKit


class ProductsTableViewCell: UITableViewCell {
    
    var product:Products? {
        didSet {
            guard let productItem = product else {return}
            nameLabel.text = productItem.title
            sellingCostLabel.text = "\(productItem.sellPrice)"
            countLabel.text = "\(productItem.count)"
        }
    }
    
    var index: Int?
    
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.avenir20()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sellingCostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.avenir14()
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8-plus-24"), for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons8-minus-24"), for: .normal)
        button.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        return button
    }()
    
    let countLabel: UITextField = {
        let label = UITextField()
        label.font = UIFont.avenir20()
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        minusButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
         
        let stackButton = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton], axis: .horizontal, spacing: 0)
        
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackButton)
        
        stackButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        stackButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        let stackLabel = UIStackView(arrangedSubviews: [nameLabel, sellingCostLabel], axis: .vertical, spacing: 5)
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackLabel)
        
        stackLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        stackLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
