//
//  WeatherStore.swift
//  WeatherForecast
//
//  Created by Chris Tseng on 08/02/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit

enum IconResult {
    case Success(UIImage)
    case Failure(Error)
}

enum IconError: Error {
    case IconCreationError
}

class WeatherStore {
    private (set) var allWeathers: [Weather]
    
    init(allWeathers: [Weather]) {
        self.allWeathers = allWeathers
    }
    
    func fetchIconImage(weather: Weather, completion: @escaping (IconResult) -> Void) {
        guard let url = URL(string: weather.iconURL) else {
            return
        }
        if let icon = weather.weatherIcon {
            completion(.Success(icon))
            return
        }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            OperationQueue.main.addOperation({
                let result = self.processIconWithData(data: data)
                if case let .Success(icon) = result {
                    weather.weatherIcon = icon
                }
                completion(result)
            })
            }.resume()

    }
    
    private func processIconWithData(data: Data?) -> IconResult {
        guard data != nil,
            let image = UIImage(data: data!) else {
                return .Failure(IconError.IconCreationError)
        }
        
        return .Success(image)
    }
}
