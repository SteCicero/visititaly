//
//  TabBarViewController.swift
//  test con le viste
//
//  Created by Stefano Cicero on 28/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController
{
    var fvc:ViewController!
    
    var siteName:String?
    var siteDescription:String?
    var siteUrlImg:String?
    
    var mapUrl:String?
    var beacons:[beacon]!
    
    var nearestBeacon:beacon!
    
    var siteView:SiteOrDetailViewController!
    var mapView:MapSiteViewController!
    var detailView:SiteOrDetailViewController!
    var listView:ListViewController!
    
    var vminor:[String]!
    var vmajor:[String]!
    var vname:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        siteView = self.viewControllers![0] as! SiteOrDetailViewController
        mapView = self.viewControllers![1] as! MapSiteViewController
        detailView = self.viewControllers![2] as! SiteOrDetailViewController
        listView = self.viewControllers![3] as! ListViewController
        
        if (UserDefaults.standard.object(forKey: "vminor") as? [String]) != nil
        {
            vminor = (UserDefaults.standard.object(forKey: "vminor") as? [String])!
            vmajor = (UserDefaults.standard.object(forKey: "vmajor") as? [String])!
            vname = (UserDefaults.standard.object(forKey: "vmajor") as? [String])!
        }
        else
        {
            vminor=[String]()
            vmajor=[String]()
            vname=[String]()
        }
        
        //salvo permanentemente il beacon più vicino nel caso non lo abbia in lista
        if(searchVBeacon(minor: nearestBeacon.minor, major: nearestBeacon.major)<0)
        {
            vminor.append(nearestBeacon.minor)
            vmajor.append(nearestBeacon.major)
            vname.append(nearestBeacon.name)
            UserDefaults.standard.set(vminor, forKey: "vminor")
            UserDefaults.standard.set(vmajor, forKey: "vmajor")
            UserDefaults.standard.set(vname, forKey: "vname")
        }
        
        siteView.viewTitle = siteName
        siteView.textDescription = siteDescription
        siteView.imgUrl = siteUrlImg
        siteView.tbc = self
        
        mapView.beacons = beacons
        mapView.nearestBeacon = nearestBeacon
        mapView.mapUrl = mapUrl
        mapView.tbc = self
        
        detailView.viewTitle = nearestBeacon?.name
        detailView.textDescription = nearestBeacon?.text
        detailView.imgUrl = nearestBeacon?.imgUrl
        detailView.tbc = self
        
        listView.beacons = beacons
        listView.tbc = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSubViews()
    {
        if(searchVBeacon(minor: nearestBeacon.minor, major: nearestBeacon.major)<0)
        {
            vminor.append(nearestBeacon.minor)
            vmajor.append(nearestBeacon.major)
            vname.append(nearestBeacon.name)
            UserDefaults.standard.set(vminor, forKey: "vminor")
            UserDefaults.standard.set(vmajor, forKey: "vmajor")
            UserDefaults.standard.set(vname, forKey: "vname")
        }
        
        //se il nuovo beacon appartiene ad un altro sito aggiorno i dati del sito da visualizzare
        if(siteView.viewTitle != siteName)
        {
            siteView.viewTitle = siteName
            siteView.textDescription = siteDescription
            siteView.imgUrl = siteUrlImg
            siteView.update()
        }
        
        //se il nuovo beacon appartiene ad un altro sottosito aggiorno i dati del sottosito da visualizzare
        mapView.nearestBeacon = nearestBeacon
        if(mapView.mapUrl != mapUrl)
        {
            mapView.beacons = beacons
            listView.beacons = beacons
            mapView.mapUrl = mapUrl
            if(mapView.isViewLoaded)
            {
                mapView.update()
            }
        }
        else
        {
            if(mapView.isViewLoaded)
            {
                mapView.updatenb()
            }
        }
        
        detailView.viewTitle = nearestBeacon?.name
        detailView.textDescription = nearestBeacon?.text
        detailView.imgUrl = nearestBeacon?.imgUrl
        if(detailView.isViewLoaded)
        {
            detailView.update()
        }
        
        if(listView.isViewLoaded)
        {
            listView.update()
        }
    }
    
    //cerca e trova un beacon già visitato
    func searchVBeacon(minor:String, major:String) -> Int
    {
        if(vminor.count > 0 && vmajor.count > 0)
        {
            var i = 0
            for vm in vminor
            {
                if(minor == vm && major == vmajor[i])
                {
                    return i
                }
                i += 1
            }
            return -1
        }
        else
        {
            return -1
        }
    }
    
    func loadImageFromStrUrl (inUrl: String, targetImg: UIImageView)
    {
        let url = URL(string: inUrl)!
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if (error != nil)
            {
                print(error!)
            }
            else
            {
                if let data = data
                {
                    if let bachImage = UIImage(data: data)
                    {
                        DispatchQueue.main.async() { () -> Void in
                            targetImg.image = bachImage
                        }
                    }
                }
            }
        }
        task.resume()
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
