//
//  HIghScoreRecordsViewController.swift
//  Freight Frenzy App
//
//  Created by Macbook on 26/11/21.
//

import UIKit

class HIghScoreRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
//    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // assigns the data source and delegate to conform with the delegate and datasource protocols for the Table view
        self.configureTableView()
    }
    
    // Reloads the view when we navigate back to view controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView!.dataSource = self
        tableView!.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Sets a custom header and sets a custom title for the tableview section which is just one
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // A view is used and placed within the section header
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        header.backgroundColor = .white
        
        // custom title to be placed within the header view
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: header.frame.size.width, height: header.frame.size.height))
        
        header.addSubview(label)
        label.text = "High Scores"
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        return header
    }
    
    // Sets the height of the section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Sets how many items to be displayed in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.highScores.count
    }
    
    // Describes what to be displayed in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + " TeamId: " +  DataManager.shared.highScores[indexPath.row].tid + "  Score: " + DataManager.shared.highScores[indexPath.row].total
        
        return cell
    }
    
    // executes when user interacts with the cell i.e. user taps a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("You clicked this")
    }

    // Send the single record view its needed data for initial load
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPaths = tableView.indexPathsForSelectedRows! as NSArray
        let indexPath = indexPaths[0] as! IndexPath
        let vc = segue.destination as! SIngleRecordViewController
        vc.score = DataManager.shared.highScores[indexPath.row]
    }
}
