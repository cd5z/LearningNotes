//
//  ViewController.swift
//  UI
//
//  Created by LiChendi on 16/6/21.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var register: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.layer.borderWidth = 1
        self.password.layer.borderWidth = 1
        //将textfield 中的string转换为Observable
        let emailObservable = self.email.rx_text.map{ (input: String) -> Bool in
            return InputValidator.isValidEmail(input)
        }
        //将bool 转化为color
        emailObservable.map {(valid: Bool) -> UIColor in
            return valid ? UIColor.greenColor() : UIColor.clearColor()
        }.subscribeNext {
            self.email.layer.borderColor = $0.CGColor
        }.addDisposableTo(bag)
        
        
        //password 与email相同，可以简写成以下：
        //还可以继续简写，但是下边要用到bool类型的passwordObservable，用来判断按钮是否可点击。
        /*
        let passwordObservable =  self.password.rx_text.map { InputValidator.isValidPassword($0) ?  UIColor.greenColor() : UIColor.clearColor() }
            .subscribeNext { self.password.layer.borderColor = $0.CGColor }
            .addDisposableTo(bag)
        */
        
        let passwordObservable = self.password.rx_text.map { InputValidator.isValidPassword($0) }
        passwordObservable.map { $0 ?  UIColor.greenColor() : UIColor.clearColor() }
            .subscribeNext { self.password.layer.borderColor = $0.CGColor }
            .addDisposableTo(bag)
        
//        // 将email 和 password 的信号合并
//        let everythingObservable = Observable.combineLatest(emailObservable, passwordObservable) { $0 && $1 }
//        
//        //将everythingObservable 与 self.register.rx_enabled 绑定
//        everythingObservable.bindTo(self.register.rx_enabled)
//        .addDisposableTo(bag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

