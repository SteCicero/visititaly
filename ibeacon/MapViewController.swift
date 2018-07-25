//
//  MapViewController.swift
//  ibeacon
//
//  Created by Stefano Cicero on 02/11/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func dismissButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        downloadAndDisplaySites()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        
        let userLocation: CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 2
        let lonDelta:CLLocationDegrees = 2
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: span)
        
        map.setRegion(region, animated: true)
        //print(locations)
    }
    
    func downloadAndDisplaySites()
    {
        let url = URL(string:"http://www.stefanocicero.it/visititaly/get_sites_list.php")!
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
                            if let sites = jsonResult["Sites"] as? [[String: String]]
                            {
                                var latitude:CLLocationDegrees
                                var longitude:CLLocationDegrees
                                var coordinates:CLLocationCoordinate2D
                                var annotation:MKPointAnnotation
                                for site in sites
                                {
                                    latitude = CLLocationDegrees(site["latitude"]!)!
                                    longitude = CLLocationDegrees(site["longitude"]!)!
                                    coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    
                                    annotation = MKPointAnnotation()
                                    annotation.title = site["name"]
                                    annotation.coordinate = coordinates
                                    self.map.addAnnotation(annotation)
                                    print("aggiungo annotazione")
                                }
                            }
                        }
                            //beacon non trovato nel db remoto
                        else
                        {
                            print("Sites not found")
                        }
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
