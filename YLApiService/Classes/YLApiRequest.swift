//
//  YLApiService.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit

@objc public class YLApiRequest: NSObject {
    @objc public class func getWith(endpoint: String) -> ApiRequestBuilder
    {
        return ApiRequestBuilder(method: .GET, endpoint: endpoint)
    }

    public class func postWith(endpoint: String) -> ApiRequestBuilder
    {
        return ApiRequestBuilder(method: .POST, endpoint: endpoint)
    }
}

extension YLApiRequest {
    public class func setDefault(host: String) {
        DefaultSettings.shared.host = host
    }

    public class func setDefault(query: [String: Any]?) {
        if query != nil {
            var newQuery = [URLQueryItem]()
            for (key, value) in query! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                newQuery.append(queryItem)
            }
            DefaultSettings.shared.query = newQuery
        } else {
            DefaultSettings.shared.query = nil
        }
    }

    public class func setDefault(header: [String: Any]?) {
        DefaultSettings.shared.header = header
    }
}
