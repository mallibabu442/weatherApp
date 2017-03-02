//
//  ForecastCell.swift
//  WeatherForecast1
//
//  Created by Kata on 02/03/17.
//  Copyright © 2017 Kata. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet var weatherIcon: UIImageView!
    
    @IBOutlet var tempLabel: UILabel!
    
    @IBOutlet var pressureLabel: UILabel!
    
    @IBOutlet var humidityLabel: UILabel!
    
    @IBOutlet var dayNameLabel: UILabel!
    
    @IBOutlet var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
