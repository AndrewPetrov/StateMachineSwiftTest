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
let wavesChangingLevelDuration = 4.0
let wavesChangingLevelDelay = 2.0

enum LTWavesState {
    case Stand, IncreasingAmplitude, ChangingLevel, DecreasingAmplitude
}

struct WaveAmplitudes {
    let minAmplitude: Int
    let amplitudeIncrement: Int
    let maxAmplitude: Int
}

class WaterView: UIView {
    
    var totalGoalsCount = 5
    
    private var _doneGoalsCount: Int?
    var doneGoalsCount: Int {
        set {
            self._doneGoalsCount = newValue
            updateWavesLevel()
        }
        get {
            return self._doneGoalsCount!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupWavesView()
        doneGoalsCount = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var fluidViews: [BAFluidView]!
    private let lowWaves = WaveAmplitudes(minAmplitude: 1, amplitudeIncrement: 2, maxAmplitude: 5)
    private let highWaves = WaveAmplitudes(minAmplitude: 10, amplitudeIncrement: 3, maxAmplitude: 30)
    private var previousWavesStoppedLevel: CGFloat!
    private var wavesState: LTWavesState = .Stand
    
    func updateWavesLevel() {
        if totalGoalsCount == 0 {
            return
        }
        switch wavesState {
            
        case .Stand:
            fallthrough
        case .DecreasingAmplitude:
            increaseWaves()
            break;
            
        case .IncreasingAmplitude:
            break;
        case .ChangingLevel:
            changeWaterLevel()
            break;
        }
        
    }
    
    private func increaseWaves() {
        wavesState = .IncreasingAmplitude
        
        changeWavesAmplitudeTo(highWaves)
        NSTimer.scheduledTimerWithTimeInterval(wavesChangingLevelDelay, repeats: false) {
            self.changeWaterLevel()
        }
    }
    
    private func changeWaterLevel() {
        var level = max(Float(doneGoalsCount) / Float(totalGoalsCount), 0.1)
        level = min(Float(doneGoalsCount) / Float(totalGoalsCount), 0.9)
        wavesState = .ChangingLevel
        for fluidView in fluidViews {
            fluidView.fillTo(NSNumber(float: level))
        }
    }
    
    private func decreaseWaves() {
        if wavesState != .ChangingLevel {
            return
        }
        self.wavesState = .DecreasingAmplitude
        
        NSTimer.scheduledTimerWithTimeInterval(wavesChangingLevelDelay,
                                               repeats: false) { [weak self] in
                                                if self!.wavesState == .DecreasingAmplitude {
                                                    
                                                    self!.changeWavesAmplitudeTo(self!.lowWaves)
                                                    
                                                    if self!.doneGoalsCount == self!.totalGoalsCount && self!.doneGoalsCount > 0 {
                                                        self!.showCheckmark()
                                                    }
                                                    self!.wavesState = .Stand
                                                    self!.previousWavesStoppedLevel = CGFloat(self!.doneGoalsCount) / CGFloat(self!.totalGoalsCount)
                                                }
        }
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
                self!.decreaseWaves()
            }
            insertSubview(fluidView, atIndex: 0)
            fluidViews.append(fluidView)
        }
        changeWavesAmplitudeTo(lowWaves)
    }
    
    private func changeWavesAmplitudeTo(parameters:WaveAmplitudes) {
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