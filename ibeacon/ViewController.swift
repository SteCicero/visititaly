//
//  ViewController.swift
//  ibeacon
//
//  Created by Stefano Cicero on 12/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit
import KontaktSDK

class ViewController: UIViewController
{
    var beaconManager: KTKBeaconManager!
    var managerBLE: CBCentralManager?
    
    var btOn = false
    var authOk = false
    
    var nearBeacon:ExpressBeacon!           //beacon più vicino da istSize cicli di scansione
    var actualBeacon:ExpressBeacon?         //beacon più vicino attualmente rilevato
    var prevBeacon:ExpressBeacon?           //beacon più vicino precedentemente rilevato
    var istcounter = 0                      //contatore per l'isteresi
    let istSize = 3
    
    
    var tabView:TabBarViewController!
    
    var siteName:String?
    var siteDescription:String?
    var siteUrlImg:String?
    
    var mapUrl:String?
    var beacons = [beacon]()
    var nearestBeacon:beacon?
    
    var detailName:String?
    var detailDescription:String?
    var detailUrlImg:String?
    
    

    var url:URL!
    var urlrequest:URLRequest!
    
    let region = KTKBeaconRegion(proximityUUID: UUID(uuidString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E")!, identifier: "VisitItaly Region")
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var deleteDataButton: UIButton!
    
    
    
    
    @IBAction func helpButton(_ sender: Any)
    {
        
    }
    
    @IBAction func deleteDataButton(_ sender: Any)
    {
        let alertController = UIAlertController(title: "VisitItaly", message:"Are you sure to delete all saved data?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(UIAlertAction) -> Void in self.deleteSavedData()}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func startStopMonitoring(_ sender: AnyObject)
    {
        if (startStopButton.currentTitle == "STOP")
        {
            stopRangingAndMonitoring()
        }
        else
        {
            checkAndStartMonitoring()
        }
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bluetoothStatus()
        beaconManager = KTKBeaconManager(delegate: self)
        region.notifyEntryStateOnDisplay=true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning")
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "goToTabBarView")
        {
            tabView = segue.destination as? TabBarViewController
            tabView.fvc = self
            
            tabView.siteName = siteName
            tabView.siteUrlImg = siteUrlImg
            tabView.siteDescription = siteDescription
            
            tabView.mapUrl = mapUrl
            tabView.beacons = beacons
            
            tabView.nearestBeacon = nearestBeacon
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        stopRangingAndMonitoring()
        tabView = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    func checkAndStartMonitoring()
    {
        print("\(authOk) \(btOn)")
        if(authOk && btOn)
        {
            if KTKBeaconManager.isMonitoringAvailable()
            {
                //beaconManager.stopMonitoring(for: region)
                beaconManager.startMonitoring(for: region)
                helpButton.alpha = 0
                mapButton.alpha = 0
                deleteDataButton.alpha = 0
                startStopButton.setTitle("STOP", for: UIControlState.normal)
                statusLabel.text = "Scanning..."
            }
            else
            {
                print("Monitoring not available")
            }
            
        }
        else
        {
            if(!authOk)
            {
                statusLabel.text="Please enable background geolocation for this application"
            }
            else if(!btOn)
            {
                statusLabel.text="Please enable Bluetooth to begin"
            }
            //logTextView.text.append("\nBluetooth off or missing authorization")
            print("Bluetooth off or missing authorization")
        }
    }
    
    func stopRangingAndMonitoring()
    {
        print("Stopping monitoring \(region.identifier)")
        //logTextView.text.append("\nStopping monitoring \(region.identifier)")
        beaconManager.stopRangingBeacons(in: region)
        beaconManager.stopMonitoring(for: region)
        statusLabel.text="Standby"
        
        //resetto la seconda vista e i dati sui beacon
        nearBeacon = nil
        actualBeacon = nil
        prevBeacon = nil
        
        startStopButton.setTitle("START", for: UIControlState.normal)
        helpButton.alpha = 1
        mapButton.alpha = 1
        deleteDataButton.alpha = 1

    }
    
    //calcola il beacon più vicino...
    func findNewNearestBeacon(beacons: [CLBeacon]) -> Bool
    {
        var min = DBL_MAX
        var index:Int? = nil
        for beacon in beacons
        {
            //if(beacon.accuracy > 0 && beacon.accuracy < min && checkInDb(beacon: beacon))
            if(beacon.accuracy > 0 && beacon.accuracy < min)
            {
                min = beacon.accuracy
                index = beacons.index(of: beacon)
            }
        }
        if(index == nil)
        {
            return false
        }
        

        print("The nearest beacon is the one with Major:\(beacons[index!].major) Minor:\(beacons[index!].minor) Distance:\(Double(round(1000*beacons[index!].accuracy)/1000))m")
        
        
        if(actualBeacon == nil)
        {
            actualBeacon = ExpressBeacon(puuid: beacons[index!].proximityUUID, major: beacons[index!].major as Int, minor: beacons[index!].minor as Int)
        }
        else
        {
            actualBeacon?.puuid = beacons[index!].proximityUUID
            actualBeacon?.major = beacons[index!].major as Int
            actualBeacon?.minor = beacons[index!].minor as Int
        }
        
        
        if(prevBeacon == nil)
        {
            prevBeacon = ExpressBeacon(puuid: beacons[index!].proximityUUID, major: beacons[index!].major as Int, minor: beacons[index!].minor as Int)
            istcounter += 1
        }
        else
        {
            if(actualBeacon?.isEqual(beacon: prevBeacon!))!     //beacon uguale a quello precedente
            {
                istcounter += 1
            }
            else                                                //beacon diverso dal precedente -> resetto il contatore
            {
                istcounter = 0
            }
            //assegno al beacon precedente quello attuale
            prevBeacon?.puuid = actualBeacon?.puuid
            prevBeacon?.major = actualBeacon?.major
            prevBeacon?.minor = actualBeacon?.minor
        }
        
        if(istcounter == istSize)
        {
            if(nearBeacon == nil)           //nuovo beacon più vicino
            {
                nearBeacon = ExpressBeacon(puuid: (actualBeacon?.puuid)!, major: (actualBeacon?.major)!, minor: (actualBeacon?.minor)!)
                print("Nuovo beacon più vicino")
                istcounter = 0
                return true
            }
            else
            {
                if(!(nearBeacon.isEqual(beacon: actualBeacon!))) //nuovo beacon più vicino
                {
                    nearBeacon.puuid = actualBeacon?.puuid
                    nearBeacon.major = actualBeacon?.major
                    nearBeacon.minor = actualBeacon?.minor
                    print("Nuovo beacon più vicino")
                    istcounter = 0
                    return true
                }
            }
            istcounter = 0
            return false
        }
        
        return false
        //print("Distance: \(Double(round(1000*beacon.accuracy)/1000))m")
    }
    
    func findBeaconLocal(major_found: Int, minor_found: Int) -> Bool
    {
        if(beacons.count > 0)
        {
            for beacon in self.beacons
            {
                if(beacon.major == "\(major_found)" && beacon.minor == "\(minor_found)")
                {
                    self.nearestBeacon = beacon
                    self.detailName = beacon.name
                    self.detailDescription = beacon.text
                    self.detailUrlImg = beacon.imgUrl
                    sendSignal(minor: minor_found, major: major_found)
                    return true
                }
            }
        }
        return false
    }
    
    func findBeaconRemote(major_found: Int, minor_found: Int) -> Bool
    {
        let url = URL(string:"http://www.stefanocicero.it/visititaly/check_beacon.php?major=\(major_found)&minor=\(minor_found)")!
        var found = false
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil)
            {
                print(error!)
            }
            else
            {
                if let urlContent = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                        //beacon trovato nel db remoto
                        if(jsonResult["Response"] as! String == "OK")
                        {
                            let site = jsonResult["Site"] as! [String:Any]
                            self.siteName = (site["name"]! as! String)
                            self.siteDescription = (site["description"] as! String)
                            self.siteUrlImg = (site["img_url"] as! String)
                            
                            let subsite = jsonResult["Subsite"] as! [String:Any]
                            self.mapUrl = (subsite["map_url"] as! String)
                            
                            if let rbeacons = jsonResult["Beacons"] as? [[String: String]]
                            {
                                self.beacons.removeAll()
                                for rbeacon in rbeacons
                                {
                                    self.beacons.append(beacon(major: rbeacon["major"]!, minor: rbeacon["minor"]!, seqNum: rbeacon["seq_num"]!, imgUrl: rbeacon["img_url"]!, text: rbeacon["description"]!, name: rbeacon["name"]!, pos_x: rbeacon["pos_x"]!, pos_y: rbeacon["pos_y"]!))
                                }
                            }
                            for beacon in self.beacons
                            {
                                if(beacon.major == "\(major_found)" && beacon.minor == "\(minor_found)")
                                {
                                    self.nearestBeacon = beacon
                                    self.detailName = beacon.name
                                    self.detailDescription = beacon.text
                                    self.detailUrlImg = beacon.imgUrl
                                    break
                                }
                            }
                            found = true
                        }
                            //beacon non trovato nel db remoto
                        else
                        {
                            print("Beacon not found")
                        }
                        semaphore.signal()
                        //print(jsonResult)
                    }
                    catch
                    {
                        print("JSON Processing Failed")
                    }
                }
            }
        }
        task.resume()
        print("Pre wait")
        semaphore.wait()
        print("Post wait")
        return found
    }

    func deleteSavedData()
    {
        UserDefaults.standard.removeObject(forKey: "vminor")
        UserDefaults.standard.removeObject(forKey: "vmajor")
        UserDefaults.standard.removeObject(forKey: "vname")
        let alertController = UIAlertController(title: "VisitItaly", message:"All data has been deleted", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendSignal(minor:Int, major:Int)
    {
        let url = URL(string:"http://www.stefanocicero.it/visititaly/signal_visited_beacon.php?major=\(major)&minor=\(minor)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil)
            {
                print(error!)
            }
            else
            {
                if data != nil
                {
                    print("Signal Ok")
                }
            }
        }
        task.resume()
    }
    
}


extension ViewController:KTKBeaconManagerDelegate
{
    
    func beaconManager(_ manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus)
    {
        //var authStatus:String
        print("Location authorization status changed")
        //logTextView.text.append("\nLocation authorization status changed\n")
        
        switch KTKBeaconManager.locationAuthorizationStatus()
        {
        case .notDetermined:
            authOk = false
            //authStatus = "Not determined"
            print("Not determined")
            manager.requestLocationAlwaysAuthorization()
            break
        case .denied:
            // No access to Location Services
            authOk = false
            //authStatus = "Denied"
            print("Denied: no access to Location Services")
            manager.requestLocationAlwaysAuthorization()
            break
        case .restricted:
            // No access to Location Services
            authOk = false
            //authStatus = "Restricted"
            print("Restricted: No access to Location Services")
            break
        case .authorizedWhenInUse:
            authOk = true
            //authStatus = "Authorized When In Use"
            print("Authorization when in use granted")
            break
        case .authorizedAlways:
            authOk = true
            //authStatus = "Authorized Always"
            print("If we already have this authorization we will start region monitoring")
            // If we already have this authorization
            // we will start region monitoring
            break
        }
        //authStatusLabel.text = "Authorization status: \(authStatus)"
        
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion)
    {
        // Do something when monitoring for a particular
        // region is successfully initiated
        print("Starting monitoring...\(region.identifier)")
        //logTextView.text.append("\nStarting monitoring \(region.identifier)")
        //print(manager.monitoredRegions)
        manager.requestState(for: region)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: NSError?)
    {
        // Handle monitoring failing to start for your region
        print("Error while monitoring")
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion)
    {
        // Decide what to do when a user enters a range of your region; usually used
        // for triggering a local notification and/or starting a beacon ranging
        print("Entering in region...")
        print("Starting ranging...")
        //logTextView.text.append("\nEntering in region...\nStarting ranging...")
        manager.startRangingBeacons(in: region)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion)
    {
        // Decide what to do when a user exits a range of your region; usually used
        // for triggering a local notification and stoping a beacon ranging
        print("Quitting region...")
        print("Stopping ranging...")
        //logTextView.text.append("\nQuitting region...\nStopping ranging...")
        manager.stopRangingBeacons(in: region)
        tabView.dismiss(animated: true, completion: nil)
        print("Dismiss eseguita")
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion)
    {
        print("Founded \(beacons.count) beacons")
        for beacon in beacons
        {
            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
            //logTextView.text.append("\nRanged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
            print("Distance: \(Double(round(1000*beacon.accuracy)/1000))m")
        }
        
        if(beacons.count > 0)
        {
            let fnbresult = findNewNearestBeacon(beacons: beacons)               //trovo il beacon più vicino
            
            if(fnbresult)
            {
                if(tabView == nil)
                {
                    if(findBeaconLocal(major_found: nearBeacon.major, minor_found: nearBeacon.minor))
                    {
                        performSegue(withIdentifier: "goToTabBarView", sender: self)
                    }
                    else if(findBeaconRemote(major_found: nearBeacon.major, minor_found: nearBeacon.minor))
                    {
                        performSegue(withIdentifier: "goToTabBarView", sender: self)
                    }
                    else
                    {
                        print("Beacon non trovato")
                    }
                }
                else
                {
                    if(findBeaconLocal(major_found: nearBeacon.major, minor_found: nearBeacon.minor))
                    {
                        tabView.siteName = siteName
                        tabView.siteUrlImg = siteUrlImg
                        tabView.siteDescription = siteDescription
                        
                        tabView.mapUrl = mapUrl
                        tabView.beacons = self.beacons
                        
                        tabView.nearestBeacon = nearestBeacon
                        tabView.updateSubViews()
                    }
                    else if(findBeaconRemote(major_found: nearBeacon.major, minor_found: nearBeacon.minor))
                    {
                        tabView.siteName = siteName
                        tabView.siteUrlImg = siteUrlImg
                        tabView.siteDescription = siteDescription
                        
                        tabView.mapUrl = mapUrl
                        tabView.beacons = self.beacons
                        
                        tabView.nearestBeacon = nearestBeacon
                        tabView.updateSubViews()
                    }
                    else
                    {
                        print("Beacon non trovato")
                    }
                }
            }
        }
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion)
    {
        switch state
        {
        case .inside:
            print("Smartphone inside the region \(region.identifier)")
            manager.startRangingBeacons(in: region)
            statusLabel.text="Scanning: region found! Loading info..."
            break
        case .outside:
            print("Smartphone outside the region")
            statusLabel.text="Scanning: no region found"
            break
        case .unknown:
            print("Smartphone in unknown position")
            //statusLabel.text="Determining smartphone position..."
            break
        }
    }
}

//estensione per la verifica delle funzionalità Bluetooth
extension ViewController:CBCentralManagerDelegate
{
    func bluetoothStatus()
    {
        managerBLE = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        switch managerBLE!.state
        {
        case CBManagerState.poweredOff:
            //btStatus.text = "BT status: powered off"
            btOn = false
            print("Powered Off")
        case CBManagerState.poweredOn:
            //btStatus.text = "BT status: powered on"
            btOn = true
            print("Powered On")
        case CBManagerState.unsupported:
            //btStatus.text = "BT status: unsupported"
            btOn = false
            print("Unsupported")
        case CBManagerState.resetting:
            //btStatus.text = "BT status: resetting"
            btOn = false
            print("Resetting")
            fallthrough
        case CBManagerState.unauthorized:
            //btStatus.text = "BT status: unauthorized"
            btOn = false
            print("Unauthorized")
        case CBManagerState.unknown:
            //btStatus.text = "BT status: unknown"
            btOn = false
            print("Unknown")
            //default:
            break;
        }
    }
}

