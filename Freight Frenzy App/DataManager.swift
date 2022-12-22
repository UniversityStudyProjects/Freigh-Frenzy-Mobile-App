//
//  DataManager.swift
//  Freight Frenzy App
//
//  Created by Macbook on 24/11/21.
//

import UIKit
import CoreData


class DataManager: NSObject {

    // singleton instance object
    static let shared = DataManager()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // LOCAL DATA
    private var storedTeams = [Team]() // Stores team details entered by current user
    private var storedScores = [Score]() // Stores scores by current user's teams
//    private var loadedScores = [Score]() // Stores Score details loaded via the API
//    private var loadedTeams = [Team]() // Stores Team details loaded via the API
    
    private var downloadedHighScores = [Score]()
    private var downloadedTeams = [Team]()
    
    private var uploadFlag: Bool = false // flag for whether to submit score or not
    
    var errorMessage = ""
    override init() {
        super.init()
        
        downloadTeams()
        downloadHighScores()
        loadScoresFromCoreData()
        loadTeamsFromCoreData()
    }
    
    var teams: [Team]{
        get{return storedTeams}
    }
    
    var scores: [Score]{
        get {return storedScores}
    }
    
    var highScores: [Score]{
        get {return downloadedHighScores}
    }
    
    var allTeams: [Team]{
        get {return downloadedTeams}
    }
    
    func loadScoresFromCoreData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            let loadedScores = results as! [NSManagedObject]
            
