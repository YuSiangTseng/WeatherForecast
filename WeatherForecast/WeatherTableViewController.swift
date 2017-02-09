//
//  WeatherTableViewController.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var weatherAPI: WeatherAPI! {
        didSet {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    var latitude = "51.509865"
    var longitude = "-0.118092"
    var dataSource: TableViewDataSource?
    var weatherStore: WeatherStore? {
        didSet {
            setUpTableView(weatherStore: weatherStore!)
        }
    }
    
    func loadData() {
        weatherAPI.setCoordinates(lat: latitude, long: longitude)
        weatherAPI.fetchWeathers() {
            (weatherResult) -> Void in
            switch weatherResult {
            case let .Success(weathers):
                self.weatherStore = WeatherStore(allWeathers: weathers)
            case .Failure(_):
                print("hello")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        latitude = "\(location.coordinate.latitude)"
        longitude = "\(location.coordinate.longitude)"
        loadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            loadData()
        }
        else if status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func setUpTableView(weatherStore: WeatherStore) {
        tableView.rowHeight = 75
        dataSource = TableViewDataSource(weatherStore: weatherStore)
        tableView.dataSource = dataSource
        navigationItem.title = weatherStore.allWeathers[0].cityName
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let weather = weatherStore?.allWeathers[indexPath.row] {
            weatherStore?.fetchIconImage(weather: weather, completion: { (iconResult) in
                let cell = cell as! WeatherDetailTableViewCell
                cell.updateIcon(image: weather.weatherIcon)
            })
        }
    }

}
