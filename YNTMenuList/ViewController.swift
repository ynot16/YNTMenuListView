//
//  ViewController.swift
//  YNTMenuList
//
//  Created by bori－applepc on 2017/2/6.
//  Copyright © 2017年 bori－applepc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let menuView = YNTMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        menuView.dataSource = self
        view.addSubview(menuView)
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: YNTMenuViewDataSource {
    
    func tagHeight(for menuList: UIView) -> CGFloat {
        return 40
    }
    
    func tagWidth(for menuList: UIView) -> CGFloat {
        return 80
    }
    
    func menuList(_ menuList: UIView, viewForColunmAt colunm: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        view.backgroundColor = UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1.0)
        return view
    }
    
    func titleArray(for menuList: UIView) -> [String] {
        return ["头条", "要闻", "娱乐", "体育", "广州", "头条", "要闻", "娱乐", "体育", "广州"];
    }
}

