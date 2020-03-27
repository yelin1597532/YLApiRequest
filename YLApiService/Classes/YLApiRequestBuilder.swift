//
//  YLApiRequestBuilder.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit

public class ApiRequestBuilder: NSObject {
    init(method: HttpMethod, endpoint: String) {
        self.method = method
        self.endpoint = endpoint
        super.init()
    }

    public func set(timeoutInterval: TimeInterval) -> ApiRequestBuilder {
        self.timeoutInterval = timeoutInterval
        return self
    }

    public func host(host: String) -> ApiRequestBuilder {
        self.host = host
        return self
    }

    public func set(query: [String: Any]?, stringEncoding: String.Encoding = .utf8) -> ApiRequestBuilder {
        self.query.removeAll()
        return self.add(query: query)
    }

    public func add(query: [String: Any]?) -> ApiRequestBuilder {
       if query != nil {
           var newQuery = [URLQueryItem]()
           for (key, value) in query! {
               let queryItem = URLQueryItem(name: key, value: "\(value)")
               newQuery.append(queryItem)
           }
           self.query.append(contentsOf: newQuery)
       }
       return self
   }

    public func set(header: [String: Any]?) -> ApiRequestBuilder {
        self.header.removeAll()
        return self.add(header: header)
    }

    public func add(header: [String: Any]?) -> ApiRequestBuilder {
        if let newHeader = header {
            self.header.merge(newHeader) { (_, new) in new }
        }
        return self
    }

    public func set(bodyType: BodyType) -> ApiRequestBuilder {
        self.bodyType = bodyType
        return self
    }

    public func set(body: [String: Encodable]?) -> ApiRequestBuilder {
        self.body.removeAll()
        return self.add(body: body)
    }

    public func add(body: [String: Encodable]?) -> ApiRequestBuilder {
        if let newBody = body {
            self.body.merge(newBody) { (_, new) in new }
        }
        return self
    }

    public func cookie(cookie: [String: Any]?) -> ApiRequestBuilder {
        self.cookie.removeAll()
        return self.add(cookie: cookie)
    }

    public func add(cookie: [String: Any]?) -> ApiRequestBuilder {
        if let newCookie = cookie {
            self.cookie.merge(newCookie) { (_, new) in new }
        }
        return self
    }

    public func start() -> URLSessionDataTask? {
        let session = URLSession.shared
        return nil
    }

    private let method: HttpMethod
    private let endpoint: String
    private var host: String = DefaultSettings.shared.host
    private var timeoutInterval: TimeInterval = DefaultSettings.shared.timeoutInterval
    private var query: [URLQueryItem] = DefaultSettings.shared.query ?? [URLQueryItem]()
    private var header : [String: Any] = DefaultSettings.shared.header ?? [String: Any]()
    private var bodyType: BodyType = .Json
    private var body: [String: Encodable] = DefaultSettings.shared.body ?? [String: Encodable]()
    private var cookie: [String: Any] = DefaultSettings.shared.body ?? [String: Any]()

    private func buildRequest(host: String, queryItems: [URLQueryItem]) -> URLRequest? {
        guard let url = buildURL() else {
            return nil
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        self.setHeader(for: &request)
        return nil

    }

    private func buildURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.host = self.host
        urlComponents.queryItems = query

        return urlComponents.url
    }

    private func setHeader(for request: inout URLRequest) -> ApiRequestBuilder {
        for (key, value) in self.header {
            request.setValue("\(value)", forHTTPHeaderField: key)
        }
        return self
    }

    private func setBody(for request: inout URLRequest) -> ApiRequestBuilder {
        switch self.bodyType {
        case .Json:
            let data = try? JSONSerialization.data(withJSONObject: self.body)
            request.httpBody = data
        }
        return self
    }


}
