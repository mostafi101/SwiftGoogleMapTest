//
//  GeoKey.swift
//  SwiftGoogleMap
//
//  Created by Mostafijur Rahaman on 8/12/17.
//  Copyright © 2017 Mostafijur Rahaman. All rights reserved.
//

import Foundation

struct Geokey {
    static let latitude = 0.00
    static let longitude = 0.00
    static let radius = 0.00
    static let note = "note"
    static let identifier = "identifier"
    static let eventType = "eventType"
    
}

enum EventType: String{
    case onEnter = "On Enter"
    case onExit = "On Exit"
}


