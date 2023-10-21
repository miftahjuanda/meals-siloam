//
//  FindMealsUseCase.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Combine

protocol FindMealsUseCaseProtocol {
    func searchMeals(keyword: String) -> AnyPublisher<FindMealsEntity, Error>
}

internal class FindMealsUseCase {
    private let httpCLient: HTTPClient
    private let cancellables = CancelBag()
    
    init(networkAPI: HTTPClient = AlamofireHttpClient()) {
        self.httpCLient = networkAPI
    }
}

extension FindMealsUseCase: FindMealsUseCaseProtocol {
    func searchMeals(keyword: String) -> AnyPublisher<FindMealsEntity, Error> {
        let request = httpCLient.request(url: FindMealsRequest(keyword: keyword))
        
        return request
    }
}
