# YNTMenuListView
menu list

不知道这种控件具体应该怎么称呼，听得比较多的就是仿网易首页，但是在Github上寻思着不知道怎么搜，而我自己总觉得是叫menu相关的，但是搜出来多数都是侧滑menu。干脆趁着刚上班，没什么状态，自己撸一个，找找状态，练练手感。希望知道怎么叫这种控件的麻烦告知一下哈～～

使用方法：

1、创建view

    let menuView = YNTMenuView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    menuView.dataSource = self
    view.addSubview(menuView)
    
2、实现数据源

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
    
    
    
整个控件其实挺简单，无非就是两个scrollView，上面一个下面一个，之前项目也有用过。不过这次主要做了两个改变：

1、调用方式通过自定义protocol，仿造了tableView的dataSource，调用起来显得比较优雅。

    protocol YNTMenuViewDataSource {
        func tagHeight(for menuList: UIView) -> CGFloat
        func tagWidth(for menuList: UIView) -> CGFloat
        func menuList(_ menuList: UIView, viewForColunmAt colunm: Int) -> UIView
        func titleArray(for menuList: UIView) -> [String]
    }

2、因为上下两个scrollView需要联动，还有选中的某个标签状态（字体颜色，大小等等）需要变化，所以还要做一些处理。以前用的别人写的控件，方法感觉不大好，是通过遍历上面那个scrollView的所有子控件，通过匹配每一个标签button的tag值，匹配的button设置选中状态，不匹配的button设置默认状态。

    for (id obj in _navScrollV.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *currentButton = (UIButton*)obj;
            if (currentButton.tag == btn.tag ) {
                [currentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else {
                [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
   
但是其实任何情况下都有且只有一个标签button被选中，所以可以通过一个全局变量lastSelectedTitleBtn保存上一次选中的标签button，那么改变状态的时候就无需通过遍历了。

    lastSelectedTitleBtn?.setTitleColor(UIColor.black, for: .normal)
    lastSelectedTitleBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
    newTitleBtn.setTitleColor(UIColor.red, for: .normal)
    newTitleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
