//
//  LocationViewModel.swift
//  SwiftGoogleMap
//
//  Created by Mostafijur Rahaman on 8/11/17.
//  Copyright © 2017 Mostafijur Rahaman. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON


class LocationViewModel {
    
    static open let points = Variable([ParkingPoint(name: "", lat: 0, lng: 0)])
    static open let group = DispatchGroup()
    
    
    func getPoints()-> Observable<[ParkingPoint]> {
        return LocationViewModel.points.asObservable()
    }
    
    
    func getParkingPoints(){
        let urlString =  "https://stagingapp.mylucke.com/api/v5/getplaces?checkintime=May%2023,%202017%2000:55&checkouttime=May%2023,%202017%2001:55&intime=5:55%20PM&lat=34.052200&lat1=33.9522&lat2=34.1522&lng=-118.243700&lng1=-118.1437&lng2=-118.3437&maxprice=100&minprice=1&outtime=6:55%20PM&radius=10&ratetype=hourly)"
        
        let req = URLRequest(url: URL(string: urlString)!)
        
        URLSession.shared.rx.base.dataTask(with: req) { (data, response, error) in
        
        }
        
    }
    
    
    
    func getParkingLocations() {
        LocationViewModel.group.enter()
        var parkingLocations: [ParkingPoint] = []
        
        let urlString =  "https://stagingapp.mylucke.com/api/v5/getplaces?checkintime=May%2023,%202017%2000:55&checkouttime=May%2023,%202017%2001:55&intime=5:55%20PM&lat=34.052200&lat1=33.9522&lat2=34.1522&lng=-118.243700&lng1=-118.1437&lng2=-118.3437&maxprice=100&minprice=1&outtime=6:55%20PM&radius=10&ratetype=hourly)"
        
        
        guard let url = URL(string: urlString) else {
            print("Here")
            return 
        }
        
        let session = URLSession.shared
        
        
        //DispatchQueue.main.async {
            
            session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print(err.localizedDescription)
                }else{
                    let json = JSON(data: data!)
                    let locations = json["data"]
                    
                    for (_, subjson): (String, JSON) in locations{
                        //print(subjson["loc"])
                        
                        if let lat = subjson["loc"][1].double, let lng = subjson["loc"][0].double, let name = subjson["userid"]["profile"]["name"].string{
                            let point = ParkingPoint(name: name, lat: lat, lng: lng)
                            print("\(name) \(lat) \(lng)")
                            parkingLocations.append(point)
                        }
                        
                        
                        
                    }
                    //print(loc)
                }
                }.resume()
            
            

        //}
        
        LocationViewModel.points.value = parkingLocations
        
        LocationViewModel.group.leave()

    }
    
}
