//
//  ViewController.swift
//  SwiftGoogleMap
//
//  Created by Mostafijur Rahaman on 8/10/17.
//  Copyright © 2017 Mostafijur Rahaman. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import RxSwift
import UserNotifications


class ViewController: UIViewController , GMSMapViewDelegate{
    
    var points = [ParkingPoint]()
    var setOfEntry = Set<String>()
    let locationModel = LocationViewModel()
    var myLocation = ParkingPoint(name: "User", lat: 34.1033004, lng: -118.3062172)
    var isDragging = false
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: GMSMapView!
    //var mapView: GMSMapView!
    var usermarker: GMSMarker!
    
    
    //let camera = Variable(GMSCameraPosition.camera(withLatitude: 34.1033004, longitude: -118.3062172, zoom: 14))
    //let mapView = GMSMapView.map(withFrame: .zero, camera: camera.value)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        
        let camera = Variable(GMSCameraPosition.camera(withLatitude: 34.1033004, longitude: -118.3062172, zoom: 1))
        mapView = GMSMapView.map(withFrame: .zero, camera: camera.value)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        self.view = mapView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let urlString =  "https://stagingapp.mylucke.com/api/v5/getplaces?checkintime=May%2023,%202017%2000:55&checkouttime=May%2023,%202017%2001:55&intime=5:55%20PM&lat=34.052200&lat1=33.9522&lat2=34.1522&lng=-118.243700&lng1=-118.1437&lng2=-118.3437&maxprice=100&minprice=1&outtime=6:55%20PM&radius=10&ratetype=hourly)"
        
        
        guard let url = URL(string: urlString) else {
            print("Here")
            return
        }
        
        
        let session = URLSession.shared
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
                        print("\(name)  \(lat)  \(lng)")
                        DispatchQueue.main.async{
                            self.addMarker(point: point)
                        }
                        self.points.append(point)
                    }
                    
                    
                    
                }
                //print(loc)
            }
            }.resume()
    }
    
    /*func makeUsermarker(lat: Double, lng: Double){
        usermarker.map = nil
        usermarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let markerImage = UIImage(named: "pin")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.blue
        usermarker.iconView = markerView
        usermarker.snippet = "My Location"
        usermarker.isDraggable = true
        usermarker.appearAnimation = .pop
        usermarker.map = mapView
        //marker.value.
        mapView.isMyLocationEnabled = true
    }*/
    
    
    func addMarker(point: ParkingPoint){
        let point_marker = GMSMarker()
        point_marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
        point_marker.title = point.name
        point_marker.snippet = "Hey, this is \(point.name)"
        point_marker.map = mapView
        let region = CLCircularRegion(center: point_marker.position, radius: 200, identifier: point.name)
        locationManager.startMonitoring(for: region)
        let circle = GMSCircle(position: region.center, radius: region.radius)
        circle.fillColor = UIColor.red
        circle.map = mapView
        print("Region created")
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        print("Alart")
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    
    
    
    
    
   /* override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Parking Points"
        
        let camera = Variable(GMSCameraPosition.camera(withLatitude: 34.1033004, longitude: -118.3062172, zoom: 14))
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera.value)
        
        
        mapView.delegate = self
        let marker = Variable(GMSMarker())
        marker.value.position = camera.value.target
        let markerImage = UIImage(named: "pin")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.blue
        marker.value.iconView = markerView
        marker.value.snippet = "Parking Points"
        marker.value.isDraggable = true
        marker.value.appearAnimation = .pop
        marker.value.map = mapView
        //marker.value.
        mapView.isMyLocationEnabled = true
        camera.asObservable()
            .subscribe(onNext: { value in
                let lat = value.target.latitude
                let lng = value.target.longitude
                
                print("\(lat) \(lng)")
                
            })
        
        
        
        
        let urlString =  "https://stagingapp.mylucke.com/api/v5/getplaces?checkintime=May%2023,%202017%2000:55&checkouttime=May%2023,%202017%2001:55&intime=5:55%20PM&lat=34.052200&lat1=33.9522&lat2=34.1522&lng=-118.243700&lng1=-118.1437&lng2=-118.3437&maxprice=100&minprice=1&outtime=6:55%20PM&radius=10&ratetype=hourly)"
        
        
        guard let url = URL(string: urlString) else {
            print("Here")
            return
        }
        
        let session = URLSession.shared
        
        var points = [ParkingPoint]()
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        // DispatchQueue.main.async {
        
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
                        DispatchQueue.main.async{
                            let point_marker = GMSMarker()
                            point_marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                            point_marker.title = point.name
                            point_marker.snippet = "Hey, this is \(point.name)"
                            point_marker.map = mapView
                            let region =
                        }
                        points.append(point)
                    }
                    
                    
                    
                }
                //print(loc)
            }
            }.resume()
        
        myGroup.leave()
        
        
        //}
        
        
        //................................
        
        
        view = mapView
        
        myGroup.notify(queue: .main) {
            print("Finished")
        }
    }*/
        
        
 
    

    
   /* func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.isDragging = false
        print("\(marker.position.latitude) \(marker.position.longitude)")
        locationManager.value.
    }
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        self.isDragging = true
    }*/
    
    /*func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }*/
    
    
    /*func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("\(position.target.latitude)  \(position.target.longitude)")
    }*/
    
   /* func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Tapped Location: \(coordinate.longitude)  \(coordinate.longitude)")
    }*/
    
    
}
    
    
    
   /* override func loadView() {
       /* navigationItem.title = "Parking Points"
        
        let camera = Variable(GMSCameraPosition.camera(withLatitude: 34.1033004, longitude: -118.3062172, zoom: 14))
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera.value)
        
        let marker = Variable(GMSMarker())
        marker.value.position = camera.value.target
        let markerImage = UIImage(named: "pin")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        markerView.tintColor = UIColor.blue
        marker.value.iconView = markerView
        marker.value.snippet = "Parking Points"
        marker.value.isDraggable = true
        marker.value.appearAnimation = .pop
        marker.value.map = mapView
        camera.asObservable()
            .subscribe(onNext: { value in
                let lat = value.target.latitude
                let lng = value.target.longitude
                
                    print("\(lat) \(lng)")
                
            })
                
        
        
        /*locationModel.getParkingLocations()
        let locations = locationModel.points
        
        locations.asObservable()
            .subscribe(onNext: { value in
                for point in value{
                    let point_marker = GMSMarker()
                    point_marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                    point_marker.title = point.name
                    point_marker.snippet = "Hey, this is \(point.name)"
                    point_marker.map = mapView
                    print("Printed")
                }
            })*/

        
       /* for point in points{
            let point_marker = GMSMarker()
            point_marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
            point_marker.title = point.name
            point_marker.snippet = "Hey, this is \(point.name)"
            point_marker.map = mapView
        }*/
        
        //.................................
        
        let urlString =  "https://stagingapp.mylucke.com/api/v5/getplaces?checkintime=May%2023,%202017%2000:55&checkouttime=May%2023,%202017%2001:55&intime=5:55%20PM&lat=34.052200&lat1=33.9522&lat2=34.1522&lng=-118.243700&lng1=-118.1437&lng2=-118.3437&maxprice=100&minprice=1&outtime=6:55%20PM&radius=10&ratetype=hourly)"
        
        
        guard let url = URL(string: urlString) else {
            print("Here")
            return
        }
        
        let session = URLSession.shared
        
        var points = [ParkingPoint]()
        
        let myGroup = DispatchGroup()
        myGroup.enter()
       // DispatchQueue.main.async {
            
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
                            DispatchQueue.main.async{
                                let point_marker = GMSMarker()
                                point_marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
                                point_marker.title = point.name
                                point_marker.snippet = "Hey, this is \(point.name)"
                                point_marker.map = mapView
                            }
                            points.append(point)
                        }
                        
                        
                        
                    }
                    //print(loc)
                }
                }.resume()
        
        myGroup.leave()
        
        
        //}

        
        //................................
        
        
        view = mapView
        
        myGroup.notify(queue: .main) {
            print("Finished")
        }
    }*/
    
    

    
}*/




