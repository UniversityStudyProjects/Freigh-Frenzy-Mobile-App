//
//  SIngleRecordViewController.swift
//  Freight Frenzy App
//
//  Created by Macbook on 26/11/21.
//

import UIKit

class SIngleRecordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // load data from Data Manager
        
        self.teamId.text = score.tid
        self.teamName.text = DataManager.shared.retrieveTeam(teamId: score.tid).teamName
        self.location.text = DataManager.shared.retrieveTeam(teamId: score.tid).locationCreated
        
        self.date.text = DataManager.shared.retrieveTeam(teamId: score.tid).date
        
        self.autonomous.text = score.autonomous
        self.driverControlled.text = score.driver
        self.endGame.text = score.endGame
        self.total.text = score.total
        
    }
    
    private var currentScore: Score? = nil
    
    var score: Score{
        get {return currentScore!}
        set {currentScore = newValue}
    }

    @IBOutlet weak var teamId: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var autonomous: UILabel!
    @IBOutlet weak var driverControlled: UILabel!
    @IBOutlet weak var endGame: UILabel!
    @IBOutlet weak var total: UILabel!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
