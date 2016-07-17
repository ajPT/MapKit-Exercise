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
    private var _coordinates: (lat: Double, long: Double)!
    private var _description: String!
    private var _parkUrl: String!
    
    
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
    
    var parkURL: String {
        return _parkUrl
    }
    
    
    //MARK: Initializer
    
    init(name: String, lat: Double, long: Double, desc: String) {
        _name = name
        _coordinates = (lat: lat, long: long)
        _description = desc
        let latStr = String(lat)
        let longStr = String(long)
        _parkUrl = "https://google.com/maps/place/\(latStr),\(longStr)"
    }
    
    
}