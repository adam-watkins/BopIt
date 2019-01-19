//
//  MenuViewController.swift
//  BopIt
//
//  Created by Adam on 2018-03-01.
//  Copyright © 2018 Adam. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 1, animations: {
            self.difficultyControl.center.y -= self.view.bounds.height
            self.titleLabel.center.y -= self.view.center.y
            self.titleLabel.center.y += self.titleLabel.bounds.height / 2
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.startButton.center.x += self.view.bounds.width
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: "startGame", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        if difficultyControl.selectedSegmentIndex == 0 {
            gameVC.gameData = GameModel(difficulty: .Easy)
        }
        else if difficultyControl.selectedSegmentIndex == 1 {
            gameVC.gameData = GameModel(difficulty: .Medium)
        }
        else {
            gameVC.gameData = GameModel(difficulty: .Hard)
        }
    }
}
