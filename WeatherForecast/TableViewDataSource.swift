//
//  TableViewDataSource.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import Foundation

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var weatherStore: WeatherStore
    var dateFormatter = DateFormatter()
    init(weatherStore: WeatherStore) {
        self.weatherStore = weatherStore
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell") as! WeatherDetailTableViewCell
        let weather = weatherStore.allWeathers[indexPath.row]
        cell.weatherDateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: weather.date))
        cell.weatherDegreeLabel.text = weather.degree + " ℃"
        cell.weatherTypeLabel.text = weather.weatherType.capitalized
        cell.updateIcon(image: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherStore.allWeathers.count
    }
}
