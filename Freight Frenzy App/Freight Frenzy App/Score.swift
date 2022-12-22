//
//  Score.swift
//  Freight Frenzy App
//
//  Created by Macbook on 24/11/21.
//

import UIKit

class Score: NSObject {
    private var teamId: String = ""
    private var autonomousScore: String = "0"
    private var driverControlledScore: String = "0"
    private var endGameScore: String = "0"
    private var totalScore: String = "0"
    private var locationCreated: String = ""
    
    var tid: String{
        get{return self.teamId}
    }
    
    var autonomous: String{
        get{return self.autonomousScore}
    }
    var driver: String {
        get{return self.driverControlledScore}
    }
    
    var endGame: String{
        get{return self.endGameScore}
    }
    
    var total: String {
        get {return self.totalScore}
    }
    
    var location: String {
        get {return self.locationCreated}
        set {locationCreated = newValue}
    }
    
    init(teamId: String, autonomous: String, driverControlled: String, endGame: String, totalScore: String, location: String) {
        super.init()
        self.teamId = teamId
        self.autonomousScore = autonomous
        self.driverControlledScore = driverControlled
        self.endGameScore = endGame
        self.totalScore = totalScore
        self.locationCreated = location
    }
}
