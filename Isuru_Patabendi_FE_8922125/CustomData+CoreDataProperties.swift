//
//  CustomData+CoreDataProperties.swift
//  Isuru_Patabendi_FE_8922125
//
//  Created by user235715 on 12/11/23.
//
//

import Foundation
import CoreData


extension CustomData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomData> {
        return NSFetchRequest<CustomData>(entityName: "CustomData")
    }

    @NSManaged public var mapEndPoint: String?
    @NSManaged public var screenName: String?
    @NSManaged public var mapStartPoint: String?
    @NSManaged public var mapTotalDistance: String?
    @NSManaged public var mapTransaction: String?
    @NSManaged public var mapTravelMethod: String?
    @NSManaged public var newsAuthor: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsSource: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var newsTransaction: String?
    @NSManaged public var weatherCityName: String?
    @NSManaged public var weatherData: String?
    @NSManaged public var weatherHumidity: String?
    @NSManaged public var weatherTemp: String?
    @NSManaged public var weatherTime: String?
    @NSManaged public var weatherTransaction: String?
    @NSManaged public var weatherWind: String?
    @NSManaged public var newsCityName: String?
    @NSManaged public var mapCityName: String?

}

extension CustomData : Identifiable {

}
