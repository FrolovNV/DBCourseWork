//
//  AddingInWorker.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 07.12.2020.
//

import Foundation
import SQLite3

class AddingInWorker {
    let dbPath: String = "refusion.sqlite"
    var db:OpaquePointer?
    
    let insertNewWorker = """
    INSERT INTO Worker (FIRST_NAME, SECOND_NAME, MOBILE_NUMBER, EMAIL, LOGIN, PASSWORD, ROLE_ID, WorkStatus) VALUES(?, ?, ?, ?, ?, ?, ?, ?)
    """
    
    let selectAllWorkerWithRole = """
            SELECT * from Worker
                JOIN Roles R ON Worker.ROLE_ID = R.ID;
    """
    
    let updateInformation = """
    UPDATE Worker SET FIRST_NAME = ?, SECOND_NAME = ?, MOBILE_NUMBER = ?, EMAIL = ?, LOGIN = ?, PASSWORD = ?, ROLE_ID = ? WHERE ID = ?
    """
    
    init() {
        db = openDatabase()
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func insertWorker(firstName: String, secondName: String, phoneNumber: String, email: String, login: String, password: String, role_id: Int32) {
        let persons = selectAllFromWorker()
        for p in persons {
            if p.login == login {
                return
            }
        }
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertNewWorker, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_text(insertStatement, 1, (firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (secondName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (phoneNumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (login as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, role_id)
            sqlite3_bind_text(insertStatement, 8, ("TRUE" as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func selectAllFromWorker()-> [Person] {
        let queryStatementString = selectAllWorkerWithRole
        var queryStatement: OpaquePointer? = nil
        var psns: [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let secondName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let phoneNumber = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let login = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let roleId = sqlite3_column_int(queryStatement, 7)
                let roleName = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                psns.append(Person(id: Int(id), firstName: firstName, secondName: secondName, mobileNumber: phoneNumber, email: email, login: login, password: password, role_id: Int(roleId), role_name: roleName))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func updateWorker(firstName: String, secondName: String, phoneNumber: String, email: String, login: String, password: String, role_id: Int32, id_worker: Int32) {
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateInformation, -1, &updateStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateStatement, 1, (firstName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (secondName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (phoneNumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (login as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 6, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 7, role_id)
            sqlite3_bind_int(updateStatement, 8, id_worker)
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    let updateStatusString = """
    UPDATE Worker SET WorkStatus = ? WHERE ID = ?
    """
    
    func updateStatusOfWorker(id: Int32, stringStatus: String) {
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatusString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 2, id)
            sqlite3_bind_text(updateStatement, 1, (stringStatus as NSString).utf8String, -1, nil)
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}
