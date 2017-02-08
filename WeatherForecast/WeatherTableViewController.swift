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
    
    var weatherAPI: WeatherAPI! {
        didSet {
            loadCurrentLocation()
        }
    }
    let locationManager = CLLocationManager()
    var latitude = "51.509865"
    var longitude = "-0.118092"
    var dataSource: TableViewDataSource?
    var weatherStore: WeatherStore? {
        didSet {
            setUpTableView(weatherStore: weatherStore!)
        }
    }
    
    func loadCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        //locationManager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func setUpTableView(weatherStore: WeatherStore) {
        tableView.rowHeight = 75
        dataSource = TableViewDataSource(weatherStore: weatherStore)
        tableView.dataSource = dataSource
        navigationItem.title = weatherStore.allWeathers[0].cityName
        
    }

}