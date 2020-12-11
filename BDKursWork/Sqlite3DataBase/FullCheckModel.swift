//
//  FullCheckModel.swift
//  BDKursWork
//
//  Created by Никита Фролов  on 08.12.2020.
//

import Foundation


struct FullCheck {
    var id: Int
    var date: String
    var id_seller: Int
}

struct CheckUnit {
    var id: Int
    var id_product: Int
    var id_fullCheck: Int
    var count: Int
}
