//
//  GameOverViewController.swift
//  BopIt
//
//  Created by Adam on 2018-03-06.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit
import CoreData

class GameOverViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    var score: Int = 0
    var difficulty: GameModel.Difficulty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.text = "Score: \(score)"
        setHighScoreLabel()
    }
    
    @IBAction func tryAgainButtonHit(_ sender: UIButton) {
        performSegue(withIdentifier: "tryAgain", sender: self)
    }    
    
    @IBAction func menuButtonHit(_ sender: UIButton) {
        performSegue(withIdentifier: "mainMenu", sender: self)
    }
    
    func setHighScoreLabel() {
        let difficultyString: String
        if difficulty == GameModel.Difficulty.Easy {
            difficultyString = "Easy"
        }
        else if difficulty == GameModel.Difficulty.Medium {
            difficultyString = "Medium"
        }
        else {
            difficultyString = "Hard"
        }
        
        let fetchRequest: NSFetchRequest<HighScore> = HighScore.fetchRequest()
        do {
            let highScore = try PersistenceService.context.fetch(fetchRequest)
            
            for score in highScore {
                if difficultyString == score.difficulty {
                    if self.score > score.score {
                        PersistenceService.context.delete(score)
                        newHighScore(difficultyString: difficultyString)
                    }
                    else {
                        highScoreLabel.text = "\(difficultyString) High Score: \(score.score)"
                    }
                    
                    return
                }
            }
            
           newHighScore(difficultyString: difficultyString)
            
        } catch {}
    }
    
    func newHighScore(difficultyString: String) {
        highScoreLabel.text = "\(difficultyString) High Score: \(self.score)"
        let newHighScore = HighScore(context: PersistenceService.context)
        newHighScore.score = Int16(self.score)
        newHighScore.difficulty = difficultyString
        PersistenceService.saveContext()
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tryAgain" {
            let gameVC = segue.destination as! GameViewController
            gameVC.gameData = GameModel(difficulty: difficulty)
        }
    }
}
