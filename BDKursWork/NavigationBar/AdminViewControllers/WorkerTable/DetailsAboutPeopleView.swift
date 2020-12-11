//
//  DetailsaboutPeopleView.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 26.11.2020.
//

import UIKit


class DetailsAboutPeopleView: UIViewController {
    var people: Person?
    
    var changeMode = false
    
    var firstName = UILabel(text: "First Name", font: UIFont(name: "avenir", size: 20)!)
    var secondName = UILabel(text: "Second Name")
    var mobileNumber =  UILabel(text: "Mobile Number", font: UIFont(name: "avenir", size: 20)!)
    var emailPre = UILabel(text: "EMAIL", font: UIFont(name: "avenir", size: 20)!)
    var rolePre = UILabel(text: "Role", font: UIFont(name: "avenir", size: 20)!)
    
    var firstNameField = UITextField(font: .avenir20(), colorText: .black)
    var secondNameField = UITextField(font: .avenir20(), colorText: .black)
    var numberField =  UITextField(font: .avenir20(), colorText: .black)
    var emailField = UITextField(font: .avenir20(), colorText: .black)
    var roleField = UITextField(font: .avenir20(), colorText: .black)
    
    
    var buttonChange = UIButton(title: "Sign Up", titleColor: .green, font: .avenir20(), backgroundColor: .black, isSwadow: true, cornedRadius: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameField.isUserInteractionEnabled = false
        secondNameField.isUserInteractionEnabled = false
        numberField.isUserInteractionEnabled = false
        emailField.isUserInteractionEnabled = false
        roleField.isUserInteractionEnabled = false
        
        self.navigationItem.title = "\(people!.secondName)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeAction))
        
        firstNameField.text = people?.firstName
        secondNameField.text = people?.secondName
        numberField.text = people?.mobileNumber
        emailField.text = people?.email
        if people?.role_id == 1 {
            roleField.text = "Admin"
        } else if people?.role_id == 2 {
            roleField.text = "Purchasing agent"
        } else if people?.role_id == 3 {
            roleField.text = "Seller"
        }
        setUpContstrains()
    }
    
    @objc func changeAction(_ sender: UIButton) {
        let vc = AddingPersonView()
        vc.person = people
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func saveSettings() {
        if !firstNameField.text!.isEmpty {
            people?.firstName = firstNameField.text!
        }
        if !secondNameField.text!.isEmpty {
            people?.secondName = secondNameField.text!
        }
        if !numberField.text!.isEmpty {
            people?.mobileNumber = numberField.text!
        }
        if !emailField.text!.isEmpty {
            people?.email = emailField.text!
        }
        if !roleField.text!.isEmpty {
        }
    }
}

extension DetailsAboutPeopleView {
    func setUpContstrains() {
        let nameStack = UIStackView(arrangedSubviews: [firstName, firstNameField], axis: .vertical, spacing: 10)
        let secondNameStack = UIStackView(arrangedSubviews: [secondName, secondNameField], axis: .vertical, spacing: 10)
        let numberStack = UIStackView(arrangedSubviews: [mobileNumber, numberField], axis: .vertical, spacing: 10)
        let emailStack = UIStackView(arrangedSubviews: [emailPre, emailField], axis: .vertical, spacing: 10)
        let roleStack = UIStackView(arrangedSubviews: [rolePre, roleField], axis: .vertical, spacing: 10)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "Image-1"))
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [nameStack, secondNameStack, numberStack, roleStack, emailStack], axis: .vertical, spacing: 20)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        view.addSubview(stackView)
        
        
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 60).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
    }
}


//MARK:- SwiftUI
import SwiftUI

struct DetailsVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let detailsVC = DetailsAboutPeopleView()
        
        func makeUIViewController(context: Context) -> DetailsAboutPeopleView {
            return detailsVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

