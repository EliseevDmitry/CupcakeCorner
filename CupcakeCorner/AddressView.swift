//
//  AddresaView.swift
//  CupcakeCorner
//
//  Created by Dmitriy Eliseev on 23.06.2024.
//

import SwiftUI

struct AddressView: View {
   @Bindable var order: Order
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.name)
                TextField("StreetAddress", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            .onAppear{
                order.loadData()
            }
            Section{
                NavigationLink("Check out"){
                    CheckoutView(order: order)
                }
                .disabled(order.hasValidAddress == false || order.emptyFields == false)
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
