//
//  GameModel.swift
//  BopIt
//
//  Created by Adam on 2018-03-01.
//  Copyright © 2018 Adam. All rights reserved.
//

import Foundation
import UIKit

class GameModel {
    
    enum Difficulty {
        case Easy, Medium, Hard
    }
    
    var gestures: [Gesture]
    var score: Int
    var gestureSequence: [Gesture]
    var gestureSequenceAnimation: [UIImage]
    var currentGestureInSequence: Gesture
    var annimationSpeed: Double
    private var sequencePosition: Int
    let difficulty: Difficulty
    
    init(difficulty: Difficulty = .Easy, annimationSpeed: Double = 0.8) {
        self.difficulty = difficulty
        self.annimationSpeed = annimationSpeed
        
        gestures = [
            Swipe(name: "Up", longName: "Swipe Up", imageName: "Up", directionValue: 4),
            Swipe(name: "Right", longName: "Swipe Right", imageName: "Right", directionValue: 1),
            Swipe(name: "Down", longName: "Swipe Down", imageName: "Down", directionValue: 8),
            Swipe(name: "Left", longName: "Swipe Left", imageName: "Left", directionValue: 2)
        ]
        
        if difficulty == .Medium || difficulty == .Hard {
            gestures.append(Gesture(name: "InwardPinch", longName: "Inward Pich", imageName: "InwardPinch"))
            gestures.append(Gesture(name: "OutwardPinch", longName: "Outward Pich", imageName: "OutwardPinch"))
        }
        
        if difficulty == .Hard {
            gestures.append(Gesture(name: "Shake", longName: "Shake", imageName: "Shake"))
            gestures.append(Swipe(name: "Up2", longName: "Two Finger Swipe Up", imageName: "Up2", directionValue: 4, touchesRequired: 2))
            gestures.append(Swipe(name: "Right2", longName: "Two Finger Swipe Right", imageName: "Right2", directionValue: 1, touchesRequired: 2))
            gestures.append(Swipe(name: "Down2", longName: "Two Finger Swipe Down", imageName: "Down2", directionValue: 8, touchesRequired: 2))
            gestures.append(Swipe(name: "Left2", longName: "Two Finger Swipe Left", imageName: "Left2", directionValue: 2, touchesRequired: 2))
        }
        
        score = 0
        sequencePosition = 0
        gestureSequence = [gestures[Int(arc4random_uniform(UInt32(gestures.count)))]]
        currentGestureInSequence = gestureSequence[0]
        gestureSequenceAnimation = [currentGestureInSequence.image]
        
    }
    
    private func randomGesture() -> Gesture {
        return gestures[Int(arc4random_uniform(UInt32(gestures.count)))]
    }
    
    func addGestureToSequence() {        
        //Two of the same gustures can't be in a row
        var newGesture = randomGesture()
        while newGesture.name == gestureSequence.last?.name {
            newGesture = randomGesture()
        }
        
        gestureSequence.append(newGesture)
        gestureSequenceAnimation.append(gestureSequence.last!.image)
    }
    
    func nextGestureInSequence() -> Bool {
        sequencePosition += 1
        if sequencePosition < gestureSequence.count {
            currentGestureInSequence = gestureSequence[sequencePosition]
            return true
        }
        else {
            return false
        }
    }
    
    func resetSequence() {
        sequencePosition = 0
        currentGestureInSequence = gestureSequence[0]
    }
    
    func annimationDuration() -> Double {
        return Double(gestureSequence.count) * annimationSpeed
    }
}

class Gesture {
    let name: String
    let image: UIImage
    let longName: String
    
    init(name: String, longName: String, imageName: String = "Default") {
        self.name = name
        self.longName = longName
        self.image = UIImage(named: imageName)!
    }
}

class Swipe: Gesture {
    let directionValue: Int
    let touchesRequired: Int
    
    init(name: String, longName: String, imageName: String, directionValue: Int, touchesRequired: Int = 1) {
        self.directionValue = directionValue
        self.touchesRequired = touchesRequired
        super.init(name: name, longName: longName, imageName: imageName)
    }
}
