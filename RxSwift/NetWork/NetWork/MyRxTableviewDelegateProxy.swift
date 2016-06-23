//
//  MyRxTableviewDelegateProxy.swift
//  NetWork
//
//  Created by LiChendi on 16/6/23.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyRxTableviewDelegateProxy: DelegateProxy, UITableViewDelegate, DelegateProxyType {
    static func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let tableview = object as! UITableView
        return tableview.delegate
    }
    
    static func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let tableview = object as! UITableView
        tableview.delegate = delegate as? UITableViewDelegate
    }
}


extension UITableView {
    var rxDelegate: MyRxTableviewDelegateProxy {
        return MyRxTableviewDelegateProxy.proxyForObject(self)
    }
    
    var rxDidSelectRowAtIndexPath: Observable<(UITableView, NSIndexPath)> {
        return rxDelegate.observe(.didSelectRowAtIndexPath).map {paramArray in
            return (paramArray[0] as! UITableView, paramArray[1] as! NSIndexPath)
        }
    }
}

private extension Selector {
    static let didSelectRowAtIndexPath = #selector(UITableViewDelegate.tableView(_:didSelectRowAtIndexPath:))
}