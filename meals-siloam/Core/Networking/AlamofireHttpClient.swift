//
//  AlamofireHttpClient.swift
//  meals-siloam
//
//  Created by Miftah Juanda Batubara on 21/10/23.
//

import Alamofire
import Combine

internal protocol HTTPClient {
    func request<T: RestApi>(url: T) -> AnyPublisher<T.Response, Error>
    func loadImage(from url: String) -> AnyPublisher<UIImage?, Error>
}

internal final class AlamofireHttpClient: NSObject, HTTPClient {
    private struct UnexpectedValuesRepresentation: Error { }
    
    public override init() {}
    
    func request<T: RestApi>(url: T) -> AnyPublisher<T.Response, Error> {
        return Future { promise in
            AF.request(url.toUrlRequest()).responseData { response in
                if let error = response.error {
                    promise(.failure(error))
                } else if let data = response.data {
                    if let mapData = try? url.map(data) {
                        promise(.success(mapData))
                    } else {
                        promise(.failure(UnexpectedValuesRepresentation()
                            .asAFError(orFailWith: "Error mapping data.")))
                    }
                } else {
                    promise(.failure(UnexpectedValuesRepresentation()
                        .asAFError(orFailWith: "Failure request data.")))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadImage(from url: String) -> AnyPublisher<UIImage?, Error> {
        let urlImage = URL(string: url) ?? .init(filePath: "")
        return Future { promise in
            AF.request(urlImage).responseData { response in
                if let error = response.error {
                    promise(.failure(error))
                } else if let data = response.data {
                    promise(.success(UIImage(data: data)))
                } else {
                    promise(.failure(UnexpectedValuesRepresentation()
                        .asAFError(orFailWith: "Failure request data.")))
                }
            }
        }.subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .share()
            .eraseToAnyPublisher()
    }
}
