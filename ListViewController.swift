//
//  ListViewController.swift
//  ibeacon
//
//  Created by Stefano Cicero on 01/11/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tbc:TabBarViewController!
    var beacons:[beacon]!
    var counter = 0

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBAction func homeButton(_ sender: Any)
    {
        tbc.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*for beacon in beacons
        {
            if(tbc.searchVBeacon(minor: beacon.minor, major: beacon.major) > -1)
            {
                counter += 1
            }
        }*/
        //navBarTitle.title = "Visited \(counter) of \(beacons.count) objects"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return beacons.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : ObjectTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ObjectTableViewCell
        
        cell.nameCell?.text = "\(beacons[indexPath.row].seqNum!): \(beacons[indexPath.row].name!)"
        
        if(tbc.searchVBeacon(minor: beacons[indexPath.row].minor, major: beacons[indexPath.row].major) > -1)
        {
            counter += 1
            cell.imgCell?.image = UIImage(named: "Check")
        }
        else
        {
            cell.imgCell?.image = UIImage(named: "Uncheck")
        }
        
        if(indexPath.row == (beacons.count-1))
        {
            navBarTitle.title = "Visited \(counter) of \(beacons.count) exhibits"
        }
        return cell
    }
    
    func update()
    {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

class ObjectTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    
    
}
