//
//  DetailMealsUseCase.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Combine
import UIKit

protocol DetailMealsUseCaseProtocol {
    func detailMeals(idMeal: String) -> AnyPublisher<DetailMealsEntity, Error>
}

internal class DetailMealsUseCase {
    private let httpCLient: HTTPClient
    private let cancellables = CancelBag()
    
    init(networkAPI: HTTPClient = AlamofireHttpClient()) {
        self.httpCLient = networkAPI
    }
}

extension DetailMealsUseCase: DetailMealsUseCaseProtocol {
    func detailMeals(idMeal: String) -> AnyPublisher<DetailMealsEntity, Error> {
        let request = httpCLient.request(url: DetailMealsRequest(idMeal: idMeal))
        
        return request
    }
}
