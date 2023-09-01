//
//  MovieDB+CoreDataProperties.swift
//  
//
//  Created by Adhitya Bagas on 01/09/23.
//
//

import Foundation
import CoreData


extension MovieDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDB> {
        return NSFetchRequest<MovieDB>(entityName: "MovieDB")
    }

    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool

}
