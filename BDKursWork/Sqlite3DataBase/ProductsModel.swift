//
//  ProductsModel.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 08.12.2020.
//

import Foundation
import SQLite3

struct Products {
    var id: Int
    var title: String
    var count: Int
    var sellPrice: Double
    var boughtPrice: Double
    var id_worker: Int
    var day_of_bought: String
    var workerName: String
}


class ProductsModelDB {
    let dbPath: String = "refusion.sqlite"
    var db:OpaquePointer?
    
    
    
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
    
    let updateProductString = """
    UPDATE Products SET TITLE = ?, COUNT = ?, SELLER_PRICE = ?, BOUGHT_PRICE = ? WHERE ID = ?
    """
    
    func updateProduct(product: Products) {
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateProductString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (product.title as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(product.count))
            sqlite3_bind_double(updateStatement, 3, product.sellPrice)
            sqlite3_bind_double(updateStatement, 4, product.boughtPrice)
            sqlite3_bind_int(updateStatement, 5, Int32(product.id))
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
    
    let popularProduct = """
    select Products.ID, Products.TITLE, count(COU.PRODUCT_ID) from Products
        join CheckUnit COU on Products.ID = COU.PRODUCT_ID
        group by Products.ID
        order by count(COU.PRODUCT_ID) desc limit 3;
    """
    
    func selectPopularProducts()->[Products] {
        var queryStatement: OpaquePointer? = nil
        let allProducts = selectAllFromProducts()
        var products: [Int] = []
        if sqlite3_prepare_v2(db, popularProduct, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                products.append(Int(id))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        var array = [Products]()
        for index in products {
            for element in allProducts {
                if element.id == index {
                    array.append(element)
                    break
                }
            }
        }
        sqlite3_finalize(queryStatement)
        return array
    }
    
    
    let unpopularProduct = """
    select Products.ID, Products.TITLE, count(COU.PRODUCT_ID) from Products
        left join CheckUnit COU on Products.ID = COU.PRODUCT_ID
        group by Products.ID
        order by count(COU.PRODUCT_ID) limit 3;
    """
    
    
    func selectUnpopularProducts()->[Products] {
        var queryStatement: OpaquePointer? = nil
        let allProducts = selectAllFromProducts()
        var products: [Int] = []
        if sqlite3_prepare_v2(db, unpopularProduct, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                products.append(Int(id))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        var array = [Products]()
        for index in products {
            for element in allProducts {
                if element.id == index {
                    array.append(element)
                    break
                }
            }
        }
        
        sqlite3_finalize(queryStatement)
        return array
    }
    
    
    let selectProductsWithZeroCountStatmen = """
        select ID from Products
            where COUNT = 0;
    """
    
    func selectProductsWithZeroCount()->[Products] {
        var queryStatement: OpaquePointer? = nil
        let allProducts = selectAllFromProducts()
        var products: [Int] = []
        if sqlite3_prepare_v2(db, selectProductsWithZeroCountStatmen, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                products.append(Int(id))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        var array = [Products]()
        for index in products {
            for element in allProducts {
                if element.id == index {
                    array.append(element)
                    break
                }
            }
        }
        
        sqlite3_finalize(queryStatement)
        return array
    }
    
    let updateCountStatment = """
            UPDATE Products SET COUNT = ? WHERE ID = ?
    """
    
    func updateCountProduct(product: Products) {
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateProductString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(product.count))
            sqlite3_bind_int(updateStatement, 2, Int32(product.id))
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
