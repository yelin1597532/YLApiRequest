//
//  YLApiRequestBuilder.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit
import Combine
import CommonCrypto

@objc public class ApiRequestBuilder: NSObject {
    init(method: HttpMethod, endpoint: String) {
        self.method = method
        self.endpoint = endpoint
        super.init()
    }

    @available(iOS 13.0, *)
    public func start() -> AnyPublisher<Response<Data>, Error> {
        let session = URLSession.shared
        guard let request = self.buildRequest() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        let pub = session.dataTaskPublisher(for: request).tryMap { (result) -> Response<Data> in
            let (data, response) = result
                return Response(value: data, response: response)
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        return pub
    }

    private let method: HttpMethod
    private let endpoint: String
    private var scheme: HttpScheme = DefaultSettings.shared.scheme
    private var host: String = DefaultSettings.shared.host
    private var timeoutInterval: TimeInterval = DefaultSettings.shared.timeoutInterval
    private var query: [URLQueryItem] = DefaultSettings.shared.query ?? [URLQueryItem]()
    private var header : [String: Any] = DefaultSettings.shared.header ?? [String: Any]()
    private var bodyType: BodyType = .Json
    private var body: [String: Encodable] = DefaultSettings.shared.body ?? [String: Encodable]()
    private var cookie: [String: Any] = DefaultSettings.shared.body ?? [String: Any]()
}

// setup request data
extension ApiRequestBuilder {
    public func set(scheme: HttpScheme) -> ApiRequestBuilder {
         self.scheme = scheme
         return self
     }

     public func set(timeoutInterval: TimeInterval) -> ApiRequestBuilder {
         self.timeoutInterval = timeoutInterval
         return self
     }

     public func host(host: String) -> ApiRequestBuilder {
         self.host = host
         return self
     }

     public func set(query: [String: Any]?) -> ApiRequestBuilder {
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
}

// internal build functions
extension ApiRequestBuilder {
    private func buildRequest() -> URLRequest? {
        let _ = add(query: ["sig": signiture()])
        guard let url = buildURL() else {
            return nil
        }
        print(url)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        let _ = self.setHeader(for: &request).setCookie(for: &request).setBody(for: &request)
        return request
    }

    private func signiture() -> String {
        let queryItems = query
        let sortedItems = queryItems.sorted { (item1, item2) -> Bool in
            return item1.name < item2.name
        }
        var resultStr = ""
        for item in sortedItems {
            resultStr.append(item.name)
            resultStr.append(item.value ?? "")
        }
        resultStr.append("mas1c2o0")
        return md5(for: resultStr)
    }

    private func md5(for str: String) -> String {
        let cStrl = str.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16);
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer);
        var md5String = "";
        for idx in 0...15 {
            let obcStrl = String.init(format: "%02x", buffer[idx]);
            md5String.append(obcStrl);
        }
        free(buffer);
        return md5String;
    }

    private func buildURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme == .https ? "https" : "http"
        urlComponents.host = self.host
        urlComponents.path = self.endpoint
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
        if self.method == .POST {
            switch self.bodyType {
            case .Json:
                let data = try? JSONSerialization.data(withJSONObject: self.body)
                request.httpBody = data
            }
        }

        return self
    }

    private func setCookie(for request: inout URLRequest) -> ApiRequestBuilder {
        var cookieStr = ""
        for (key, value) in self.cookie {
            if cookieStr.count > 0 {
                cookieStr.append(";")
            }
            cookieStr.append(key + "=\(value)")
        }
        if cookieStr.count > 0 {
            request.addValue(cookieStr, forHTTPHeaderField: "Cookie")
        }
        return self
    }
}
