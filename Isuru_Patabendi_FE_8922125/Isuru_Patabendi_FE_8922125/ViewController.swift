//
//  ViewController.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/4/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Press me to discover the world button
    @IBAction func pressToDiscover(_ sender: Any) {
        var textField = UITextField()
        
        //dismiss keyboard
        textField.resignFirstResponder()
        
        let alert = UIAlertController(title: "Where would you like to go? Enter your destination.", message: "", preferredStyle: .alert)
        
        //news
        let news = UIAlertAction(title: "News", style: .default){
            (ok) in
            
            let controller = self.storyboard?.instantiateViewController(identifier: "NewsVC") as! NewsViewController
            
            controller.destination = textField.text
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        //directions
        let direction = UIAlertAction(title: "Directions", style: .default){
            (ok) in
            
            //Map
            let controller = self.storyboard?.instantiateViewController(identifier: "MapVC") as! MapViewController

            controller.destination = textField.text
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        //weather
        let weather = UIAlertAction(title: "Weather", style: .default){
            (ok) in
            
            //Weather
            let controller = self.storyboard?.instantiateViewController(identifier: "WeatherVC") as! WeatherViewController
            
            controller.destination = textField.text
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        alert.addTextField {(text) in
            textField = text
            textField.placeholder = "Enter Destination"
        }
        
        alert.addAction(news)
        alert.addAction(direction)
        alert.addAction(weather)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    // CLLocationManager for handling location services
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //request to access user location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
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
        let controller = self.storyboard?.instantiateViewController(identifier: "WeatherVC") as! WeatherViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
}

