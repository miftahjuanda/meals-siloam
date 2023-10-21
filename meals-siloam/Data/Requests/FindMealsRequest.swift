//
//  FindMealsRequest.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Foundation

internal struct FindMealsRequest: RestApi {
    typealias Response = FindMealsEntity
    
    var baseURL: String = Constants.shared.baseURL
    var path: String = "/1/search.php"
    var headers: [String : String]?
    var queryItems: [URLQueryItem]?
    
    init(keyword: String) {
        self.queryItems = [URLQueryItem(name: "s", value: keyword)]
    }
    
    func map(_ data: Data) throws -> FindMealsEntity {
        let data = try JSONDecoder().decode(FindMealsResponse.self, from: data)
        return data.toDomainFindMeals()
    }
}
