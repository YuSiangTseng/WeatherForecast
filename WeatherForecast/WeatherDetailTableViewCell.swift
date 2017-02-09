//
//  WeatherDetailTableViewCell.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherTypeLabel: UILabel!
    @IBOutlet var weatherDegreeLabel: UILabel!
    @IBOutlet var weatherDateLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!

    func updateIcon(image: UIImage?) {
        guard image != nil else {
            weatherIconImageView.image = nil
            return
        }
        weatherIconImageView.image = image
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateIcon(image: nil)
    }

}
