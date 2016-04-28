//
//  WaterView.swift
//  StateMachineSwiftTest
//
//  Created by AndrewPetrov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import UIKit

let wavesCount = 1
let wavesChangingLevelDuration = 7.0
let wavesChangingLevelDelay = 2.0

struct WaveAmplitude {
    let minAmplitude: Int
    let amplitudeIncrement: Int
    let maxAmplitude: Int
}

enum WavesState {
    case Idle, IncreasingAmplitude, ChangingLevel, DecreasingAmplitude
}

protocol WaterViewAnimation: class {
    func increaseWaves()
    func decreaseWaves()
    func changeWaterLevel()
    func changeWavesColor()
}

class WaterView: UIView {
    
    var level = 0.0 {
        didSet {
            animator.changeLevel()
        }
    }
    
    private var fluidViews: [BAFluidView]!
    private let lowAmplitude = WaveAmplitude(minAmplitude: 1, amplitudeIncrement: 2, maxAmplitude: 5)
    private let highAmplitude = WaveAmplitude(minAmplitude: 10, amplitudeIncrement: 3, maxAmplitude: 30)
    private var previousWavesIdleLevel: Double!
    
    private lazy var animator: Animator = Animator(animatedObject: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupWavesView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWavesView() {
        if fluidViews != nil {
            return
        }
        fluidViews = [BAFluidView]()
        for _ in 0..<wavesCount {
            let fluidView = BAFluidView(frame: frame)
            
            fluidView.fillColor = UIColor.blueColor()
            fluidView.alpha = 1
            fluidView.fillAutoReverse = false
            fluidView.fillRepeatCount = 0
            fluidView.fillDuration = wavesChangingLevelDuration
            fluidView.complitionBlock = { [weak self] in
                self!.animator.currentState = .DecreasingAmplitude
            }
            insertSubview(fluidView, atIndex: 0)
            fluidViews.append(fluidView)
        }
        changeWavesAmplitudeTo(lowAmplitude)
    }
    
    private func changeWavesAmplitudeTo(parameters:WaveAmplitude) {
        for fluidView in fluidViews {
            fluidView.minAmplitude = CInt(parameters.minAmplitude)
            fluidView.amplitudeIncrement = CInt(parameters.amplitudeIncrement)
            fluidView.maxAmplitude = CInt(parameters.maxAmplitude)
        }
    }
    
    private func showCheckmark() {
        print("showCheckmark")
    }
}

extension WaterView: WaterViewAnimation {
    
    func increaseWaves() {
        changeWavesAmplitudeTo(highAmplitude)
        NSTimer.scheduledTimerWithTimeInterval(wavesChangingLevelDelay, repeats: false) {
            self.animator.currentState = .ChangingLevel
        }
    }
    
    func changeWaterLevel() {
        var safeLevel = max(level, 0.01)
        safeLevel = min(level, 0.99)
        for fluidView in fluidViews {
            fluidView.fillTo(NSNumber(double: safeLevel))
        }
    }
    
    func decreaseWaves() {
        NSTimer.scheduledTimerWithTimeInterval(
            wavesChangingLevelDelay,
            repeats: false) { [weak self] in
                if self!.animator.currentState == .DecreasingAmplitude {
                    self!.changeWavesAmplitudeTo(self!.lowAmplitude)
                    
                    self!.animator.currentState = .Idle
                    self!.previousWavesIdleLevel = self!.level
                }
        }
    }
    
    func changeWavesColor() {
        var color: UIColor
        switch  animator.currentState {
            
        case .Idle:
            color = UIColor(rgbColorCodeRed: 6, green: 37, blue: 255, alpha: 1)
            
        case .IncreasingAmplitude:
            color = UIColor(rgbColorCodeRed: 2, green: 255, blue: 20, alpha: 1)
            
        case .ChangingLevel:
            color = UIColor(rgbColorCodeRed: 255, green: 36, blue: 8, alpha: 1)
            
        case .DecreasingAmplitude:
            color = UIColor(rgbColorCodeRed: 6, green: 231, blue: 232, alpha: 1)
        }
        
        for fluidView in fluidViews {
            UIView.animateWithDuration(0.2, animations: {
                fluidView.fillColor = color
            })
        }
    }
    
}

class Animator {
    
    init(animatedObject: WaterViewAnimation) {
        currentState = WavesState.Idle
        self.animatedObject = animatedObject
    }
    
    private var _currentState = WavesState.Idle
    var currentState: WavesState {
        set {
            var shouldChangeState = false
            switch (self.currentState, newValue){
                
            case (.Idle, .IncreasingAmplitude):
                shouldChangeState = true
                
            case (.IncreasingAmplitude, .ChangingLevel):
                shouldChangeState = true
                
            case (.ChangingLevel, .DecreasingAmplitude), (.ChangingLevel, .ChangingLevel):
                shouldChangeState = true
                
            case (.DecreasingAmplitude, .Idle), (.DecreasingAmplitude, .IncreasingAmplitude):
                shouldChangeState = true
                
            default:
                break
            }
            if shouldChangeState {
                _currentState = newValue
                print("currentState = \(_currentState)")
                animateView()
            }
        }
        
        get {
            return _currentState
        }
    }
    
    private weak var animatedObject: WaterViewAnimation!
    
    func changeLevel() {
        switch (self.currentState){
            
        case (.Idle):
            self.currentState = .IncreasingAmplitude
            
        case (.ChangingLevel):
            self.currentState = .ChangingLevel
            
        case (.DecreasingAmplitude):
            self.currentState = .IncreasingAmplitude
            
        default:
            break
        }
    }
    
    private func animateView() {
        switch currentState {
            
        case .Idle:
            break
            
        case .DecreasingAmplitude:
            animatedObject.decreaseWaves()
            
        case .IncreasingAmplitude:
            animatedObject.increaseWaves()
            
        case .ChangingLevel:
            animatedObject.changeWaterLevel()
        }
        animatedObject.changeWavesColor()
    }
}

