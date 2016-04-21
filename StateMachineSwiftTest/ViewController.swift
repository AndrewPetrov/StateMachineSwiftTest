//
//  ViewController.swift
//  StateMachineSwiftTest
//
//  Created by AndrewPetrov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var doneGoalsCount: UIStepper!
    @IBOutlet weak var label: UILabel!
    var waterView: WaterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let inset: CGFloat = 100.0
        waterView = WaterView(frame: CGRectMake(0, inset / 2, view.frame.size.width, view.frame.size.height - inset * 2))
        view.addSubview(waterView)
    }


    @IBAction func setDoneGoals(sender: UIStepper) {
        waterView.doneGoalsCount = Int(sender.value)
        label.text = "\(Int(sender.value)) / \(Int(sender.maximumValue))"
    }
    
}

