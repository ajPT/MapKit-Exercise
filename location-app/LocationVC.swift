//
//  SecondViewController.swift
//  location-app
//
//  Created by Amadeu Andrade on 20/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    //MARK: - Properties
    
    let locationManager = CLLocationManager() //Auth
    let regionRadius: CLLocationDistance = 10000 //Set initial area
    var parks = [Park]()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        downloadParksInfo {
            self.tableView.reloadData()
            //Annotation: Create all annotations
            for park in self.parks {
                self.createAnnotationForLocation(park)
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus() //Auth
    }
    
    
    //MARK: - Table View code


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ParkCell") as? ParkCell {
            let park = parks[indexPath.row]
            cell.configureCell(park)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //nothing for now
    }
    
    
    //MARK: - Authorization
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    //MARK: - Set Initial Area
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        //PORTO CENTER: 41.162142, -8.621953
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            centerMapOnLocation(location)
        }
    }
    
    
    //MARK: - Annotations

    //MARK: Create
    func createAnnotationForLocation(park: Park) {
        let lat = park.coordinates.lat
        let long = park.coordinates.long
        let parkCoords = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let park = ParkAnnotation(coordinate: parkCoords, title: park.name, desc: park.description)
        map.addAnnotation(park)
    }
    
    //MARK: Customization

// OPTION 1 : Mark Price's Course

//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.isKindOfClass(ParkAnnotation) {
//            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
//            annoView.pinTintColor = UIColor.blueColor()
//            annoView.animatesDrop = true
//            return annoView
//        } else if annotation.isKindOfClass(MKUserLocation) {
//            
//            mapView.tintColor = UIColor.redColor()
//            return mapView
//        }
//        return nil
//    }
    
// OPTION 2 : Ray Wanderlich
// https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? ParkAnnotation {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//                as? MKPinAnnotationView {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
//            }
//            return view
//        }
//        return nil
//    }
    
//OPTION 3: hackingwithswift.com 
// https://www.hackingwithswift.com/example-code/location/how-to-add-a-button-to-an-mkmapview-annotation

    //Show popup when press annotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkAnnotation {
            let identifier = "pin"
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                return dequeuedView
            } else {
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.enabled = true
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                return view
            }
        }
        return nil
    }
    
    //Show STUFF when pressing the annotation's popup
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let parkAnnotation = view.annotation as! ParkAnnotation
        
        // 1) Show alert when press annotation's popup

        //let parkName = parkAnnotation.title
        //let parkInfo = parkAnnotation.subtitle
        //let ac = UIAlertController(title: parkName, message: parkInfo, preferredStyle: .Alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //presentViewController(ac, animated: true, completion: nil)
        
        // 2) Show "How to get there"
        
        let placemark = MKPlacemark(coordinate: parkAnnotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = parkAnnotation.title
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    
    // AUX
    func downloadParksInfo(completed: DownloadComplete) {
        var name: String!
        var lat: Double!
        var long: Double!
        var desc: String!
        
        let url = NSURL(string: URL_BASE)!
        Alamofire.request(.GET, url).responseJSON(completionHandler: { response in
            let result = response.result
            if let dict = result.value as? [Dictionary<String, AnyObject>] {
                for entry in dict {
                    if let geoDict = entry["geometry"] as? [String: AnyObject] {
                        if let coordinates = geoDict["coordinates"] as? [AnyObject] {
                            long = coordinates[0].doubleValue
                            lat = coordinates[1].doubleValue
                        }
                    }
                    if let properties = entry["properties"] as? Dictionary<String, AnyObject> {
                        if let parkDescription = properties["desc_pt"] as? String {
                            desc = parkDescription
                        }
                        if let parkName = properties["name"] as? String {
                            name = parkName
                        }
                    }
                    let park = Park(name: name, lat: lat, long: long, desc: desc)
                    self.parks.append(park)
                }
            }
            completed()
        })
    }
    
}

