//
//  AuthViewController.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 13.11.2020.
//

import UIKit

class AuthViewController: UIViewController {
    
    let image = UIImageView(image: #imageLiteral(resourceName: "Image-1"), contentMode: .scaleAspectFit)
    let loginLable = UILabel(text: "Login")
    let passwordLable = UILabel(text: "Password")
    let oneLineLogin = OneLineTextField()
    let oneLinePassword = OneLineTextField()
    
    
    var loginString = String()
    var passwordString = String()
    
    var arrayOfPeople = [Person]()
    let db = DatabaseRef()
    
    let signInButton = UIButton(title: "Sign Up", titleColor: .green, font: .avenir20(), backgroundColor: .black, isSwadow: true, cornedRadius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let res = db.selectAllFromWorker()
        
        arrayOfPeople.append(contentsOf: res.filter{$0.role_name != "FALSE"})
        
        view.backgroundColor = .white
        oneLineLogin.autocapitalizationType = .none
        oneLineLogin.addTarget(self, action: #selector(self.getLogin(_:)), for: .editingChanged)
        
        oneLinePassword.addTarget(self, action: #selector(self.getPassword(_:)), for: .editingChanged)
        
        signInButton.addTarget(self, action: #selector(self.signUpAction(_:)), for: .touchDown)
        setUpConstaints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let res = db.selectAllFromWorker()
        arrayOfPeople = [Person]()
        arrayOfPeople.append(contentsOf: res.filter{$0.role_name != "FALSE"})
        oneLineLogin.text = ""
        oneLinePassword.text = ""
    }
    
    @objc func getLogin(_ textField: UITextField) {
        loginString = textField.text!
    }
    
    @objc func getPassword(_ textField: UITextField) {
        passwordString = textField.text!
    }
    
    @objc func signUpAction(_ textField: UITextField) {
        for people in arrayOfPeople {
            if loginString == people.login && passwordString == people.password {
                if people.role_id == 1 {
                    let admin = AdminViewController()
                    admin.modalPresentationStyle = .fullScreen
                    self.present(admin, animated: true, completion: nil)
                    break
                } else if people.role_id == 2 {
                    let agent = PeacherViewController()
                    agent.modalPresentationStyle = .fullScreen
                    self.present(agent, animated: true, completion: nil)
                } else if people.role_id == 3 {
                    let seller = SellerViewController()
                    seller.modalPresentationStyle = .fullScreen
                    self.present(seller, animated: true, completion: nil)
                }
            }
        }
    }
}


//MARK:-Set Up Constraints
extension AuthViewController {
    private func setUpConstaints() {
        oneLineLogin.placeholder = "Insert you login"
        oneLinePassword.placeholder = "Insert you password"
        let loginView = UIStackView(arrangedSubviews: [loginLable, oneLineLogin], axis: .vertical, spacing: 10)
        let passwordView = UIStackView(arrangedSubviews: [passwordLable, oneLinePassword], axis: .vertical, spacing: 10)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            loginView,
            passwordView,
            signInButton
        ],
            axis: .vertical,
            spacing: 60)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(image)
        view.addSubview(stackView)
        //view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}


//MARK:-SwiftUI
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let authController = AuthViewController()
        
        func makeUIViewController(context: Context) -> AuthViewController {
            return authController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
