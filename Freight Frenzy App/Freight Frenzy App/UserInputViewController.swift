//
//  UserInputViewController.swift
//  Freight Frenzy App
//
//  Created by Macbook on 26/11/21.
//

import UIKit
import CoreLocation

class UserInputViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        // Request User permission to access location
        locationManager.requestWhenInUseAuthorization()

    }
    
    
    // Handle Team Input Details
    var teamNumber: String = ""
    var teamName: String = ""
    var region: String = ""
    var robotName: String = ""
    
    var locationAdress = ""
    
    var name: String {
        get {return teamName + " " + robotName}
    }

    @IBAction func teamNumberEntered(_ sender: UITextField) {
        teamNumber = sender.text ?? ""
//        print(teamNumber)
    }
    
    @IBAction func teamNameEntered(_ sender: UITextField) {
        teamName = sender.text ?? ""
//        print(teamName)
    }
    
    @IBAction func regionEntered(_ sender: UITextField) {
        region = sender.text ?? ""
    }
    
    // TODO Optional
    @IBAction func robotNameEnteterd(_ sender: UITextField) {
        robotName = sender.text ?? ""
    }

    
    var autonomousScore: Int = 0
    var driverControlledScore: Int = 0
    var endGameScore: Int = 0
    var totalScore: Int = 0
    
    @IBOutlet weak var autonomousLabel: UILabel!
    @IBOutlet weak var driverControlledLabel: UILabel!
    @IBOutlet weak var endGameLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    // Autonomous related UI Elements
    @IBOutlet weak var duckDeliveredSwitch: UISwitch!
    
    @IBOutlet weak var parkingAllianceStorageSwitch: UISwitch!
    @IBOutlet weak var parkingFullyInStorageSwitch: UISwitch!
    @IBOutlet weak var parkedInWarehouseSwitch: UISwitch!
    @IBOutlet weak var parkedFullyInWarehouseSwitch: UISwitch!
    
    @IBOutlet weak var freightFullyInStorageUnitSwitch: UISwitch!
    @IBOutlet weak var freightFullyOnShippingHubSwitch: UISwitch!
    @IBOutlet weak var bonusDuckUsedSwitch: UISwitch!
    @IBOutlet weak var bonusTeamUsedSwitch: UISwitch!
    
    // Autonomous related UI Actions
    @IBAction func duckDelivery(_ sender: UISwitch) {
        if duckDeliveredSwitch.isOn {
            autonomousScore += 10
        }else {
            autonomousScore -= 10
        }
        // Update score lables
        self.updateScoreLables()
    }

    @IBAction func autonomousNavigation(_ sender: UISwitch) {
    
        switch (sender){
        case parkingAllianceStorageSwitch:
            autonomousScore += sender.isOn ? 3 : -3
            
            autonomousScore -= parkingFullyInStorageSwitch.isOn ? 6 : 0
            autonomousScore -= parkedInWarehouseSwitch.isOn ? 5 : 0
            autonomousScore -= parkedFullyInWarehouseSwitch.isOn ? 10 : 0
            
            // reset switches
            parkingFullyInStorageSwitch.isOn = false
            parkedInWarehouseSwitch.isOn = false
            parkedFullyInWarehouseSwitch.isOn = false
            break
        case parkingFullyInStorageSwitch:
            autonomousScore += sender.isOn ? 6 : -6
            
            autonomousScore -= parkingAllianceStorageSwitch.isOn ? 3 : 0
            autonomousScore -= parkedInWarehouseSwitch.isOn ? 5 : 0
            autonomousScore -= parkedFullyInWarehouseSwitch.isOn ? 10 : 0
            
            // reset switches
            parkingAllianceStorageSwitch.isOn = false
            parkedInWarehouseSwitch.isOn = false
            parkedFullyInWarehouseSwitch.isOn = false
            break
        case parkedInWarehouseSwitch:
            autonomousScore += sender.isOn ? 5 : -5
            
            autonomousScore -= parkingAllianceStorageSwitch.isOn ? 3 : 0
            autonomousScore -= parkingFullyInStorageSwitch.isOn ? 6 : 0
            autonomousScore -= parkedFullyInWarehouseSwitch.isOn ? 10 : 0
            
            // reset switches
            parkingAllianceStorageSwitch.isOn = false
            parkingFullyInStorageSwitch.isOn = false
            parkedFullyInWarehouseSwitch.isOn = false
            break
        case parkedFullyInWarehouseSwitch:
            autonomousScore += sender.isOn ? 10 : -10
            
            autonomousScore -= parkingAllianceStorageSwitch.isOn ? 3 : 0
            autonomousScore -= parkingFullyInStorageSwitch.isOn ? 6 : 0
            autonomousScore -= parkedInWarehouseSwitch.isOn ? 5 : 0
            
            // reset switches
            parkingAllianceStorageSwitch.isOn = false
            parkingFullyInStorageSwitch.isOn = false
            parkedInWarehouseSwitch.isOn = false
            break
        default: break
        }
        // update labels
        self.updateScoreLables()
    }
    
    @IBAction func freightAction(_ sender: UISwitch) {
        switch(sender){
        case freightFullyInStorageUnitSwitch:
            autonomousScore += sender.isOn ? 2 : -2
            break
        case freightFullyOnShippingHubSwitch:
            autonomousScore += sender.isOn ? 6 : -6
            break
        default:
            break
        }
        
        self.updateScoreLables()
    }
    
    
    @IBAction func autonomousBonus(_ sender: UISwitch) {
        switch(sender){
        case bonusDuckUsedSwitch:
            autonomousScore += 10
            
            autonomousScore -= bonusTeamUsedSwitch.isOn ? 20 : 0
            bonusTeamUsedSwitch.isOn = false
            break
        case bonusTeamUsedSwitch:
            autonomousScore += 20
            
            autonomousScore -= bonusDuckUsedSwitch.isOn ? 10 : 0
            bonusDuckUsedSwitch.isOn = false
            break
        default:
            break
        }
        
        self.updateScoreLables()
    }
    
    // DRIVER CONTROLLED RELATED UI Elements
    @IBOutlet weak var freightInStorageStepper: UIStepper!
    @IBOutlet weak var hubLv1Stepper: UIStepper!
    @IBOutlet weak var hubLv2Stepper: UIStepper!
    @IBOutlet weak var hubLv3Stepper: UIStepper!
    @IBOutlet weak var freightInSharedStepper: UIStepper!
    @IBOutlet weak var inStorageCount: UILabel!
    @IBOutlet weak var inHubLv1Count: UILabel!
    @IBOutlet weak var inHubLv2Count: UILabel!
    @IBOutlet weak var inHubLv3Count: UILabel!
    @IBOutlet weak var inSharedCount: UILabel!
    
    @IBAction func driverControlledAction(_ sender: UIStepper){
        let storage = Int(freightInStorageStepper.value)  // 1 point
        let shared = Int(freightInSharedStepper.value)  // 2 points
        let hub1 = Int(hubLv1Stepper.value)  // 4 points
        let hub2 = Int(hubLv2Stepper.value)  // 6 points
        let hub3 = Int(hubLv3Stepper.value)  // 4 points
        
        inStorageCount.text = String(storage)
        inSharedCount.text = String(shared)
        inHubLv1Count.text = String(hub1)
        inHubLv2Count.text = String(hub2)
        inHubLv3Count.text = String(hub3)
        
        driverControlledScore = storage + (shared * 2) + ((hub1 + hub3) * 4) + (hub2 * 6)
        
        self.updateScoreLables()
    }
    
    // DRIVER CONTROLLED RELATED UI Elements
    @IBOutlet weak var ducksDeliveredStepper: UIStepper!
    @IBOutlet weak var ducksDeliveredCount: UILabel!
    @IBOutlet weak var hubTippedSwitch: UISwitch!
    @IBOutlet weak var hubBalancedSwitch: UISwitch!
    @IBOutlet weak var hubCappedSwitch: UISwitch!
    @IBOutlet weak var endGameParkingInWarehouseSwitch: UISwitch!
    @IBOutlet weak var endGameParkingFullyInWareHouseSwitch: UISwitch!
    
    // score variables for sub stages in end Game stage
    private var carouselDeliveryPoints: Int = 0
    private var hubPoints: Int = 0
    private var parkingPoints: Int = 0

    @IBAction func ducksDeliveredChanged(_ sender: UIStepper) {
        let stepperValue = Int(ducksDeliveredStepper.value)
        
        ducksDeliveredCount.text = String(stepperValue)
        
        carouselDeliveryPoints = stepperValue * 6
        updateScoreLables()
    }
    
    @IBAction func shippingHubEndGameAction (_ sender: UISwitch){
        switch sender {
        case hubTippedSwitch:
            // Add the hub points while checking if the switches are on/off for each related switch
            hubPoints += hubTippedSwitch.isOn ? 20 : -20

            break
        case hubCappedSwitch:
            hubPoints += hubCappedSwitch.isOn ? 15 : -15
            break
        case hubBalancedSwitch:
            hubPoints += hubBalancedSwitch.isOn ? 10 : -10
            break
        default:
            break
        }
        
        updateScoreLables()
    }
    
    
    @IBAction func parkingEndGameAction (_ sender: UISwitch) {
        switch sender {
        case endGameParkingInWarehouseSwitch:
            parkingPoints += endGameParkingInWarehouseSwitch.isOn ? 3:-3
            parkingPoints += endGameParkingFullyInWareHouseSwitch.isOn ? -6 : 0
            
            endGameParkingFullyInWareHouseSwitch.isOn = false
            break
        case endGameParkingFullyInWareHouseSwitch:
            parkingPoints += endGameParkingFullyInWareHouseSwitch.isOn ? 6 : -6
            parkingPoints += endGameParkingInWarehouseSwitch.isOn ? -3:0
            
            endGameParkingInWarehouseSwitch.isOn = false
            break
        default:
            break
        }
        
        updateScoreLables()
    }
    
    func updateScoreLables(){
        endGameScore = carouselDeliveryPoints + hubPoints + parkingPoints
        
        totalScore = autonomousScore + driverControlledScore + endGameScore
        
        // Update Label texts
        autonomousLabel.text = String(autonomousScore)
        driverControlledLabel.text = String(driverControlledScore)
        endGameLabel.text = String(endGameScore)
        totalScoreLabel.text = String(totalScore)
        
    }
    
    // Save the score and team details
    @IBAction func saveAction(_ sender: Any) {
        // check if location information was given by user
        if region == "" {
            region = locationAdress
        }

        let newScore = Score(teamId: teamNumber, autonomous: String(autonomousScore), driverControlled: String(driverControlledScore), endGame: String(endGameScore), totalScore: String(totalScore), location: region)
            
        let newTeam = Team(id: teamNumber, name: teamName, location: region, date: "")
        
        // TODO prompt message to ask if user wants to submit their score
        let alert = UIAlertController(title: "Alert", message: "Do you wish to upload your score?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {(action) in
            // Send API Requests and handle errors
            DataManager.shared.uploadScoreDetails(newScore)
            DataManager.shared.uploadTeamDetails(newTeam)
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: {(action) in
            // Just add the score and team to data manager and core data
            
            DataManager.shared.addNewTeam(newTeam)
            DataManager.shared.addNewScore(newScore)
        }))
        
        // shows alert to screen
        self.present(alert, animated: true)


    }

    
    
    // Alert functions
    
    func showErrorAlert(message text: String){
        let alert = UIAlertController(title: "Error", message: "Data could not be uploaded: " + text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
        
        self.present(alert, animated: true)
    }

    func showSuccessAlert(message text: String){
        let alert = UIAlertController(title: "Success", message: "Message: " + text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
        
        self.present(alert, animated: true)
    }
    /*
     // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     
     }
     */
}

extension UserInputViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get current location
        let location = locations[0] as CLLocation
        
        // latitude and longitude
//        let latitude = location.coordinate.latitude
//        let longitute = location.coordinate.longitude
        
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            if (error != nil) {
                print ("There is an error in reversing the geocoder")
            }else {
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    
                    let locality = placemark.locality ?? ""
                    let administrativeArea = placemark.administrativeArea ?? ""
                    let country = placemark.country ?? ""
                    
                    self.locationAdress = locality + ", " + administrativeArea + ", " + country
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            manager.startUpdatingLocation()
        }
    }
}
