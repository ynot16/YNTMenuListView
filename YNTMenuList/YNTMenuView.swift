//
//  YNTMenuView.swift
//  YNTMenuList
//
//  Created by bori－applepc on 2017/2/6.
//  Copyright © 2017年 bori－applepc. All rights reserved.
//

import UIKit

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

protocol YNTMenuViewDataSource {
    func tagHeight(for menuList: UIView) -> CGFloat
    func tagWidth(for menuList: UIView) -> CGFloat
    func menuList(_ menuList: UIView, viewForColunmAt colunm: Int) -> UIView
    func titleArray(for menuList: UIView) -> [String]
}

class YNTMenuView: UIView {
    
    var dataSource: YNTMenuViewDataSource?
    internal var tagScroll: UIScrollView?
    private var listScroll: UIScrollView?
    private var tagHeight: CGFloat?
    private var tagWidth: CGFloat?
    private var titleArray: [String]?
    internal var lastSelectedTitleBtn: UIButton?
    internal var titleBtnClick: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagHeight = self.dataSource?.tagHeight(for: self)
        tagWidth = self.dataSource?.tagWidth(for: self)
        titleArray = self.dataSource?.titleArray(for: self)
        setupTagScroll()
        setupListScroll()
    }

    func setupTagScroll() {
        guard let tagHeight = tagHeight, let tagWidth = tagWidth, let titleArray = titleArray else {
            return
        }
        tagScroll = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: tagHeight))
        tagScroll?.showsVerticalScrollIndicator = false
        tagScroll?.showsHorizontalScrollIndicator = false
        tagScroll?.contentSize = CGSize(width: tagWidth * CGFloat(titleArray.count), height: tagHeight)
        
        if let tagScroll = tagScroll {
            addSubview(tagScroll)
            
            for i in 0 ..< titleArray.count {
                let tagBtn = UIButton(frame: CGRect(x: tagWidth * CGFloat(i), y: 0, width: tagWidth, height: tagHeight))
                tagBtn.setTitleColor(UIColor.black, for: .normal)
                tagBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                tagBtn.addTarget(self, action: #selector(YNTMenuView.changePage(with:)), for: .touchUpInside)
                tagBtn.setTitle(titleArray[i], for: .normal)
                tagBtn.tag = i + 1
                tagScroll.addSubview(tagBtn)
            }
        }
    }
    
    func setupListScroll() {
        guard let tagHeight = tagHeight, let titleArray = titleArray else {
            return
        }
        listScroll = UIScrollView(frame: CGRect(x: 0.0, y: tagHeight, width: bounds.size.width, height: bounds.size.height - tagHeight))
        listScroll?.delegate = self
        listScroll?.showsHorizontalScrollIndicator = false
        listScroll?.showsVerticalScrollIndicator = false
        listScroll?.isPagingEnabled = true
        listScroll?.contentSize = CGSize(width: bounds.size.width * CGFloat(titleArray.count), height: bounds.size.height - tagHeight)
        
        if let listScroll = listScroll {
            addSubview(listScroll)
            
            for i in 0 ..< titleArray.count {
                if let listView = self.dataSource?.menuList(self, viewForColunmAt: i) {
                    listView.frame = CGRect(x: bounds.size.width * CGFloat(i), y: listView.frame.origin.y, width: listView.frame.size.width, height: listView.frame.size.height)
                    listScroll.addSubview(listView)
                }
            }
        }
    }
    
    func changePage(with titleBtn: UIButton) {
        titleBtnClick = true
        if let listScroll = listScroll {
            lastSelectedTitleBtn?.setTitleColor(UIColor.black, for: .normal)
            lastSelectedTitleBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            titleBtn.setTitleColor(UIColor.red, for: .normal)
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            listScroll.scrollRectToVisible(CGRect(x: bounds.size.width * CGFloat(titleBtn.tag - 1), y: listScroll.frame.origin.y, width: listScroll.frame.size.width, height: listScroll.frame.size.height), animated: false)
            updateTagScrollContentOffsetX(with: titleBtn.tag)
            lastSelectedTitleBtn = titleBtn
            titleBtnClick = false
        }
    }
    
    func updateTagScrollContentOffsetX(with tag: Int) {
        let titleBtn = tagScroll?.viewWithTag(tag) as? UIButton
        if let titleBtn = titleBtn {
            guard let lastSelectedTitleBtn = lastSelectedTitleBtn else {
                return
            }
            
            guard let tagWidth = tagWidth, let tagScroll = tagScroll else {
                return
            }
            if lastSelectedTitleBtn.tag < titleBtn.tag {
                if titleBtn.tag >= 3 {
                    tagScroll.scrollRectToVisible(CGRect(x: tagWidth * CGFloat(titleBtn.tag - 3), y: tagScroll.frame.origin.y, width: tagScroll.frame.size.width, height: tagScroll.frame.size.height), animated: true)
                }
            }else {
                if titleBtn.tag <= 3 {
                    tagScroll.scrollRectToVisible(CGRect(x: tagWidth * CGFloat(titleBtn.tag - 3), y: tagScroll.frame.origin.y, width: tagScroll.frame.size.width, height: tagScroll.frame.size.height), animated: true)
                }else {
                    tagScroll.scrollRectToVisible(CGRect(x: tagWidth * CGFloat(titleBtn.tag - 3), y: tagScroll.frame.origin.y, width: tagScroll.frame.size.width, height: tagScroll.frame.size.height), animated: true)
                }
            }
        }
    }
}

extension YNTMenuView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if titleBtnClick == true {
            return
        }
        let index = scrollView.contentOffset.x / bounds.size.width
        let titleBtn = tagScroll?.viewWithTag(Int(index + 1)) as? UIButton
        if let titleBtn = titleBtn {
            lastSelectedTitleBtn?.setTitleColor(UIColor.black, for: .normal)
            lastSelectedTitleBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            titleBtn.setTitleColor(UIColor.red, for: .normal)
            titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            updateTagScrollContentOffsetX(with: titleBtn.tag)
            lastSelectedTitleBtn = titleBtn
        }
    }
}
