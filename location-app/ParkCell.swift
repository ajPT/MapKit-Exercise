//
//  ParkCell.swift
//  location-app
//
//  Created by Amadeu Andrade on 21/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class ParkCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var parkName: UILabel!
    @IBOutlet weak var parkDesc: UILabel!
    
    
    //MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: - Configure Cell
    
    func configureCell(park: Park) {
        parkName.text = park.name
        parkDesc.text = park.description
    }
    

}
