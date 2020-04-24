//
//  GeneralObject.swift
//  YLApiService_Example
//
//  Created by yelin on 2020/4/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class GeneralObject<T: Codable>: NSObject, Codable {
    var currServerDate: Date
    var data: T?
    var logMessageId: String
    var m: String
    var s: Int
}
