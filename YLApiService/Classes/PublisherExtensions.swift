//
//  PublisherExtensions.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/4/23.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public extension AnyPublisher where Output == Response<Data> {
    func transform<T: Codable>(to type: T.Type) -> Publishers.TryMap<AnyPublisher<Response<Data>, Failure>, T?> {
        return self.tryMap { (response) -> T? in
            let decoder = JSONDecoder()
            let generalObject = try decoder.decode(GeneralObject<T>.self, from: response.value)
            if generalObject.s == 1 {
                return generalObject.data
            } else {
                throw NSError(domain: "network.error", code: generalObject.s, userInfo: [NSLocalizedFailureReasonErrorKey : generalObject.m])
            }
        }
    }
}

@available(iOS 13.0, *)
public extension Publisher {
    func on(success: @escaping ((Self.Output) -> Void), fail: @escaping ((Error) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: { (complete) in
            switch complete {
            case .failure(let error):
                fail(error)
            default:
                break
            }
        }) { (output) in
            success(output)
        }
    }
}
