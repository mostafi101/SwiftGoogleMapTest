//
//  URLCreation.swift
//  SwiftGoogleMap
//
//  Created by Mostafijur Rahaman on 8/11/17.
//  Copyright © 2017 Mostafijur Rahaman. All rights reserved.
//

import Foundation



    let baseUrl = "https://stagingapp.mylucke.com/api/v5/"
    
    func requestType(for type: String) -> String{
        if type == "Get"{
            return "getplaces?"
        }else{
            print("Invalid Request")
            return ""
        }
        
    }
    
    
    func getTimeDateString(_ type: String, format month_day_year_time: String) -> String{
        
        let str =  month_day_year_time.replacingOccurrences(of: " ", with: "%20")
        return "\(type)=\(str)"
    }
    
    func getTimeString(_ inOrOut: String,at time: String) -> String {
        let t =  time.replacingOccurrences(of: " ", with: "%20")
        return "\(inOrOut)=\(t)"
    }
    
    
    func getLatLngString(for latitudes: [Double], and longitudes: [Double]) -> String {
        var latString = ""
        var lngString = ""
        for (index,lat) in latitudes.enumerated() {
            if index == 0{
                latString = "lat=\(lat)"
                lngString = "lng=\(longitudes[index])"
            }else{
                latString = latString + "&lat\(index)=\(lat)"
                lngString = lngString + "&lng\(index)=\(longitudes[index])"
            }
            
            
        }
        
        return "\(latString)&\(lngString)"
    }
    
    let lat = [34.052200, 33.9522, 34.1522]
    let lng = [-118.243700, -118.1437, -118.3437]
    
    let latLng = getLatLngString(for: lat, and: lng)
    
    
    let checkIn = getTimeDateString("checkintime",format: "May 23, 2017 00:55")
    let checkout = getTimeDateString("checkouttime", format: "May 23, 2017 01:55")
    let intime = getTimeString("intime", at: "5:55 PM")
    let outtime = getTimeString("outtime", at: "6:55 PM")
    
    func getURLString(base: String, forType type: String, withLat lat: [Double], andLang lng: [Double], forCheckIn checkIn: String,toCheckOut checkout: String, forInTime intime: String, toOutTime outtime: String, forPrice price: Int, toMax max: Int, inRadius radius: Int, byRateType rateType: String )-> String {
        
        return "\(base)\(requestType(for: type))\(checkIn)&\(checkout)&\(intime)&\(getLatLngString(for: lat, and: lng))&maxprice=\(max)&minprice=\(price)&\(outtime)&radius=\(radius)&ratetype=\(rateType))"
        
    }
    
    /*func getURL()-> URL{
        return URL(string: getURL(base: baseUrl, forType: "Get", withLat: lat, andLang: lng, forCheckIn: checkIn, toCheckOut: checkout, forInTime: intime, toOutTime: outtime, forPrice: 1, toMax: 100, inRadius: 10, byRateType: "hourly"))
    }*/
    
   /* print(getURL(base: baseUrl, forType: "Get", withLat: lat, andLang: lng, forCheckIn: checkIn, toCheckOut: checkout, forInTime: intime, toOutTime: outtime, forPrice: 1, toMax: 100, inRadius: 10, byRateType: "hourly"))*/

    
