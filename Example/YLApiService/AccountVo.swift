//
//  AccountVo.swift
//  YLApiService_Example
//
//  Created by yelin on 2020/4/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class AccountVo: NSObject, Codable {
    var clearFlag = false
    var currentLevelName = ""
    var currentLevelType = 0
    var exchangedPoint = 0
    var frozenPoint = 0
    var nextLevelType = 1
    var pointGap = 0
    var pointLevelVoList = [PointLevelVo]()
    var totalPoint = 0
    var usablePoint = 0
}

class PointLevelVo: NSObject, Codable {
    var levelName = ""
    var levelPointFloor = 0
    var levelPointUpper = 0
    var levelType = 0
}
