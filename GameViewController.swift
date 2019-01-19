//
//  GameViewController.swift
//  BopIt
//
//  Created by Adam on 2018-03-01.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gestureImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var sequenceProgress: UIProgressView!
    @IBOutlet weak var gameStateLabel: UILabel!
    
    var gameData = GameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Single Fingure swipe
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        upSwipe.direction = .up
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        rightSwipe.direction = .right
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        downSwipe.direction = .down
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        leftSwipe.direction = .left
       
        self.view.addGestureRecognizer(upSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(downSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        //Double Fingure swipe
        let twoFingerUpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        twoFingerUpSwipe.direction = .up
        twoFingerUpSwipe.numberOfTouchesRequired = 2
        let twoFingerRightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        twoFingerRightSwipe.direction = .right
        twoFingerRightSwipe.numberOfTouchesRequired = 2
        let twoFingerDownSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        twoFingerDownSwipe.direction = .down
        twoFingerDownSwipe.numberOfTouchesRequired = 2
        let twoFingerLeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        twoFingerLeftSwipe.direction = .left
        twoFingerLeftSwipe.numberOfTouchesRequired = 2

        self.view.addGestureRecognizer(twoFingerUpSwipe)
        self.view.addGestureRecognizer(twoFingerRightSwipe)
        self.view.addGestureRecognizer(twoFingerDownSwipe)
        self.view.addGestureRecognizer(twoFingerLeftSwipe)
        
        //Pinch
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        sequenceProgress.progress = 0
        displaySequence()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if gestureImage.isHidden {
            if motion == .motionShake {
                if gameData.currentGestureInSequence.name == "Shake" {
                    correctGesuture()
                }
                else {
                    wrongGesture()
                }
            }
        }
    }
    
    @objc func swipeHandler(sender: UISwipeGestureRecognizer) {
        if gestureImage.isHidden {
            if type(of: gameData.currentGestureInSequence) != Swipe.self {
                wrongGesture()
            }
            else if sender.direction.rawValue == (gameData.currentGestureInSequence as! Swipe).directionValue && sender.numberOfTouchesRequired == (gameData.currentGestureInSequence as! Swipe).touchesRequired {
                correctGesuture()
            }
            else {
                wrongGesture()
            }
        }
    }
    
    @objc func pinchHandler(sender: UIPinchGestureRecognizer) {
        if gestureImage.isHidden {
            if sender.state == .ended {
                if sender.scale > 1.0 && gameData.currentGestureInSequence.name == "OutwardPinch" {
                    correctGesuture()
                }
                else if sender.scale < 1.0 && gameData.currentGestureInSequence.name == "InwardPinch" {
                    correctGesuture()
                }
                else {
                    print(sender.scale)
                    print(gameData.currentGestureInSequence.name)
                    wrongGesture()
                }
            }
        }
    }
    
    func correctGesuture() {
        print("Correct")
        gameData.score += 1
        scoreLabel.text = "Score: \(gameData.score)"
        sequenceProgress.progress += 1 / Float(gameData.gestureSequence.count)
        if !gameData.nextGestureInSequence() {
            print("Next Level")
            gameData.addGestureToSequence()
            gameData.resetSequence()
            displaySequence()
            sequenceProgress.progress = 0
        }
    }
    
    func wrongGesture() {
        print("Fail")
        performSegue(withIdentifier: "gameOver", sender: self)
    }
    
    func displaySequence()
    {
        //Display animated sequence
        gameStateLabel.text = "Memorize The Sequence"
        print("Starting Sequence withImages: \(gameData.gestureSequence.count) difficulty: \(gameData.difficulty)")
        gestureImage.isHidden = false;
        gestureImage.animationImages = gameData.gestureSequenceAnimation
        gestureImage.animationDuration = gameData.annimationDuration()
        gestureImage.animationRepeatCount = 1
        gestureImage.startAnimating()
        
        //Hide animation when done
        Timer.scheduledTimer(withTimeInterval: gameData.annimationDuration(), repeats: false) { (timer) in
            self.gestureImage.isHidden = true
            self.gameStateLabel.text = "Enter The Sequence"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameOverVC = segue.destination as! GameOverViewController
        gameOverVC.score = gameData.score
        gameOverVC.difficulty = gameData.difficulty
    }
 }
