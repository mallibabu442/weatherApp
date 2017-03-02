//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Kata on 02/03/17.
//  Copyright © 2017 Kata. All rights reserved.
//

import UIKit

struct Weather {
    let Name:String
    let min:Double
    let max:Double
    let day:Double
    let humidity:Double
    let pressure:Double
    let icon:String
    let desc:String
    let foreCastArray:NSArray
    
    
    init(cityName:String,Min:Double,Max:Double,Day:Double,Humidity:Double,Pressure:Double,Icon:String,Desc:String,ForecastArray:NSArray) {
        self.Name = cityName
        self.min = Min
        self.max = Max
        self.day = Day
        self.humidity = Humidity
        self.pressure = Pressure
        self.icon = Icon
        self.desc = Desc
        self.foreCastArray = ForecastArray
        
    }
}
