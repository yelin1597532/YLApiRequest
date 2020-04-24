//
//  Typedefs.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import Foundation

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public enum HttpScheme {
    case http
    case https
}

public enum BodyType {
    case Json
}

public struct Response<T> {
    public let value: T
    public let response: URLResponse
    public init(value: T, response: URLResponse) {
        self.value = value
        self.response = response
    }
}
