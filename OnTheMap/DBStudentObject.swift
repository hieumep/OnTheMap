//
//  DBStudentObject.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

struct StudentObject{
    /*
    var objectId :String? = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
*/
    var objectId :String?
    var uniqueKey :String
    var firstName :String
    var lastName :String
    var mapString :String
    var mediaURL :String
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    init(){
        objectId = ""
        uniqueKey = ""
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        latitude = 0.0
        longitude = 0.0
    }
    
    init(dictStudents : [String : AnyObject]){
        objectId = dictStudents[DBClient.StudentObjectkeys.objectId] as? String
        uniqueKey = dictStudents[DBClient.StudentObjectkeys.uniqueKey] as! String
        firstName = dictStudents[DBClient.StudentObjectkeys.firstName] as! String
        lastName = dictStudents[DBClient.StudentObjectkeys.lastName] as! String
        mapString = dictStudents[DBClient.StudentObjectkeys.mapString] as! String
        mediaURL = dictStudents[DBClient.StudentObjectkeys.mediaURL] as! String
        latitude = dictStudents[DBClient.StudentObjectkeys.latitude] as! Double
        longitude = dictStudents[DBClient.StudentObjectkeys.longitude] as! Double
    }
    
    static func SOFromResults(results: [[String : AnyObject]]) -> [StudentObject] {
        var studentObjects = [StudentObject]()
        
        for result in results {
            studentObjects.append(StudentObject(dictStudents: result))
        }
        
        return studentObjects
    }

}
