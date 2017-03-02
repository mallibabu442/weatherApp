//
//  ViewController.swift
//  WeatherForecast1
//
//  Created by Kata on 02/03/17.
//  Copyright © 2017 Kata. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate,WeatherServiceDelegate {
    @IBOutlet var currentLocationLabel: UILabel!
    @IBOutlet var currentStateLabel: UILabel!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descriLabel: UILabel!
    @IBOutlet var weatherForecastBTN: UIButton!
    
    
    
    
    let weatherSERVICE = WeatherService()
    let locationManager = CLLocationManager()
    let today = Date()
    var weatherForeCastArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.weatherSERVICE.delegate = self
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        //Getting the current location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //Getting Current Date.
        let formatter       = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "dd'.'MMM'.'yyyy"
        let result = formatter.string(from: today)
        self.currentDateLabel.text = result
        
        
        if  UIDevice.current.userInterfaceIdiom == .pad {
            
            self.currentLocationLabel.font = UIFont(name:"Avenir-Light", size: 24.0)
            self.currentStateLabel.font = UIFont(name:"Avenir-Light", size: 25.0)
            self.currentDateLabel.font = UIFont(name:"Avenir-Light", size: 25.0)
            
            self.tempLabel.font = UIFont(name:"Avenir-Light", size: 60.0)
            self.descriLabel.font = UIFont(name:"Avenir-Light", size: 60.0)
            
            self.weatherForecastBTN.titleLabel?.font = UIFont(name:"Avenir-Light", size: 30.0)
            
            
        }else if UIDevice.current.userInterfaceIdiom == .phone {
            
            self.currentLocationLabel.font = UIFont(name:"Avenir-Light", size: 17.0)
            self.currentStateLabel.font = UIFont(name:"Avenir-Light", size: 17.0)
            self.currentDateLabel.font = UIFont(name:"Avenir-Light", size: 17.0)
            self.tempLabel.font = UIFont(name:"Avenir-Light", size: 40.0)
            self.descriLabel.font = UIFont(name:"Avenir-Light", size: 40.0)
            
            self.weatherForecastBTN.titleLabel?.font = UIFont(name:"Avenir-Light", size: 17.0)

            
            
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CLLoctionManager Delegate Mthod.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        
        // Convert location into object with human readable address components
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            // Check for errors
            if error != nil
            {
                print(error ?? "Unknown Error")
            } else
            {
                // Get the first placemark from the placemarks array.
                // This is your address object
                if let placemark = placemarks?[0] {
                    
                    // Create an empty string for street address
                    var streetAddress = ""
                    var streetAdd = ""
                    
                    // Check that values aren't nil, then add them to empty string
                    // "subThoroughfare" is building number, "thoroughfare" is street
                    if placemark.subThoroughfare != nil && placemark.thoroughfare != nil {
                        
                        streetAddress = placemark.subThoroughfare! + " " + placemark.thoroughfare!
                        streetAdd = placemark.subThoroughfare!
                        
                    } else
                    {
                        print("Unable to find street address")
                    }
                    
                    
                    // Same as above, but for city
                    var city = ""
                    // locality gives you the city name
                    if placemark.locality != nil  {
                        
                        city = placemark.locality!
                        self.currentLocationLabel.text = city
                        
                    } else {
                        print("Unable to find city")
                    }
                    
                    // Do the same for state
                    var state = ""
                    // administrativeArea gives you the state
                    if placemark.administrativeArea != nil  {
                        state = placemark.administrativeArea!
                        self.currentStateLabel.text = "\(state)/\("India")"
                        
                        
                    } else {
                        print("Unable to find state")
                    }
                    
                    //Passing the current City Name to the API
                    self.weatherSERVICE.weatherService(city: city)
                    
                    
                }
                
            }
            
        }
        
    }

    //Updating UI on main thread with fetched Currentcity weatherData
    func SetWeather(weather: Weather) {
        
        //Updating UI on main thread.
        DispatchQueue.main.async(execute: {
            //Showing weather details on main Screen
            
            let maxInt:Int = Int(weather.max)
            let minInt:Int = Int(weather.min)
            self.tempLabel.text = "\(maxInt)\u{00B0}c / \(minInt)\u{00B0}c"
            self.descriLabel.text = weather.desc
            
            self.weatherForeCastArray = weather.foreCastArray
           // self.weatherIcon.loadImageUsingCacheWithUrlString(weather.icon)
            
                    
            let url   = NSURL(string:weather.icon)
            let data  = NSData(contentsOf:url! as URL)
            
            if data != nil {
                self.weatherIcon.image = UIImage(data:data as! Data)
                
            }
            
            
        })
        
        
        
    }

    

    
    
    @IBAction func forecastBtnClick(_ sender: Any) {
        
        let currentLoction = "city"
        
        UserDefaults.standard.set(currentLoction, forKey: "yourkey")
        UserDefaults.standard.synchronize()
        
    }
    
    
}

extension UIColor{
    
    convenience init(r:CGFloat , g:CGFloat , b:CGFloat) {
        self.init(red:r/255,green:g/255,blue:b/255, alpha:1)
    }
}

