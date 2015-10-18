//
//  MasterViewController.swift
//  Göl
//
//  Created by Ian Wolterstorff17 on 10/17/15.
//  Copyright (c) 2015 Ian Wolterstorff17. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var leagueArray: [League] = []


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as! DetailViewController
        }
        Alamofire.request(.GET, "http://api.football-data.org/alpha/soccerseasons", parameters: ["X-Auth-Token": "9baf91d5c96648a29b320517ef5408d3"])
            .responseJSON { response in
                if let json = response.result.value {
                    NSLog("Succeeded fetching from network")
                    let json = JSON(json)
                    for (key,SubJson):(String, JSON) in json {
                        self.leagueArray.append(League(json: SubJson))
                    }
                    self.tableView.reloadData()
                
                } } }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                let object = leagueArray[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        //let object = objects[indexPath.row] as! NSDate
        let object = leagueArray[indexPath.row]
        //cell.textLabel!.text = object.description
        cell.imageView!.image = UIImage(named: object.country)
        cell.textLabel!.text = object.caption
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}



class League: AnyObject {
    var country: String! = nil
    var caption: String! = nil
    var teams = [Team]()
    
    init(json: JSON) {
        caption = json["caption"].string
        if caption!.rangeOfString("Bundesliga") != nil {
            country = "Germany"
        }
        else if caption!.rangeOfString("Ligue") != nil {
            country = "France"
        }
        else if caption!.rangeOfString("Premier League") != nil {
            country = "England"
        }
        else if caption!.rangeOfString("Division") != nil {
            country = "Spain"
        }
        else if caption!.rangeOfString("Serie A") != nil {
            country = "Italy"
        }
        else if caption!.rangeOfString("Primeira Liga") != nil {
            country = "Portugal"
        }
        else if caption!.rangeOfString("Eredivisie") != nil {
            country = "Netherlands"
        }
        else if caption!.rangeOfString("Champions League") != nil {
            country = "European-Union"
        }
        else {
            country = "Unknown"
        }
    }
}
class Team: AnyObject {
    var league: League
    var name: String!
    var crestUrl: String!
    
    init(json: JSON, league: League) {
        self.league = league
        self.name = json["name"].string
        self.crestUrl = json["crestUrl"].string
    }
}
