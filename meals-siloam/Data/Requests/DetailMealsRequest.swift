//
//  DetailMealsRequest.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal struct DetailMealsRequest: RestApi {
    typealias Response = DetailMealsEntity
    
    var baseURL: String = Constants.shared.baseURL
    var path: String = "/1/lookup.php"
    var headers: [String : String]?
    var queryItems: [URLQueryItem]?
    
    init(idMeal: String) {
        self.queryItems = [URLQueryItem(name: "i", value: idMeal)]
    }
    
    func map(_ data: Data) throws -> DetailMealsEntity {
        let data = try JSONDecoder().decode(FindMealsResponse.self, from: data)
        return data.toDomainDetailMeals()
    }
}
