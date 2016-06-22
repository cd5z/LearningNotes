//
//  AboutYouViewController.swift
//  UI
//
//  Created by LiChendi on 16/6/21.
//  Copyright © 2016年 LiChendi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum Gender {
    case noSelected
    case male
    case female
}

class AboutYouViewController: UIViewController {
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var knowSwift: UISwitch!
    @IBOutlet weak var swiftLevel: UISlider!
    @IBOutlet weak var passionToLearn: UIStepper!
    @IBOutlet weak var heartHeight: NSLayoutConstraint!
    @IBOutlet weak var update: UIButton!
    
    var bag: DisposeBag! = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let birthdayObservable = self.birthday.rx_date.map {
            InputValidator.isValidDate($0) ? true : false
        }
        
        self.birthday.layer.borderWidth = 1
        birthdayObservable.map { $0 ? UIColor.greenColor() : UIColor.clearColor() }
            .subscribeNext { self.birthday.layer.borderColor = $0.CGColor }
            .addDisposableTo(bag)
        
        let genderSelection = Variable<Gender>(.noSelected)
        
        self.male.rx_tap.map { return Gender.male }
            .bindTo(genderSelection)
            .addDisposableTo(bag)
        
        self.female.rx_tap.map { return Gender.female }
            .bindTo(genderSelection)
            .addDisposableTo(bag)
        
        genderSelection.asObservable().subscribeNext {
            switch $0 {
            case .male:
                self.male.setImage(UIImage(named: "check"), forState: .Normal)
                self.female.setImage(UIImage(named: "uncheck"), forState: .Normal)
            case .female:
                self.male.setImage(UIImage(named: "uncheck"), forState: .Normal)
                self.female.setImage(UIImage(named: "check"), forState: .Normal)
            default:
                break
            }
        }.addDisposableTo(bag)
        
        let genderButtonObservable = genderSelection.asObservable().map {
            return $0 != .noSelected ? true : false
        }
        
        Observable.combineLatest( birthdayObservable, genderButtonObservable) { $0 && $1 }
            .bindTo(self.update.rx_enabled)
            .addDisposableTo(bag)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
