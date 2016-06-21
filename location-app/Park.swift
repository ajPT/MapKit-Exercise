//
//  Park.swift
//  location-app
//
//  Created by Amadeu Andrade on 21/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation

class Park {

    //MARK: - Properties
    
    private var _name: String!
    private var _coordinates: (Double, Double)!
    private var _description: String!
    
    
    //MARK: - Getters
    
    var name: String {
        return _name
    }
    
    var coordinates: (lat: Double, long: Double) {
        return _coordinates
    }
    
    var description: String {
        return _description
    }
    
    
    //MARK: Initializer
    
    init(name: String, lat: Double, long: Double, desc: String) {
        self._name = name
        self._coordinates = (lat, long)
        self._description = desc
    }
    
}