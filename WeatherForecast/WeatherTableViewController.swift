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
            requestLocation()
        }
    }
    var latitude = "51.509865"
    var longitude = "-0.118092"
    var dataSource: TableViewDataSource?
    var weatherStore: WeatherStore? {
        didSet {
            if let weatherStore = weatherStore {
                setUpTableView(weatherStore: weatherStore)
            }
        }
    }
    var dateFormatter = DateFormatter()
    
    //MARK:- life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK:- view set up
    
    func setUpTableView(weatherStore: WeatherStore) {
        tableView.rowHeight = 75
        refreshControl?.endRefreshing()
        dataSource = TableViewDataSource(weatherStore: weatherStore)
        tableView.dataSource = dataSource
        navigationItem.title = weatherStore.allWeathers[0].cityName
        
    }
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.distanceFilter = 300
        }
        else {
            loadData()
        }
    }
    
    //MARK:- CLLocationManagerDelegate
    
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
    
    func loadData() {
        weatherAPI.setCoordinates(lat: latitude, long: longitude)
        weatherAPI.fetchWeathers { weatherResult in
            switch weatherResult {
            case let .Success(weathers):
                self.weatherStore = WeatherStore(allWeathers: weathers)
            case .Failure(_):
                self.showErrorMessage()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK:- TableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let weather = weatherStore?.allWeathers[indexPath.row] {
            weatherStore?.fetchIconImage(weather: weather, completion: { (iconResult) in
                let cell = cell as! WeatherDetailTableViewCell
                cell.updateIcon(image: weather.weatherIcon)
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let weather = weatherStore?.allWeathers[indexPath.row] {
            if let weatherIcon = weather.weatherIcon {
                dateFormatter.dateStyle = .short
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let objects = [weather.cityName, weather.degree + " ℃", weather.weatherType.capitalized, weatherIcon, dateFormatter.string(from: Date(timeIntervalSince1970: weather.date))] as [Any]
                let activityViewController = UIActivityViewController(activityItems: objects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = tableView
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK:- SrollviewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshControl = nil
    }
    
    //MARK:- Utility
    
    func showErrorMessage() {
        let title = "Internet problem"
        let message = "Please press reload to try it again."
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { (action) -> Void in
            self.loadData()
        }
        ac.addAction(reloadAction)
        present(ac, animated: true, completion: nil)
    }


}
