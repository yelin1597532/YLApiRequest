//
//  ViewController.swift
//  YLApiService
//
//  Created by yelin on 03/13/2020.
//  Copyright (c) 2020 yelin. All rights reserved.
//

import UIKit
import YLApiService
import Combine

// http://app-jjxt.reg.highso.com.cn/point/v1/ptAccount.do?device=iPhone_7&app_version=2.21.0&uid=11271161&app_key=ju158969&sk=8cf405f6-6189-42fc-95a3-fe2eed934796.1587544019664.11271161.2E841830-10DF-4A59-86B8-E3F2FBEFFA87.af27bfaf310fd06e860ecaf6c3670c0b&v=4.0&clazzId=11147&token=2E841830-10DF-4A59-86B8-E3F2FBEFFA87&sig=cf96e5a434dc6b058498784caa82a82d

class ViewController: UIViewController {
    var req: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        YLApiRequest.setDefault(host: "app-jjxt.reg.highso.com.cn")
        YLApiRequest.setDefault(query: ["device": "iPhone_7",
                                        "app_version": "2.21",
                                        "app_key": "ju158969",
                                        "sk": "944fdcd8-53fd-4da9-a672-eb85ca2e5489.1587623646228.11271161.2E841830-10DF-4A59-86B8-E3F2FBEFFA87.ebb29f4873c44ad09878035165cd91c7",
                                        "v": "4.0",
                                        "token": "2E841830-10DF-4A59-86B8-E3F2FBEFFA87"])



        req = YLApiRequest.getWith(endpoint: "/point/v1/ptAccount.do").set(scheme: .http).add(query: ["uid": "11271161", "classId": 11147]).start().transform(to: AccountVo.self).on(success: { (account) in
            print(account)
        }, fail: { (error) in
            print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

