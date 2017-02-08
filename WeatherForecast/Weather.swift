//
//  Weather.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

struct Weather {
    let cityName: String
    let date: Double
    let degree: String
    let weatherType: String
    let iconURL: String
    var weatherIcon: UIImage?
    init(cityName: String, date: Double, degree: String, weatherType: String, iconURL: String) {
        self.cityName = cityName
        self.date = date
        self.degree = degree
        self.weatherType = weatherType
        self.iconURL = iconURL
    }
}

