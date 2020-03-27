//
//  ViewController.swift
//  YLApiService
//
//  Created by yelin on 03/13/2020.
//  Copyright (c) 2020 yelin. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = try? JSONEncoder().encode("asfsdf") {
            print(String(data: data, encoding: .utf8))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

