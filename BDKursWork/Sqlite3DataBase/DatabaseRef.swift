//
//  DatabaseRef.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 29.11.2020.
//

import Foundation
import SQLite3

struct Person {
    var id: Int
    var firstName: String
    var secondName: String
    var mobileNumber: String
    var email: String
    var login: String
    var password: String
    var role_id: Int
    var role_name: String
}

struct Role {
    var id: Int
    var roleName: String
}

class DatabaseRef {
    
    let dbPath: String = "refusion.sqlite"
    var db:OpaquePointer?
    
    
    //MARK:-Statements String
    let createRole = """
    CREATE TABLE IF NOT EXISTS Roles(
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ROLE_NAME VARCHAR(200)
    );
    """
    
    let createWorker = """
    CREATE TABLE IF NOT EXISTS Worker(
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        FIRST_NAME VARCHAR(50) NOT NULL,
        SECOND_NAME VARCHAR(50) NOT NULL,
        MOBILE_NUMBER VARCHAR(50),
        EMAIL VARCHAR(50),
        LOGIN VARCHAR(50),
        PASSWORD VARCHAR(50),
        ROLE_ID INTEGER,
        WorkStatus VARCHAR(50),
        FOREIGN KEY(ROLE_ID) REFERENCES Roles(ID)
    );
    """
    
    
    
    let createProducts = """
    CREATE TABLE IF NOT EXISTS Products(
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        TITLE VARCHAR(50) NOT NULL,
        DATE_BOUGHT DATE NOT NULL,
        COUNT INTEGER,
        SELLER_PRICE REAL,
        BOUGHT_PRICE REAL,
        ID_BOUGHT_WORKER INT,
        FOREIGN KEY(ID_BOUGHT_WORKER) REFERENCES Worker(ID)
    );
    """
    
    //id - 0 date - 1 id_seller - 2
    
    let createFullCheck = """
    CREATE TABLE IF NOT EXISTS FullCheck(
            ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            DATE_SELL DATE NOT NULL,
            ID_SELL_WORKER INT,
            FOREIGN KEY(ID_SELL_WORKER) REFERENCES Worker(ID)
    );
    """
    
    
    let createCheckUnit = """
    CREATE TABLE IF NOT EXISTS CheckUnit(
            ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            PRODUCT_ID INT NOT NULL,
            ID_FULL_CHECK INT NOT NULL,
            COUNT INT,
            FOREIGN KEY(PRODUCT_ID) REFERENCES Worker(ID),
            FOREIGN KEY(ID_FULL_CHECK) REFERENCES FullCheck(ID)
    );
    """
    
    let selectAllWorkerWithRole = """
            SELECT * from Worker
                JOIN Roles R ON Worker.ROLE_ID = R.ID;
    """
    
    let insertNewRole = """
    INSERT INTO Roles (ROLE_NAME) VALUES (?);
    """
    
    let insertNewWorker = """
    INSERT INTO Worker (FIRST_NAME, SECOND_NAME, MOBILE_NUMBER, EMAIL, LOGIN, PASSWORD, ROLE_ID, WorkStatus) VALUES(?, ?, ?, ?, ?, ?, ?, ?)
    """
    
