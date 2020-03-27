//
//  Typealiases.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit

public typealias SuccessBlock<T> = (_ data: T, _ isCache: Bool) -> ()

extension Encodable {
    func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}