            for loadedScore in loadedScores {
                let tid = loadedScore.value(forKey: "teamId") as! String
                let automonous = loadedScore.value(forKey: "autonomous") as! String
                let driverControlled = loadedScore.value(forKey: "driverControlled") as! String
                let endGame = loadedScore.value(forKey: "endGame") as! String
                let location = loadedScore.value(forKey: "location") as! String
                let total = loadedScore.value(forKey: "total") as! String


                self.storedScores.append(Score(teamId: tid, autonomous: automonous, driverControlled: driverControlled, endGame: endGame, totalScore: total, location: location))
            }
        }catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
          }
    }
    
    func loadTeamsFromCoreData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Teams")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            let teamResults = results as! [NSManagedObject]
            
            for team in teamResults {
                let date = team.value(forKey: "date") as! String
                let id = team.value(forKey: "id") as! String
                let location = team.value(forKey: "location") as! String
                let name = team.value(forKey: "name") as! String

                self.storedTeams.append(Team(id: id, name: name, location: location, date: date))
            }
        }catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
          }
    }

    
    func addNewTeam(_ team: Team){
        let newTeam = team
        
        newTeam.date = getDate()
        
        
        if !(checkForTeam(newTeam)) {
            // Grab a temporary image
            
            let entity = NSEntityDescription.entity(forEntityName: "Teams", in:managedContext)
            let teamToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            
            teamToAdd.setValue(newTeam.id, forKey: "id")
            teamToAdd.setValue(newTeam.locationCreated, forKey: "location")
            teamToAdd.setValue(newTeam.teamName, forKey: "name")
            teamToAdd.setValue(newTeam.date, forKey: "date")


            // save the managedContext
            do {
              try managedContext.save()
            }
            catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
            
            storedTeams.append(newTeam)


        }
        
    }
    
    func addNewScore (_ score: Score){
        
        let newScore = score
        
            
        let entity = NSEntityDescription.entity(forEntityName: "Scores", in:managedContext)
        let scoreToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        scoreToAdd.setValue(newScore.tid, forKey: "teamId")
        scoreToAdd.setValue(newScore.autonomous, forKey: "autonomous")
        scoreToAdd.setValue(newScore.driver, forKey: "driverControlled")
        scoreToAdd.setValue(newScore.endGame, forKey: "endGame")
        scoreToAdd.setValue(newScore.total, forKey: "total")
        scoreToAdd.setValue(newScore.location, forKey: "location")

        // save the managedContext
        do {
          try managedContext.save()
        }
        catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
        storedScores.append(newScore)

        
    }
    

    func downloadHighScores(){
        let url = NSURL(string: "http://www.partiklezoo.com/freightfrenzy/?")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if (error != nil) { return; }
            if let json = try? JSON(data: data!) {
                for count in 0...json.count - 1 {

                    let teamId = json[count]["teamid"].string!
                    let autonomousScore = json[count]["autonomous"].string!
                    let driverControlledScore = json[count]["drivercontrolled"].string!
                    let endGameScore = json[count]["endgame"].string!
                    let totalScore = json[count]["score"].string!
                    let location = json[count]["location"].string!


                    let newScore = Score(teamId: teamId, autonomous: autonomousScore, driverControlled: driverControlledScore, endGame: endGameScore, totalScore: totalScore, location: location)
                    
                    self.downloadedHighScores.append(newScore)
                    
                }
            
            }
          })
        
        task.resume()
    }
    
    func downloadTeams(){
        let url = NSURL(string: "http://www.partiklezoo.com/freightfrenzy/?action=teams")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if (error != nil) { return; }
            if let json = try? JSON(data: data!) {
                for count in 0...json.count - 1 {

                    let id = json[count]["id"].string!
                    let name = json[count]["name"].string!
                    let date = json[count]["created"].string!
                    let imageLink = json[count]["image"].string!
                    let location = json[count]["location"].string!


                    let newTeam = Team(id: id, name: name, location: location, date: date)
                    
                    self.downloadedTeams.append(newTeam)
                    
                }
            
            }
          })
        
        task.resume()

    }
    
    /**
     Upload Score details via API
     */
    
    func uploadScoreDetails(_ score: Score!){
        let urlString = "https://www.partiklezoo.com/freightfrenzy/?action=addscore&teamid=" + score.tid + "&autonomous=" + score.autonomous + "&drivercontrolled=" + score.driver + "&endgame=" + score.endGame + "&location=" + "score.location"
        let url = URL(string: urlString)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if (error != nil) {return;}
            if let json = try? JSON(data: data!) {
                let result = json["result"].string!

                if result == "error" {
                    let message = json["message"].string!
                    print (message)
                    self.errorMessage = message
                }else {
                    // if successful
//                    let message = json["action"].string!
                    
                    // add the score to data manager and core data
                    DataManager.shared.addNewScore(score)
                    
                }
                
            }
          })
        task.resume()
    }

    /**
     Upload Team details via API
     */
    func uploadTeamDetails(_ team: Team){
        let urlString = "https://www.partiklezoo.com/freightfrenzy/?action=addteam&id=" + team.id + "&name=" + team.teamName + "&location=" + team.locationCreated
        
        let url = URL(string: urlString)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if (error != nil) {return;}
            if let json = try? JSON(data: data!) {
                let result = json["result"].string!

                if result == "error" {
                    let message = json["message"].string!
                    self.errorMessage = message
                }else {
                    // if successful
                    
                    // add the score to data manager and core data
                    DataManager.shared.addNewTeam(team)
                    
                }
                
            }
          })
        task.resume()

    }
    
    /**
     Checks if a team already exists in the current records
     */
    func checkForTeam(_ searchItem: Team) -> Bool {
        var found = false
        
        if (teams.count > 0) {
            for team in teams {
                if (team.id.isEqual(searchItem.id)) {
                    found = true
                }
            }
        }
        
        return found
    }
    
    
    /**
     This function returns the current dat
     */
    func getDate () -> String{
        let date = Date()
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        let hour = String(calendar.component(.hour, from: date))
        let minutes = String(calendar.component(.minute, from: date))
        let seconds = String(calendar.component(.second, from: date))
        
        let dateString = year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds
        print(dateString)
        return dateString
    }
    
    /**
     This functions retrieves a team object from the stored and all teams if found*/
    func retrieveTeam(teamId id: String) -> Team{
        var found = false
        for team in teams {
            if (team.id.isEqual(id)){
                found = true
                return team
            }
        }
        
        if !found {
            for team in allTeams{
                if (team.id.isEqual(id)){
                    return team
                }
            }
        }
        
        return Team(id: "Not available", name: "Not available", location: "Not available", date: "Not available")
        
        
    }
}