    //MARK:-Set Up all datebase
    init() {
        db = openDatabase()
        
        dropCheckUnit()
        dropFullCheck()
        dropProducts()
        dropWorkersTable()
        dropRolesTable()
        
        createRolesTable()
        createWorkerTable()
        createProductsFunc()
        createFullCheckFunc()
        createCheckUnitFunc()
        
        insertRoles(name: "admin")
        insertRoles(name: "seller")
        insertRoles(name: "purchasing agent")
        
        insertWorker(firstName: "Nikita", secondName: "Frolov", phoneNumber: "777", email: "frolov", login: "admin", password: "322", role_id: 1)
        insertWorker(firstName: "Alena", secondName: "Komarova", phoneNumber: "777", email: "alena", login: "agent", password: "322", role_id: 2)
        insertWorker(firstName: "Artyom", secondName: "Artyhov", phoneNumber: "777", email: "artyom", login: "seller", password: "322", role_id: 3)
        
        insertProduct(product: Products(id: 0, title: "95-petrol", count: 10, sellPrice: 50.5, boughtPrice: 50.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "92-petrol", count: 10, sellPrice: 40.5, boughtPrice: 40.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "90-petrol", count: 10, sellPrice: 35.5, boughtPrice: 35.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "lotus", count: 10, sellPrice: 35.5, boughtPrice: 35.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "layes", count: 10, sellPrice: 35.5, boughtPrice: 35.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "Pohui mne", count: 0, sellPrice: 35.5, boughtPrice: 35.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        insertProduct(product: Products(id: 0, title: "I am zaebalsa", count: 0, sellPrice: 35.5, boughtPrice: 35.0, id_worker: 2, day_of_bought: "20.11.2020", workerName: ""))
        
        insertFullCheck(fullCheck: FullCheck(id: -1, date: "20.12.2020", id_seller: 3))
        insertFullCheck(fullCheck: FullCheck(id: -1, date: "20.12.2020", id_seller: 3))
        
        insertCheckUnit(checkUnit: CheckUnit(id: -1, id_product: 1, id_fullCheck: 1, count: 5))
        insertCheckUnit(checkUnit: CheckUnit(id: -1, id_product: 2, id_fullCheck: 2, count: 4))
        
        print(selectAllFromProducts())
        print(selectAllFullCheck())
        print(selectAllCheckUnit())
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
    
    //MARK:-Drop database
    private func dropRolesTable() {
        var dropTableStatement: OpaquePointer? = nil
        let dropStatementString = "DROP TABLE IF EXISTS Roles"
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                print("Roles table droped.")
            } else {
                print("Roles table could not be droped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(dropTableStatement)
    }
    
    private func dropWorkersTable() {
        var dropTableStatement: OpaquePointer? = nil
        let dropStatementString = "DROP TABLE IF EXISTS Worker"
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                print("Worker table droped.")
            } else {
                print("Worker table could not be droped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(dropTableStatement)
    }
    
    private func dropProducts() {
        var dropTableStatement: OpaquePointer? = nil
        let dropStatementString = "DROP TABLE IF EXISTS Products"
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                print("Worker table droped.")
            } else {
                print("Worker table could not be droped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(dropTableStatement)
    }
    
    private func dropFullCheck() {
        var dropTableStatement: OpaquePointer? = nil
        let dropStatementString = "DROP TABLE IF EXISTS FullCheck"
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                print("Worker table droped.")
            } else {
                print("Worker table could not be droped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(dropTableStatement)
    }
    
    private func dropCheckUnit() {
        var dropTableStatement: OpaquePointer? = nil
        let dropStatementString = "DROP TABLE IF EXISTS CheckUnit"
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                print("Worker table droped.")
            } else {
                print("Worker table could not be droped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(dropTableStatement)
    }
    
    //MARK:-Creating all tables
    private func createRolesTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createRole, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Roles table created.")
            } else {
                print("Roles table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func createWorkerTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createWorker, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Workers table created.")
            } else {
                print("Workers table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func createProductsFunc() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createProducts, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Products table created.")
            } else {
                print("Products table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func createFullCheckFunc() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createFullCheck, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("FullCheck table created.")
            } else {
                print("FullCheck table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func createCheckUnitFunc() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createCheckUnit, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("CheckUnit table created.")
            } else {
                print("CheckUnit table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //MARK:-Insert function
    func insertRoles(name: String) {
        var insertStatement: OpaquePointer? = nil
        let persons = selectAllFromRoles()
        for p in persons {
            if p.roleName == name {
                return
            }
        }
        if sqlite3_prepare_v2(db, insertNewRole, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
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
    
    let insertNewProduct = """
    INSERT INTO Products (TITLE, DATE_BOUGHT, COUNT, SELLER_PRICE, BOUGHT_PRICE, ID_BOUGHT_WORKER) VALUES(?, ?, ?, ?, ?, ?)
    """
    
    func insertProduct(product: Products) {
        let products = selectAllFromProducts()
        for p in products {
            if p.title == product.title && p.sellPrice == product.sellPrice {
                return
            }
        }
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertNewProduct, -1, &insertStatement, nil) == SQLITE_OK {

            sqlite3_bind_text(insertStatement, 1, (product.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (product.day_of_bought as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(product.count))
            sqlite3_bind_double(insertStatement, 4, product.sellPrice)
            sqlite3_bind_double(insertStatement, 5, product.boughtPrice)
            sqlite3_bind_int(insertStatement, 6, Int32(product.id_worker))
            
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
    
    
    let insertNewFullCheck = """
    INSERT INTO FullCheck (DATE_SELL, ID_SELL_WORKER) VALUES(?, ?)
    """
    
    func insertFullCheck(fullCheck: FullCheck) {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertNewFullCheck, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (fullCheck.date as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(fullCheck.id_seller))
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
    
    
    let insertNewCheckUnit = """
    INSERT INTO CheckUnit (PRODUCT_ID, ID_FULL_CHECK, COUNT) VALUES(?, ?, ?)
    """
    
    func insertCheckUnit(checkUnit: CheckUnit) {
        let checkUnits = selectAllCheckUnit()
        for c in checkUnits {
            if c.id_product == checkUnit.id_product && c.id_fullCheck == checkUnit.id_fullCheck {
                return
            }
        }
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertNewCheckUnit, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(checkUnit.id_product))
            sqlite3_bind_int(insertStatement, 2, Int32(checkUnit.id_fullCheck))
            sqlite3_bind_int(insertStatement, 3, Int32(checkUnit.count))
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
    
    //MARK:-Select function
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
                psns.append(Person(id: Int(id), firstName: firstName, secondName: secondName, mobileNumber: phoneNumber, email: email, login: login, password: password, role_id: Int(roleId), role_name: roleName))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func selectAllFromRoles()->[Role] {
        let queryStatementString = "SELECT * FROM Roles;"
        var queryStatement: OpaquePointer? = nil
        var role: [Role] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let roleName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                role.append(Role(id: Int(id), roleName: roleName))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return role
    }
    
    
    let selectAllProducts = """
        SELECT * FROM Products
            JOIN Worker ON Worker.id = Products.ID_BOUGHT_WORKER;
    """
    
    func selectAllFromProducts()->[Products] {
        var queryStatement: OpaquePointer? = nil
        var products: [Products] = []
        if sqlite3_prepare_v2(db, selectAllProducts, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let count = Int(sqlite3_column_int(queryStatement, 3))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let sell_price = Double(sqlite3_column_double(queryStatement, 4))
                let boughtPrice = Double(sqlite3_column_double(queryStatement, 5))
                let id_worker = Int(sqlite3_column_int(queryStatement, 6))
                let workerName = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                products.append(Products(id: Int(id), title: title, count: count, sellPrice: sell_price, boughtPrice: boughtPrice, id_worker: id_worker, day_of_bought: date, workerName: workerName))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return products
    }
    
    //id - 0 date - 1 id_seller - 2
    
    let selectAllFullCheckString = """
        SELECT * FROM FullCheck;
    """
    
    func selectAllFullCheck()->[FullCheck] {
        var queryStatement: OpaquePointer? = nil
        var fullCheck: [FullCheck] = []
        if sqlite3_prepare_v2(db, selectAllFullCheckString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let id_worker = Int(sqlite3_column_int(queryStatement, 2))
                fullCheck.append(FullCheck(id: id, date: date, id_seller: id_worker))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return fullCheck
    }
    
    let selectAllCheckUnitString = """
        SELECT * FROM CheckUnit;
    """
    //id-0 pr_id - 1 fc-id - 2 count-3
    
    func selectAllCheckUnit()->[CheckUnit] {
        var queryStatement: OpaquePointer? = nil
        var checkUnit: [CheckUnit] = []
        if sqlite3_prepare_v2(db, selectAllCheckUnitString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let id_product = Int(sqlite3_column_int(queryStatement, 1))
                let id_full = Int(sqlite3_column_int(queryStatement, 2))
                let count = Int(sqlite3_column_int(queryStatement, 3))
                checkUnit.append(CheckUnit(id: id, id_product: id_product, id_fullCheck: id_full, count: count))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return checkUnit
    }
}
