//
//  Model.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 24.02.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabaseInternal

 let cornerRadius: CGFloat = 25

struct Product:Codable{
    let name: String
    let descript: String
    let cost : Int
    let type: String
}

struct BasketItem {
    let product: Product
    let quantity: Int
}

var basketItems = [BasketItem]()

var basketArray = [Product](){
    didSet{
        do{
            let encodedData = try JSONEncoder().encode(basketArray)
            UserDefaults.standard.setValue(encodedData, forKey: "Basket")
        } catch {
            print(error)
        }
    }
}


func loadBasket (){
    if let savedData = UserDefaults.standard.object(forKey: "Basket") as? Data{
        do{
            let savedProducts = try JSONDecoder().decode([Product].self, from: savedData)
            basketArray = savedProducts
        }catch{
            print(error)
        }
    }
}
//var storage:[Product] = [Product(name: "Margarita", descript: "Tasty pizza (450 gr)", cost: 400, type: "Pizza"),
//                         Product(name: "Hamburger", descript: "Very very tasty burger (220 gr)", cost: 250, type: "Burger"),
//                         Product(name: "Sicilian", descript: "Pizza sicilia (480 gr)", cost: 500, type: "Pizza"),
//                         Product(name: "Tea", descript: "Tea (0.5l)", cost: 80, type: "Drink"),
//                         Product(name: "Paper", descript: "Paper list white color", cost: 5, type: "Other"),
//                         Product(name: "Honey Cake", descript: "Very tasty cake", cost: 500, type: "Cake"),
//                         Product(name: "Cofee", descript: "Arabica cofee (0.2l)", cost: 200, type: "Drink"),
//                         Product(name: "Bacon cheseeburger", descript: "Bacon cheseeburger very well", cost: 300, type: "Burger"),
//                         Product(name: "Beer", descript: "Beer strong (0.5l)", cost: 120, type: "Alcohol"),
//                         Product(name: "Parlament", descript: "Parlament", cost: 200, type: "Sigarets"),
//                         Product(name: "4 Chese", descript: "4 chese", cost: 500, type: "Pizza"),
//     ]

class Storage {
    var ref: DatabaseReference!
   static let shared = Storage()
    let url: URL
    let urlSession: URLSession
    
    enum FetchErrors: Error, LocalizedError {
        case noData
        var errorDescription: String? {
            switch self {
            case .noData:
                return "No data in response!"
            }
        }
    }
    var productTypesArray: [String] = []
    var productContainers:[[Product]] = []
    var storage: [Product] = [Product]() {
        didSet {
            for product in storage{
                if !productTypesArray.contains(product.type){
                    productTypesArray.append(product.type)
                    productContainers.append([])
                }
                let indexOfProductType =  productTypesArray.firstIndex(where: {$0 == product.type})
                productContainers[indexOfProductType!].append(product)
            }
        }
    }

    init(
        storage: [Product] = [Product](),
        url: URL = URL(string: "https://raw.githubusercontent.com/einvolko/myPizzaApp/main/Produts.json")!,
        urlSession: URLSession = URLSession(configuration: .ephemeral)
    ) {
        self.storage = storage
        self.url = url
        self.urlSession = urlSession
    }
    func newFetcher(completion: @escaping ((Result<[Product], Error>) -> Void)){
        ref = Database.database().reference()
        ref.getData { error, snapshot in
            if let error = error {
                           print(error);
                           //TODO: show alert
                           completion(.failure(error))
                           return
                       }
            guard let data = snapshot?.value else {
                            completion(Result.failure(FetchErrors.noData))
                            return
                        }
            
            do {
                guard let data = snapshot!.data else { return }
                self.storage = try JSONDecoder().decode([Product].self, from: data as! Data)
                completion(Result.success(self.storage))
                
              
                
            }
            catch {
                           completion(Result.failure(error))
                       }
                   }
        
    }
//    func fetchData(completion: @escaping ((Result<[Product], Error>) -> Void)) {
//        urlSession.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print(error);
//                //TODO: show alert
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else {
//                completion(Result.failure(FetchErrors.noData))
//                return
//            }
//            do {
//                let products = try JSONDecoder().decode([Product].self, from: data)
//                                self.storage = products
//                completion(Result.success(self.storage))
//            }
//            catch {
//                completion(Result.failure(error))
//            }
//        }.resume()
//    }
}
   
extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}


