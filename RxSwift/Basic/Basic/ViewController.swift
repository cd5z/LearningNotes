//
//  ViewController.swift
//  Basic
//
//  Created by LiChendi on 16/6/16.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var rxUserInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.rxUserInput.rx_text
            .map{ (string: String) -> Int in
                if let lastChar = string.characters.last {
                    if let n = Int(String(lastChar)) {
                        return n
                    }
                }
                return -1
            }
            .filter{ $0 % 2 == 0 }
            .subscribeNext{ print($0)}
        
        //  empty
        let emptySequence = Observable<Int>.empty()
        _ = emptySequence.subscribe{ (event: RxSwift.Event<Int>) -> Void in
            print(event)
        }
        
        //  just
        _ = Observable.just(1).subscribe({ (event: RxSwift.Event<Int>) -> Void in
            print(event)
        })
        
        //  of
        _ = Observable.of(1, 2, 3, 4, 5).subscribe({ (event: RxSwift.Event<Int>) -> Void in
            print(event)
        })
        
        //  error
        let error = NSError(domain: "error", code: -1, userInfo: nil)
        _ = Observable.error(error).subscribe({ (event: RxSwift.Event<Int>) -> Void in
            print(event)
        })
        
        // create
        func myJust(event: Int) -> Observable<Int> {
            return Observable.create { observer in
                if event % 2 == 0 {
                    observer.on(.Next(event))
                    observer.on(.Completed)
                } else {
                    let error = NSError(domain: "error domain", code: -1, userInfo: nil)
                    observer.on(.Error(error))
                }
                return NopDisposable.instance
            }
        }
        
        
        _ = myJust(10).subscribe { print($0) }
        _ = myJust(1).subscribe { print($0)}
        
        //  generate
        _ = Observable.generate(initialState: 0, condition: { $0 < 10 }, iterate: { $0 + 1 })
            .subscribe{ print($0) }
        
        //  deferred
        let deferredSequence = Observable<Int>.deferred{
            print("deferred")
            return Observable.generate(initialState: 0, condition: { $0 < 3 }, iterate: { $0 + 1 })
        }
        _ = deferredSequence.subscribe{ print($0)}
        _ = deferredSequence.subscribe{ print($0)}
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.userInput {
            if let n = Int(string) {
                if n % 2 == 0 {
                    print(n)
                }
            }
        }
        return true
    }
}

