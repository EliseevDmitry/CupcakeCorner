//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Dmitriy Eliseev on 23.06.2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    //проверка запроса на сервер
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var errorLoadData = false
    
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
                //модификатор onAppear не работает с асинхронными функциями
                Button("Place Order"){
                    //для async функции - используем модификатор задачи Task!
                    Task{
                        if await !placeOrder(){
                            errorLoadData.toggle()
                        }
                    }
                }
                .padding()
                .alert("Thanks you!", isPresented: $showingConfirmation){
                    Button("Ok"){}
                } message: {
                    Text(confirmationMessage )
                }
            }
        }
        .onAppear{
            order.saveData()
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        //позволяет не прогручиваться если не хватае контента до конца
        .scrollBounceBehavior(.basedOnSize)
        .alert("Error", isPresented: $errorLoadData){
            Button("Ok"){
                errorLoadData = false
            }
        } message: {
            Text("Load or UpLoad data in server - failed!")
        }
    }
    //функция загрузки данных в фоне на сервер
    //загрузка данных на сервер - асинхронна
    func placeOrder() async -> Bool {
        //функция отправки запроса на сервер
        //для преобразования в обьект JSONE - требуется соответствие протоколу Codable - обьекта "order"
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return false
        }
        //создаем запрос отправки данных на сервер
        //тестовый сервер имитации сетевого запроса - https://reqres.in
        //если поставить точку остановки на строке " let url = URL..." - можно отследить формат закодированных даныхт в консоле "p String(decoding: encoded, as: UTF8.self)"
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //handle our result
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "You order for \(decodedOrder.quantity) x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            return false
        }
        return true
    }
}

#Preview {
    CheckoutView(order: Order())
}
