//
//  MapViewController.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/4/23.
//

import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Outlets for UI elements
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var slider: UISlider!
    //transport types
    @IBOutlet var buttonCar: UIButton!
    @IBOutlet var buttonBike: UIButton!
    @IBOutlet var buttonWalking: UIButton!
    
    // Variable to store entered destination
    var destination: String?
    var startCityName = ""
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var totalDistance = 0.00
    
    // CLLocationManager for handling location services
    let manager = CLLocationManager()
    
    //map zoom
    var zoom = 3.0
    //map transport type
    var transportType = "automobile"

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        myMap.delegate = self
        
        convertAddress()
        
        //slider value
        slider.minimumValue = 0.0
        slider.maximumValue = 6.0
        slider.value = 3.0
//        slider.value = Float(currentDirection)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
//    Navigate home
    @IBAction func home(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    //called when the slider value changed
    @objc func sliderValueChanged(_ sender: UISlider){
        //update the cirrent direction
        zoom = Double(sender.value)
//        currentDirection = Double(sender.value)
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
            self.convertAddress()
        }
        
        alert.addTextField {(text) in
            textField = text
            textField.placeholder = "Enter Destination"
        }
        
        alert.addAction(cancel)
        alert.addAction(go)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //transport type car
    @IBAction func typeCar(_ sender: Any) {
        transportType = "automobile"
        buttonCar.backgroundColor = UIColor.systemCyan
        buttonBike.backgroundColor = UIColor.systemBackground
        buttonWalking.backgroundColor = UIColor.systemBackground
        convertAddress()
    }
    
    //transport type bike
    @IBAction func typeBike(_ sender: Any) {
        transportType = "bike"
        buttonCar.backgroundColor = UIColor.systemBackground
        buttonBike.backgroundColor = UIColor.systemCyan
        buttonWalking.backgroundColor = UIColor.systemBackground
        convertAddress()
    }
    
    //transport type walking
    @IBAction func typeWalking(_ sender: Any) {
        transportType = "walking"
        buttonCar.backgroundColor = UIColor.systemBackground
        buttonBike.backgroundColor = UIColor.systemBackground
        buttonWalking.backgroundColor = UIColor.systemCyan
        convertAddress()
    }
    
//    var currentDirection: Double = 0.0 {
//        didSet{
//            //Update the direction lable and rotate the compass needle
//            testLable.text = "\(Int(currentDirection))°"
////            let angle = CGFloat(currentDirection) * .pi/180.0
////            compassImageView.transform = CGAffineTransform(rotationAngle: angle)
//        }
//    }
    
    //location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        
        //get the first location
        startLocation = location.first
        
        if let location = location.first {
            manager.startUpdatingLocation()
            render (location)
        }
        
        //get the last location
        lastLocation = location.last
    }
    
    //render location, show pins and path
    func render(_ location: CLLocation){
        let coordinate  = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // reverse geocode the start location to get starting city name
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("Reverse geocoding failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
               
            // set starting city as name
            if let city = placemark.locality {
                // Update the UI with the city name
                self.startCityName = city
            }
        }
        
        //span settings determine how much to zoom into the map
        let span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        myMap.addAnnotation(pin)
        myMap.setRegion(region, animated: true)
    }
    
    //convert address
    func convertAddress(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(destination!){
            (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else{
                print("No location found")
                return
            }
            print("START & END")
            print("START Location: \(self.startCityName)")
            print("END Location: \(self.destination!)")
                        
            self.mapThis(destinationCor: location.coordinate)
        }
    }
    
    //map view
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        routeline.strokeColor = .blue
        
        return routeline
    }
    
    //show on map
    func mapThis(destinationCor: CLLocationCoordinate2D){
        let sourceCoordinate = (manager.location?.coordinate)!
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCor)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        
        //start and end
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        //transport type
        if(transportType=="automobile"){
            destinationRequest.transportType = .automobile
        }else if (transportType=="bike"){
            destinationRequest.transportType = .automobile
        }else if (transportType=="walking"){
            destinationRequest.transportType = .walking
        }
        
        //one route = false, multi = true
        destinationRequest.requestsAlternateRoutes = true
        
        //submit request to calculate directions
        let directions = MKDirections(request: destinationRequest)
        
        directions.calculate { (response, error) in
            //if there is a response make it the response else make error
            guard let response = response
            else {
                if let error = error {
                    print("Something went wrong!")
                }
                return
            }
            
            //remove previous overlays and pins
            self.myMap.removeOverlays(self.myMap.overlays)
            self.myMap.removeAnnotations(self.myMap.annotations)

            
            //we want the first response
            let route = response.routes[0]
            
            //adding overlay to routes
            self.myMap.addOverlay(route.polyline)
            self.myMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            //setting endpoint pin
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: destinationCor.latitude, longitude: destinationCor.longitude)
            pin.coordinate = coordinate
//            pin.title = "END POINT"
            self.myMap.addAnnotation(pin)
                   
            //calculate total distance in meters
            self.totalDistance += self.lastLocation.distance(from: self.startLocation)
            
            //SAVE CORE DATA
            //Create a CustomData object
            let newCustomData = CustomData(context: self.content)
            
            newCustomData.mapStartPoint = self.startCityName
            if(self.destination != ""){
                newCustomData.mapEndPoint = self.destination
                newCustomData.mapTransaction = "Home"
            }
            newCustomData.mapTravelMethod = self.transportType
            newCustomData.screenName = "Direction"
            newCustomData.mapTotalDistance = String(format: "%.2f", self.totalDistance/1000) + " km"
            
            //Save the data
            do{
                print("Success saving data!")
                try self.content.save()
            }catch{
                print("Error saving data")
            }
        }
    }
    
    var myData: [CustomData]?
    
    let content = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    //tab bar news button
    @IBAction func newsTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "NewsVC") as! NewsViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    //tab bar direction button
    @IBAction func directionTabBar(_ sender: Any) {
        convertAddress()
    }
    
    //tab bar weather button
    @IBAction func weatherTabBar(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "WeatherVC") as! WeatherViewController
        controller.destination = ""
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
