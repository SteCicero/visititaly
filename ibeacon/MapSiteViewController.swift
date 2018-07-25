//
//  MapSiteViewController.swift
//  test con le viste
//
//  Created by Stefano Cicero on 28/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit

class MapSiteViewController: UIViewController {
    
    var tbc:TabBarViewController!
    
    var beacons:[beacon]!
    var buttons = [UIButton]()
    var nearestBeacon:beacon!
    var mapUrl:String?
    
    var nbutton:UIButton!
    
    var timer = Timer()
    
    @IBOutlet weak var titleView: UINavigationItem!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapBgImage: UIImageView!
    
    @IBAction func homeButton(_ sender: Any)
    {
        tbc.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.async() { () -> Void in
            self.mapBgImage.image = self.tbc.siteView.imgView.image
        }
        
        // Do any additional setup after loading the view.
        
        //effetto sfondo sfuocato
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.mapBgImage.addSubview(blurEffectView)
        
        
        //scarico la mappa
        tbc.loadImageFromStrUrl(inUrl: mapUrl!, targetImg: mapImage)
        
        //disegno i beacon sulla mappa
        drawButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        titleView.title = (nearestBeacon?.seqNum)! + ": " + (nearestBeacon?.name)!
    }
    
    func buttonAction(sender: UIButton!)
    {
        
        let btTitle = buttons[buttons.index(of: sender)!].currentTitle
        
        for beacon in beacons
        {
            if(beacon.seqNum == btTitle)
            {
                titleView.title = beacon.seqNum + ": " + beacon.name
                break
            }
        }
    }
    
    func blinkButton()
    {
        if(nbutton.backgroundColor == .orange)
        {
            nbutton.backgroundColor = .gray
        }
        else
        {
            nbutton.backgroundColor = .orange
        }
    }
    
    //aggiornamento in caso solo di cambio beacon con stesso sottosito
    func updatenb()
    {
        timer.invalidate()
        for button in buttons
        {
            if(button.backgroundColor == .orange || button.backgroundColor == .gray)
            {
                button.backgroundColor = .green
            }
            else if(button.title(for: .normal) == nearestBeacon?.seqNum)
            {
                button.backgroundColor = .orange
                titleView.title = nearestBeacon?.name
                nbutton = button
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(MapSiteViewController.blinkButton), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    //aggiornamento in caso di cambio di sottosito
    func update()
    {
        tbc.loadImageFromStrUrl(inUrl: mapUrl!, targetImg: mapImage)
        deleteAllButtons()
        drawButtons()
    }
    
    //disegna tutti i bottoni
    func drawButtons()
    {
        var button:UIButton!
        for beacon in beacons
        {
            button = UIButton(frame: CGRect(x: Int(beacon.pos_x)!, y: Int(beacon.pos_y)!, width: 26, height: 26))
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            if(beacon.isEqual(beacon: nearestBeacon!))
            {
                button.backgroundColor = .orange
                titleView.title = beacon.name
                nbutton = button
                timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(MapSiteViewController.blinkButton), userInfo: nil, repeats: true)
            }
            else
            {
                if(tbc.searchVBeacon(minor: beacon.minor, major: beacon.major) >= 0)
                {
                    button.backgroundColor = .green
                }
                else
                {
                    button.backgroundColor = .red
                }
            }
            button.setTitle(beacon.seqNum, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            buttons.append(button)
            self.view.addSubview(button)
        }
    }
    
    //cancella tutti i bottoni
    func deleteAllButtons()
    {
        while buttons.count > 0
        {
            self.view.subviews.last?.removeFromSuperview()
            buttons.removeLast()
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
