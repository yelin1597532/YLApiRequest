//
//  YLApiService.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit

public class YLApiRequest: NSObject {
    public class func getWith(endpoint: String) -> ApiRequestBuilder
    {
        return ApiRequestBuilder(method: .GET, endpoint: endpoint)
    }

    public class func postWith(endpoint: String) -> ApiRequestBuilder
    {
        return ApiRequestBuilder(method: .POST, endpoint: endpoint)
    }

    
}
