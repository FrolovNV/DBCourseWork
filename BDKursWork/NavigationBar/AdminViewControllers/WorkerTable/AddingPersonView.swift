//
//  AddingPersonView.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 30.11.2020.
//

import UIKit


class AddingPersonView: UIViewController {
    //MARK:-Mode to change
    var changingMode = false
    var person: Person?
    
    //MARK:-Create UISegmentControl
    let items = ["Admin", "Seller", "Agent"]
    var segment: UISegmentedControl?
    
    
    //MARK:-Creating Text Field
    var firstName = UITextField()
    var secondName = UITextField()
    var mobileNumber = UITextField()
    var email = UITextField()
    var login = UITextField()
    var password = UITextField()
    
    //MARK:-Creating Label
    var firstNameLabel = UILabel(text: "First Name:")
    var secondNameLabel = UILabel(text: "Second Name:")
    var mobileNumberLabel = UILabel(text: "Mobile Number:")
    var emailLabel = UILabel(text: "Email:")
    var loginLabel = UILabel(text: "Login:")
    var passwordLabel = UILabel(text: "Password:")
    
    //MARK:-Creating UIBarButtonItem
    var addingButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPersone))
    
    //MARK:- DB handler
    
    var db = AddingInWorker()
    
    //MARK:-View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationItem.title = "New Worker"
        
        segment = UISegmentedControl(items: items)
        segment?.selectedSegmentIndex = 0
        
        
        self.navigationItem.rightBarButtonItem = addingButton
        addingButton.target = self
        addingButton.action = #selector(addPersone)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        firstName.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        secondName.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        mobileNumber.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        email.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        login.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        password.addTarget(self, action: #selector(fieldChange), for: .allEditingEvents)
        
        if person != nil {
            setUpPersonInformation()
            self.navigationItem.title = "Change Info"
        }
        
        self.view.backgroundColor = .white
        setUpContstraints()
    }
    
    @objc func addPersone(_ sender: UIButton) {
        creatingPeople()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpPersonInformation() {
        firstName.text = person!.firstName
        secondName.text = person!.secondName
        mobileNumber.text = person!.mobileNumber
        email.text = person!.email
        login.text = person!.login
        password.text = person!.password
        segment?.selectedSegmentIndex = person!.role_id - 1
        changingMode = true
    }
    
}

//MARK:- Adding Action
extension AddingPersonView {
    func checkAllField()->Bool {
        let array = [firstName, secondName, mobileNumber, email, login, password]
        for element in array {
            if element.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    func creatingPeople() {
        let firstNameP = firstName.text
        let secondNamep = secondName.text
        let mobileNumberP = mobileNumber.text
        let emailP = email.text
        let loginP = login.text
        let passwordP = password.text
        
        let role:Int32 = Int32(segment?.selectedSegmentIndex ?? 0) + 1
        
        
        if checkAllField() {
            if changingMode {
                guard let id_worker = person?.id else {
                    return
                }
                db.updateWorker(firstName: firstNameP!, secondName: secondNamep!, phoneNumber: mobileNumberP!, email: emailP!, login: loginP!, password: passwordP!, role_id: role, id_worker: Int32(id_worker))
                return
            }
            db.insertWorker(firstName: firstNameP!, secondName: secondNamep!, phoneNumber: mobileNumberP!, email: emailP!, login: loginP!, password: passwordP!, role_id: role)
        }
    }
    
    @objc func fieldChange() {
        if checkAllField() {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

//MARK:-Set Up Constraints
extension AddingPersonView {
    func setUpContstraints() {
        segment?.translatesAutoresizingMaskIntoConstraints = false
        
        segment?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segment?.widthAnchor.constraint(equalToConstant: 600).isActive = true
        
        let attr = NSDictionary(object: UIFont.avenir20()!, forKey: NSAttributedString.Key.font as NSCopying)
        segment?.setTitleTextAttributes(attr as? [NSAttributedString.Key : Any] , for: .normal)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondNameLabel.translatesAutoresizingMaskIntoConstraints = false
        mobileNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        firstName.translatesAutoresizingMaskIntoConstraints = false
        secondName.translatesAutoresizingMaskIntoConstraints = false
        mobileNumber.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        
        firstName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        firstName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        firstNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        secondName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        secondName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        secondNameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        mobileNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mobileNumberLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mobileNumber.widthAnchor.constraint(equalToConstant: 200).isActive = true
        mobileNumberLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        email.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        email.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        login.heightAnchor.constraint(equalToConstant: 25).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        login.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        password.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        password.widthAnchor.constraint(equalToConstant: 200).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        login.placeholder = "insert login..."
        password.placeholder = "insert password..."
        firstName.placeholder = "insert first name..."
        secondName.placeholder = "insert second name..."
        email.placeholder = "insert email..."
        mobileNumber.placeholder = "insert mobile number..."
        
        let firstNameStack = UIStackView(arrangedSubviews: [firstNameLabel, firstName], axis: .horizontal, spacing: 10)
        let secondNameStack = UIStackView(arrangedSubviews: [secondNameLabel, secondName], axis: .horizontal, spacing: 10)
        let mobileNumberStack = UIStackView(arrangedSubviews: [mobileNumberLabel, mobileNumber], axis: .horizontal, spacing: 10)
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, email], axis: .horizontal, spacing: 10)
        let loginStack = UIStackView(arrangedSubviews: [loginLabel, login], axis: .horizontal, spacing: 10)
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, password], axis: .horizontal, spacing: 10)
        
        let labelAFieldStack = UIStackView(arrangedSubviews: [firstNameStack, secondNameStack, mobileNumberStack, emailStack, loginStack, passwordStack], axis: .vertical, spacing: 20)
        
        
        let buttonStack = UIStackView(arrangedSubviews: [segment!], axis: .horizontal, spacing: 0)
        
        
        
        
        
        labelAFieldStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        view.addSubview(labelAFieldStack)
        labelAFieldStack.widthAnchor.constraint(equalTo: buttonStack.widthAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelAFieldStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 100).isActive = true
        labelAFieldStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

//MARK:-SwiftUI
import SwiftUI

struct AddingPersonVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let addingPersonVC = AddingPersonView()
        
        func makeUIViewController(context: Context) -> AddingPersonView {
            return addingPersonVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
