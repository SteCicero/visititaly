//
//  AppDelegate.swift
//  ibeacon
//
//  Created by Stefano Cicero on 12/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import UIKit
import KontaktSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Kontakt.setAPIKey("ZJAPPHOGEFlNhoRMgdzDJgFGXQRpmEZA")
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Application goes in background")
        
        
        //Disabilita la scansione se l'app va in background
        /*if(self.window?.rootViewController is ViewController)
        {
            let temp:ViewController = (self.window?.rootViewController as? ViewController)!
            print("Stopping monitoring \(temp.region.identifier)")
            temp.logTextView.text.append("\nStopping monitoring \(temp.region.identifier)")
            temp.beaconManager.stopRangingBeacons(in: temp.region)
            temp.beaconManager.stopMonitoring(for: temp.region)
            temp.startStopButton.setTitle("Start monitoring", for: UIControlState.normal)
        }*/
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Application enter in foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Application will terminate")
        
        //Disabilita la scansione se l'app viene chiusa
        if(self.window?.rootViewController is ViewController)
        {
            let temp:ViewController = (self.window?.rootViewController as? ViewController)!
            print("Stopping monitoring \(temp.region.identifier)")
            //temp.logTextView.text.append("\nStopping monitoring \(temp.region.identifier)")
            temp.beaconManager.stopRangingBeacons(in: temp.region)
            temp.beaconManager.stopMonitoring(for: temp.region)
            temp.startStopButton.setTitle("Start monitoring", for: UIControlState.normal)
        }
    }
    
}