extension ViewController: CLLocationManagerDelegate, UIAlertViewDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 1.0)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        
        print("printing")
        var enter = Set<String>()
        var exit = Set<String>()
        for point in points {
            let pointCoordinate = CLLocation(latitude: point.lat, longitude: point.lng)
            if let distance =  location?.distance(from: pointCoordinate){
                if distance.isLess(than: 10){
                    enter.insert(point.name)
                    print("addeded")
                }
            }
            
        }
        
        for e in setOfEntry{
            if !enter.contains(e){
                exit.insert(e)
            }
        }
        
        if(enter.count > 0){
            let title = "Say hay to \(enter)"
            let message = "Lets check"
            showAlert(title: title, message: message)
            showNotification(title: title, message: message)
            
        }
        
        
        if(exit.count > 0){
            let title = "Say buy to \(exit)"
            let message = "see you again!"
            showAlert(title: title, message: message)
            showNotification(title: title, message: message)
        }
        
        self.setOfEntry = enter
        /*locationManager.stopUpdatingLocation()
         mapView.isMyLocationEnabled = true
         
         let myLocation = locations[locations.count].coordinate
         makeUsermarker(lat: myLocation.latitude, lng: myLocation.longitude)*/
        
         self.locationManager.stopUpdatingLocation()
        
        
    }

    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "Say hay to \(region.identifier)"
        let message = "lets have a chat"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the \(region.identifier)"
        let message = "Come again!!"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    
}

