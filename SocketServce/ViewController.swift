//
//  ViewController.swift
//  SocketServce
//
//  Created by 李世洋 on 16/8/7.
//  Copyright © 2016年 李世洋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SocketServceManger.shareManger().openServces()
    }


}

