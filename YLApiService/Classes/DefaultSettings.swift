//
//  DefaultSettings.swift
//  Pods-YLApiService_Example
//
//  Created by yelin on 2020/3/13.
//

import UIKit

class DefaultSettings: NSObject {
    static let shared = DefaultSettings()
    var scheme: HttpScheme = .https
    var host: String = ""
    var timeoutInterval: TimeInterval = 10
    var header: [String: Any]? = nil
    var query: [URLQueryItem]? = nil
    var body: [String: Encodable]? = nil
    var cookie: [String: Any]? = nil
}
