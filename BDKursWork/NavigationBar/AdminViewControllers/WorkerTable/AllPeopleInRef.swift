//
//  AllPeopleInRef.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 26.11.2020.
//

import UIKit

enum SectionName {
    static let admin = "Admin"
    static let purchasing = "Purchasing agent"
    static let seller = "Seller"
    static let fired = "Fired"
}

class AllPeopleInRef: UITableViewController {
    
    let db = AddingInWorker()
    
    var admins = [Person]()
    var sellers = [Person]()
    var agents = [Person]()
    var fired = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateArrays()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitButton))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateArrays()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func addAction(_ sender: UIButton) {
        let vc = AddingPersonView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int {
        if section == 0 {
            return admins.count
        } else if section == 1 {
            return agents.count
        } else if section == 2 {
            return sellers.count
        } else if section == 3 {
            return fired.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        if indexPath.section == 0 {
            let person = admins[indexPath.row]
            cell.textLabel?.text = "\(person.firstName) \(person.secondName)\n\(person.login)"
        } else if indexPath.section == 1 {
            let person = agents[indexPath.row]
            cell.textLabel?.text = "\(person.firstName) \(person.secondName)\n\(person.login)"
        } else if indexPath.section == 2 {
            let person = sellers[indexPath.row]
            cell.textLabel?.text = "\(person.firstName) \(person.secondName)\n\(person.login)"
        } else if indexPath.section == 3 {
            let person = fired[indexPath.row]
            cell.textLabel?.text = "\(person.firstName) \(person.secondName)\n\(person.login)"
        }
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && admins.count > 0 {
            return SectionName.admin
        } else if section == 1 && agents.count > 0 {
            return SectionName.purchasing
        } else if section == 2 && sellers.count > 0 {
            return SectionName.seller
        } else if section == 3 && fired.count > 0 {
            return SectionName.fired
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && admins.count > 0 {
            return 60
        } else if section == 1 && agents.count > 0 {
            return 60
        } else if section == 2 && sellers.count > 0 {
            return 60
        } else if section == 3 && fired.count > 0 {
            return 60
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsAboutPeopleView()
        if indexPath.section == 0 {
            vc.people = admins[indexPath.row]
        } else if indexPath.section == 1 {
            vc.people = agents[indexPath.row]
        } else if indexPath.section == 2 {
            vc.people = sellers[indexPath.row]
        } else if indexPath.section == 3 {
            vc.people = fired[indexPath.row]
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            changeWorkStatus(indexPath: indexPath)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("Delete this row \(indexPath)")
        }
    }
}


extension AllPeopleInRef {
    func changeWorkStatus(indexPath: IndexPath) {
        if (indexPath.section == 0) {
            db.updateStatusOfWorker(id: Int32(admins[indexPath.row].id), stringStatus: "FALSE")
        } else if (indexPath.section == 1) {
            db.updateStatusOfWorker(id: Int32(agents[indexPath.row].id), stringStatus: "FALSE")
        } else if (indexPath.section == 2) {
            db.updateStatusOfWorker(id: Int32(sellers[indexPath.row].id), stringStatus: "FALSE")
        } else if (indexPath.section == 3) {
            db.updateStatusOfWorker(id: Int32(fired[indexPath.row].id), stringStatus: "TRUE")
        }
        updateArrays()
    }
    
    func updateArrays() {
        let result = db.selectAllFromWorker()
        admins = [Person]()
        sellers = [Person]()
        agents = [Person]()
        fired = [Person]()
        
        admins.append(contentsOf: result.filter{$0.role_id == 1 && $0.role_name != "FALSE"})
        agents.append(contentsOf: result.filter{$0.role_id == 2 && $0.role_name != "FALSE"})
        sellers.append(contentsOf: result.filter{$0.role_id == 3 && $0.role_name != "FALSE"})
        fired.append(contentsOf: result.filter{$0.role_name == "FALSE"})
    }
    
    @objc func exitButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
}
