//
//  ForecastListViewController.swift
//  WeatherForecast1
//
//  Created by Kata on 02/03/17.
//  Copyright © 2017 Kata. All rights reserved.
//

import UIKit

class ForecastListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var foreCastArray:NSArray = []
    var parsedDataArray:NSArray = []
    var Date:String = ""
    var Time:String = ""

    
    
    
    @IBOutlet var forecastTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            
            self.forecastTable.rowHeight = 250.0
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
         
            self.forecastTable.rowHeight = 170.0

        }
        
        
        forecastTable.reloadData()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        let currentLocation = UserDefaults.standard.object(forKey: "yourkey") as? String
        //Passing Current location to API.
        self.APICalling(city: currentLocation!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        forecastTable.reloadData()

    }

    
    func  APICalling(city:String) {
        
       
        //API Calling for Weather report.
        let cityescaped  = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let path = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityescaped!)&appid=3a2971208e03d7e1104ae796dbb0f559"
        let url = URL(string: path)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            } else {
                do {
                    //Parsing data with JSONSerialization.
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    self.parsedDataArray = parsedData.object(forKey: "list") as! NSArray
                    
                    DispatchQueue.main.async {
                        self.forecastTable.reloadData()
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }).resume()

        

    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ForecastCell
        
        
        
        
        
       if  UIDevice.current.userInterfaceIdiom == .pad {
            
            cell.weatherIcon.frame = CGRect(x: 16, y: 40, width: 190, height: 190)
            cell.tempLabel.frame = CGRect(x: 240, y: 40, width: 370, height: 43)
            cell.descLabel.frame = CGRect(x: 240, y: 91, width: 370, height: 43)
            cell.pressureLabel.frame = CGRect(x: 240, y: 138, width: 370, height: 43)
            cell.humidityLabel.frame = CGRect(x: 240, y: 187, width: 370, height: 43)
            
            cell.dayNameLabel.frame = CGRect(x: 16, y: 0, width: 366, height: 43)
            
            cell.tempLabel.font = UIFont(name:"Avenir-Light", size: 30.0)
            cell.descLabel.font = UIFont(name:"Avenir-Light", size: 30.0)
            cell.pressureLabel.font = UIFont(name:"Avenir-Light", size: 30.0)
            cell.humidityLabel.font = UIFont(name:"Avenir-Light", size: 30.0)
            cell.dayNameLabel.font = UIFont(name:"Avenir-Bold", size: 30.0)
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
            
            cell.weatherIcon.frame = CGRect(x: 16, y: 40, width: 105, height: 117)
            
            cell.tempLabel.frame = CGRect(x: 133, y: 40, width: 200, height: 24)
            cell.descLabel.frame = CGRect(x: 133, y: 72, width: 168, height: 24)
            cell.pressureLabel.frame = CGRect(x: 133, y: 99, width: 250, height: 24)
            cell.humidityLabel.frame = CGRect(x: 133, y: 130, width: 168, height: 24)
            
            cell.dayNameLabel.frame = CGRect(x: 20, y: 8, width: 200, height: 24)
            
            cell.tempLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
            cell.descLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
            cell.pressureLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
            cell.humidityLabel.font = UIFont(name:"Avenir-Light", size: 20.0)
            cell.dayNameLabel.font = UIFont(name:"Avenir-Bold", size: 20.0)
            

        }
                
        
        
        let foreCastDict = parsedDataArray[indexPath.row] as!NSDictionary
        let tempDict = foreCastDict.object(forKey: "main") as!NSDictionary
        let weatherArray = foreCastDict.object(forKey: "weather") as!NSArray
        let weatherDict  = weatherArray[0] as! NSDictionary
        
        let iconStr = weatherDict.object(forKey: "icon") as! NSString
    
        
        //Getting of Weathericon from url.
        let iconURL = "http://openweathermap.org/img/w/\(iconStr).png"
        cell.weatherIcon.loadImageUsingCacheWithUrlString(iconURL)
        
        

        //Converting Temp Kelvin to Celcius.
        let  maxTemp = tempDict.object(forKey:"temp_max") as! Double
        let  minTemp = tempDict.object(forKey:"temp_min") as! Double
        let  maxTemCelcius = String(format: "%.0f", maxTemp - 273.15)
        let  minTemCelcius = String(format: "%.0f", minTemp - 273.15)
        cell.tempLabel.text = "Temp:\(maxTemCelcius)\u{00B0}c / \(minTemCelcius)\u{00B0}c"

        
        
        let humidity:Int = Int(tempDict.object(forKey:"humidity") as! Double)
        let presure:Int = Int(tempDict.object(forKey:"pressure") as! Double)
        
        cell.humidityLabel.text = "Humidity:\(humidity) %rh"
        cell.pressureLabel.text = "pressure:\(presure) in.Hg"
        cell.descLabel.text = weatherDict.object(forKey: "description") as? String
        
        
        //Spliting of Date and Time
        let dateTime    = foreCastDict.object(forKey: "dt_txt") as? String
        let dateTimeArr = dateTime?.components(separatedBy: " ")
        Date    = (dateTimeArr?[0])!
        Time    = (dateTimeArr?[1])!
        cell.dayNameLabel.text =  "\(Date) / \(Time)"
        
        return cell
    }
    
    
    

}

