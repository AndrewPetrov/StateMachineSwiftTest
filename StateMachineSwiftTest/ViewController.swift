//
//  ViewController.swift
//  StateMachineSwiftTest
//
//  Created by AndrewPetrov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

protocol UpdateView: class {
    func updateView(level: Double)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var doneGoalsCount: UIStepper!
    @IBOutlet weak var label: UILabel!
    var waterView: WaterView!
    lazy var goalsModel: GoalsModel = GoalsModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inset: CGFloat = 100.0
        waterView = WaterView(frame: CGRectMake(0, inset / 2, view.frame.size.width, view.frame.size.height - inset * 2))
        view.addSubview(waterView)
    }
    
    @IBAction func setDoneGoals(sender: UIStepper) {
        goalsModel.doneGoalsCount = Int(sender.value)
        label.text = "\(goalsModel.level)"
    }
    
}

extension ViewController: UpdateView {
    func updateView(level: Double) {
        waterView.level = level
    }
}

class GoalsModel {

    weak private var delegate: UpdateView!
    var level: Double {
        return Double(doneGoalsCount) / Double(totalGoalsCount)
    }
    var doneGoalsCount = 0 {
        didSet {
            delegate.updateView(level)
        }
    }
    private var totalGoalsCount = 10
    
    init(delegate: UpdateView) {
        self.delegate = delegate
    }
    
}

extension UIColor {
    
    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        let redPart = CGFloat(red) / 255
        let greenPart = CGFloat(green) / 255
        let bluePart = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
    }
}
