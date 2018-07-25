//
//  ExpressBeacon.swift
//  ibeacon
//
//  Created by Stefano Cicero on 22/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import Foundation

class ExpressBeacon
{
    var puuid:UUID!
    var major:Int!
    var minor:Int!
    
    init(puuid:UUID, major:Int, minor:Int)
    {
        self.puuid = puuid
        self.major = major
        self.minor = minor
    }
    
    func isEqual(beacon:ExpressBeacon) -> Bool
    {
        if((self.puuid == beacon.puuid) && (self.major == beacon.major) && (self.minor == beacon.minor))
        {
            return true
        }
        else
        {
            return false
        }
    }
}
