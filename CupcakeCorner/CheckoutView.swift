//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Dmitriy Eliseev on 23.06.2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3){image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233 )
                Text("You total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place Order", action: {})
                    .padding()
            }
           
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        //позволяет не прогручиваться если не хватае контента до конца
        .scrollBounceBehavior(.basedOnSize)
    }
       
}

#Preview {
    CheckoutView(order: Order())
}
