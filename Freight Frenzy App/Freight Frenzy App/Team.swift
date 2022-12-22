//
//  Team.swift
//  Freight Frenzy App
//
//  Created by Macbook on 24/11/21.
//

import UIKit

class Team: NSObject {
    private var teamId: String = ""
    private var name: String = ""
    private var location: String = ""
    private var dateCreated: String = ""
    private var photo: UIImage = UIImage()
    
    // TODO Getters and Setters
    var image: UIImage {
        get {return photo}
        set {photo = newValue}
    }
    
    var id: String {
        get {return teamId}
    }
    
    var locationCreated: String {
        get {return location}
        set {location = newValue}
    }
    
    var date: String {
        get {return dateCreated}
        set {dateCreated = newValue}
    }
    
    var teamName: String {
        get {return name}
    }
    
    init(id: String, name: String, location: String, date: String, image: UIImage) {
        super.init()
        self.teamId = id
        self.name = name
        self.location = location
        self.dateCreated = date
        self.photo = image
    }
    
    init(id: String, name: String, location: String, date: String) {
        super.init()
        self.teamId = id
        self.name = name
        self.location = location
        self.dateCreated = date
    }
}
