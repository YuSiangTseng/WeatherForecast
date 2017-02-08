//
//  WeatherStore.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

class WeatherStore {
    private (set) var allWeathers: [Weather]
    
    init(allWeathers: [Weather]) {
        self.allWeathers = allWeathers
    }
}
