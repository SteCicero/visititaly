//
//  beacon.swift
//  test con le viste
//
//  Created by Stefano Cicero on 28/10/16.
//  Copyright © 2016 Stefano Cicero. All rights reserved.
//

import Foundation

class beacon
{
    var major:String!
    var minor:String!
    var seqNum:String!
    var imgUrl:String!
    var text:String!
    var name:String!
    var pos_x:String!
    var pos_y:String!
    
    init(major:String, minor:String, seqNum:String, imgUrl:String, text:String, name:String, pos_x:String, pos_y:String)
    {
        self.major = major
        self.minor = minor
        self.seqNum = seqNum
        self.imgUrl = imgUrl
        self.text = text
        self.name = name
        self.pos_x = pos_x
        self.pos_y = pos_y
    }
    
    func isEqual(beacon:beacon) -> Bool
    {
        if(self.major == beacon.major && self.minor == beacon.minor)
        {
            return true
        }
        return false
    }
}
