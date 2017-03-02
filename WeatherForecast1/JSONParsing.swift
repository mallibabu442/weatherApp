//
//  JSONParsing.swift
//  WeatherForecast
//
//  Created by Kata on 02/03/17.
//  Copyright © 2017 Kata. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func SetWeather(weather:Weather)    
}

class WeatherService {
    var day : Double = 0.0
    var max : Double = 0.0
    var min : Double = 0.0
    var humidity:Double = 0.0
    var pressure:Double = 0.0
    var desc:String = ""
    var icon:String = ""
    var foreCastArr:NSArray = []
    
    var delegate: WeatherServiceDelegate?
    
    func weatherService(city:String){
        
        //API Calling for Weather report.
        let cityescaped  = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let path = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(cityescaped!)&mode=json&units=metric&cnt=7&appid=3a2971208e03d7e1104ae796dbb0f559"
        let url = URL(string: path)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            else{
                do{
                    //Parsing data with JSONSerialization.
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    
                    let forecastArray  = parsedData["list"] as! NSArray
                    
                    self.foreCastArr = forecastArray
                    
                    let forecastDict   = forecastArray[0] as! NSDictionary
                    let tempDict       = forecastDict.object(forKey: "temp") as! NSDictionary
                    let weatherArr     = forecastDict["weather"] as! NSArray
                    let weatherDict    = weatherArr[0] as! NSDictionary
                    
                    self.day   = tempDict.object(forKey: "day") as! Double
                    self.max   = tempDict.object(forKey: "max") as! Double
                    self.min   = tempDict.object(forKey: "min") as! Double
                    let weatherIcon = weatherDict.object(forKey: "icon") as! String
                    self.humidity = forecastDict.object(forKey: "humidity") as! Double
                    self.pressure = forecastDict.object(forKey: "pressure") as! Double
                    
                    self.desc = (weatherDict.object(forKey: "description") as! String?)!
                    
                    
                    //Getting of icon from url.
                    
                    self.icon = "http://openweathermap.org/img/w/\(weatherIcon).png"
                    
                    
            
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }).resume()
        
       
        let weather = Weather(cityName: city, Min: min, Max: max, Day: day, Humidity: humidity, Pressure: pressure, Icon:icon,Desc:desc,ForecastArray:foreCastArr)
        
        if self.delegate != nil {
            self.delegate?.SetWeather(weather: weather)
            
        }

        
        
        
        
    }
    
}


