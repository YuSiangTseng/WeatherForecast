//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import Foundation

enum WeatherResult {
    case Success([Weather])
    case Failure(Error)
}

enum WeatherAPIError: Error {
    case InvalidJSONData
}

class WeatherAPI {
    
    var baseURLString = String()
    var latitude = "51.509865"
    var longitude = "-0.118092"
    let session = URLSession.shared
    
    func setCoordinates(lat: String, long: String) {
        latitude = lat
        longitude = long
    }
    
    private func urlWithCoordinate() -> URL? {
        guard latitude != "",
            longitude != "" else {
                return nil
        }
        baseURLString = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=" + latitude + "&lon=" + longitude + "&cnt=10&mode=json&units=metric&appid=f9c4a2dfc491a99982b4a2d8888b8937"
        
        return URL(string: baseURLString)
    }
    
    func fetchWeathers( completion: @escaping (WeatherResult) -> Void) {
        guard let url = urlWithCoordinate() else {
            return;
        }
        session.dataTask(with: url) { (data, response, error) in
            OperationQueue.main.addOperation({
                let result = self.weatherResultWithData(data: data)
                completion(result)
            })
            }.resume()

    }
    
    private func weatherResultWithData(data: Data?) -> WeatherResult {
        guard data != nil,
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject],
            let cityInformation = jsonObject?["city"] as? [String : AnyObject],
            let weatherInformation = jsonObject?["list"] as? [[String : AnyObject]] else {
                return .Failure(WeatherAPIError.InvalidJSONData)
        }
        var finalWeatherForecasts = [Weather]()
        for weatherJSON in weatherInformation {
            if let weather = weatherWithArray(cityJson: cityInformation, weatherJson: weatherJSON) {
                finalWeatherForecasts.append(weather)
            }
        }
        
        return .Success(finalWeatherForecasts)
    }
    
    private func weatherWithArray(cityJson: [String : AnyObject], weatherJson: [String: AnyObject]) -> Weather? {
        guard let cityName = cityJson["name"] as? String,
            let date = weatherJson["dt"] as? Double,
            let temp = weatherJson["temp"] as? [String : AnyObject],
            let degree = temp["day"] as? Double,
            let weatherInformationJson = weatherJson["weather"] as? [[String : AnyObject]] else {
                 return nil
        }
        var weatherType = String()
        var iconURL = String()
        if let weatherTypeName = weatherInformationJson.first?["description"] as? String {
            if let iconID = weatherInformationJson.first?["icon"] as? String {
                weatherType = weatherTypeName
                iconURL = "http://openweathermap.org/img/w/" + iconID + ".png"
            }
        }
        return Weather(cityName: cityName, date: date, degree: String(degree), weatherType: weatherType, iconURL: iconURL)
    }
    
}
