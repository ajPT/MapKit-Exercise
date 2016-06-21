//
//  parkAnnotation.swift
//  location-app
//
//  Created by Amadeu Andrade on 21/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class ParkAnnotation: NSObject, MKAnnotation {
    
    //MARK: - Properties
    
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    var subtitle: String?
    
    
    //MARK: - Initializer
    
    init(coordinate: CLLocationCoordinate2D, title: String, desc: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = desc
    }
    
}