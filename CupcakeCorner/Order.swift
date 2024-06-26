//
//  Order.swift
//  CupcakeCorner
//
//  Created by Dmitriy Eliseev on 23.06.2024.
//

import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }

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
    
    var emptyFields: Bool {
        if checkString(text: name) && checkString(text: streetAddress) && checkString(text: city) && checkString(text: zip) {
            return true
        }
        return false 
    }
    
   private func checkString(text: String) -> Bool {
        for chr in text {
            if chr != " " {
                return true
            }
        }
        return false
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
    
    func saveData(){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            UserDefaults.standard.set(data, forKey: "address")
        }
    }
    
    func loadData(){
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "address") else { return }
        guard let loadData = try? decoder.decode(Order.self, from: data) else {return}
        name = loadData.name
        streetAddress = loadData.streetAddress
        city = loadData.city
        zip = loadData.zip
    }
}
