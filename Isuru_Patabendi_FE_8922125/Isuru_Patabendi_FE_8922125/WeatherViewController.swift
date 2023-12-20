//
//  WeatherViewController.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/4/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    // Outlets for UI elements
    @IBOutlet var cityLable: UILabel!
    @IBOutlet var weatherLable: UILabel!
    @IBOutlet var temperatureLable: UILabel!
    @IBOutlet var humidityLable: UILabel!
    @IBOutlet var windLable: UILabel!
    
    @IBOutlet var weatherIcon: UIImageView!
    
    // Variable to store entered destination
    var destination: String?
    
    //Current date & time
    var datetime = Date()
    
    // CLLocationManager for handling location services
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get location access
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // MARK: - Welcome
    struct Welcome: Codable {
        let coord: Coord
        let weather: [Weather]
        let base: String
        let main: Main
        let visibility: Int
        let wind: Wind
        let clouds: Clouds
        let dt: Int
        let sys: Sys
        let timezone, id: Int
        let name: String
        let cod: Int
    }

    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int
    }

    // MARK: - Coord
    struct Coord: Codable {
        let lon, lat: Double
    }

    // MARK: - Main
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let type, id: Int
        let country: String
        let sunrise, sunset: Int
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main, description, icon: String
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    // Callback when location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        if let location = location.first {
            manager.startUpdatingLocation()
            render (location)
        }
    }
    
    // Function to handle rendering weather data based on location
    func render(_ location: CLLocation){
        //Get latitude and longitude
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let APIKEY = "27fb6e2a2ede4c0cd82cb5e9b12da2c2"
        
        var urlString = ""
        
        print("City Name: "+destination!)
        
        //Append city name and apikey to the openweather url
        if(destination==""){
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKEY)"
        }else{
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(destination!),CA&appid=\(APIKEY)"
        }
        
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: urlString)
                        
        if let url = url {
            //create a variable to capture the data from the URL
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                //if URL is good then get the data and decode
                if let data = data {
                    // print(data)
                    let jsonDecorder = JSONDecoder()
                    do {
                        let readableData = try jsonDecorder.decode(Welcome.self, from: data)
                        print(readableData)
                        
                        DispatchQueue.main.async { [self] in
                            cityLable.text = readableData.name
                            weatherLable.text = readableData.weather[0].main
                            
                            if let imgURL = URL(string: "http://openweathermap.org/img/w/\(readableData.weather[0].icon).png") {
                                downloadImage(from: imgURL)
                            }
                            
                            //Convert kelvin temperature to celcius
                            temperatureLable.text = String(format: "%.0f", (readableData.main.temp - 273.15)) + " °"
                            
                            humidityLable.text = "Humidity : " + String(readableData.main.humidity) + "%"
                            
                            //convert m/s to km/h
                            windLable.text = "Wind : " +  String(format: "%.1f", (readableData.wind.speed * 3.6)) + " km/h"
                            
                            
                            //SAVE CORE DATA
                            //Create a CustomData object
                            let newCustomData = CustomData(context: self.content)
                                                        
                            if(self.destination != ""){
                                newCustomData.weatherCityName = self.destination
                                newCustomData.weatherTransaction = "Home"
                            }
                            
                            newCustomData.weatherTemp = String(format: "%.0f", (readableData.main.temp - 273.15)) + " °"
                            newCustomData.weatherHumidity = "Humidity : " + String(readableData.main.humidity) + "%"
                            newCustomData.weatherWind = "Wind : " +  String(format: "%.1f", (readableData.wind.speed * 3.6)) + " km/h"
                            newCustomData.weatherData = "Date: \(DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none))"
                            newCustomData.weatherTime = "Time: \(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .long))"
                            newCustomData.screenName = "Weather"
                                                        
                            //Save the data
                            do{
                                print("Success saving data!")
                                try self.content.save()
                            }catch{
                                print("Error saving data")
                            }
                            
                        }
                        
                    }catch {
                            print("Can't Decode")
                        }
                    }
                }
                dataTask.resume()
                dataTask.response
            }
    }
    
    var myData: [CustomData]?
    
    let content = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    //Download the icon and display from url
    func downloadImage(from imgURL: URL) {
        URLSession.shared.dataTask(with: imgURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.weatherIcon.image = image
                }
            }
        }.resume()
    }
    
    //Navigate to home
    @IBAction func homeButton(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    //add destination button
    @IBAction func addDestinationButton(_ sender: Any) {
        var textField = UITextField()
        
        //dismiss keyboard
        textField.resignFirstResponder()
        
        let alert = UIAlertController(title: "Where would you like to go? Enter your new destination.", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default){
            (cancel) in
        }
        
        let go = UIAlertAction(title: "Go", style: .default){
            (ok) in
            self.destination = textField.text
            self.manager.startUpdatingLocation()
        }
        
        alert.addTextField {(text) in
            textField = text
            textField.placeholder = "Enter Destination"
        }
        
        alert.addAction(cancel)
        alert.addAction(go)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //tab bar news button
    @IBAction func newsTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "NewsVC") as! NewsViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    //tab bar direction button
    @IBAction func directionTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "MapVC") as! MapViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    //tab bar weather button
    @IBAction func weatherTabBar(_ sender: Any) {
        self.manager.startUpdatingLocation()
    }
    
}
