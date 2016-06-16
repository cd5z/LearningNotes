//
//  ViewController.swift
//  DisposeBag
//
//  Created by LiChendi on 16/6/16.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    var interval: Observable<Int>!
    var subscription: Disposable!
    var bag: DisposeBag!  = DisposeBag()
    @IBOutlet weak var counter: UITextField!
    @IBOutlet weak var disposeCounterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interval = Observable.interval(0.5, scheduler: MainScheduler.instance)
        self.subscription = self.interval.map{ String($0) }.subscribeNext {
            self.counter.text = $0
        }
        
        self.subscription.addDisposableTo(self.bag)
        
        _ = self.disposeCounterButton.rx_tap.subscribeNext {
            print("dispose interval")
            //            self.subscription.dispose()
            self.bag = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

