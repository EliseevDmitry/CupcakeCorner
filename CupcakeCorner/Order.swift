//
//  Order.swift
//  CupcakeCorner
//
//  Created by Dmitriy Eliseev on 23.06.2024.
//

import Foundation

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        //2$ per cake
        var cost = Decimal(quantity) * 2
        
        //complicated cakes cost more
        cost += Decimal(type) / 2
        
        //1$ cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        //0,5$/cake per Sprinkles
        if addSprinkles{
            cost += Decimal(quantity) / 2
        }
        return cost
    }
}