//
//  ModelManager.swift
//  Vaidya PIM
//
//  Created by Vaidya, Raghavendra (GE Global Research) on 7/16/16.
//  Copyright © 2016 Vaidya, Raghavendra (GE Global Research). All rights reserved.
//

import Foundation

let sharedInstance = ModelManager()

class ModelManager: NSObject {


    var database: FMDatabase? = nil
    
    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Utility.getPath("Vaidya_PIM.db"))
        }
        return sharedInstance
    }

    
    class func purgeDB () -> Bool
    {
        
        getInstance()
        sharedInstance.database?.open()
        var isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Categories", withArgumentsInArray:nil)
        isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Accounts", withArgumentsInArray:nil)
        sharedInstance.database!.close()
        return isDeleted
        
    }
    
    
    class func getTagProperties(tag : String) -> Account
    {
        getInstance()
        var catArray: [String] = []
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Accounts where Account_Tag=?",  withArgumentsInArray: [tag])
        var act : Account = Account()
        if (resultSet != nil) {
            while resultSet.next() {
                _ = resultSet.resultDictionary().count
            if resultSet.stringForColumn("Address") != nil {
                act.Address = resultSet.stringForColumn("Address")
            }
            if resultSet.stringForColumn("Description") != nil {
                act.Description = resultSet.stringForColumn("Description")
            }
            if resultSet.stringForColumn("Name") != nil {
                act.Name = resultSet.stringForColumn("Name")
            }
            if resultSet.stringForColumn("Number") != nil {
                act.Number = resultSet.stringForColumn("Number")
            }
            if resultSet.stringForColumn("PWD") != nil {
                act.PWD = resultSet.stringForColumn("PWD")
            }
            if resultSet.stringForColumn("UID") != nil {
                act.UID = resultSet.stringForColumn("UID")
            }
            if resultSet.stringForColumn("Web_Address") != nil {
                act.web_address = resultSet.stringForColumn("Web_Address")
            }
        }
        }

        return act
    }
    
    class func addCategories(cat : [String]) -> Bool {
        
        getInstance()
        var isInserted = false
        sharedInstance.database!.open()
        
        for category in cat {
            isInserted = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Categories (Categroy_Name, Category_Desc) VALUES (?, ?)", withArgumentsInArray: [category, category])
        }
        sharedInstance.database!.close()
        return isInserted
    }
    
    
    
    class func getCategories() -> [String]
    
    {
     getInstance()
        var catArray: [String] = []
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Categories", withArgumentsInArray: nil)
        if (resultSet != nil) {
            while resultSet.next() {
                _ = resultSet.resultDictionary().count
                catArray.append(resultSet.stringForColumn("Categroy_Name"))
            }
        }
        return catArray

    }
    
    
    class func addTagsForCat(cat : String, tag : String) -> Bool
    {
        getInstance()
        var retVal : Bool = false
        sharedInstance.database!.open()
        retVal = sharedInstance.database!.executeUpdate("INSERT OR IGNORE INTO Accounts (Category, Account_Tag) VALUES (?, ?)", withArgumentsInArray: [cat, tag])
        return retVal
        
    }
    
    
    class func updateTagData(tag : String, data : Dictionary<String,String>) -> Bool
        {
            sharedInstance.database!.open()
            let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Accounts SET Number=?, Description=?, Address=?, Name=?,Web_Address=?, UID=?, PWD=? WHERE Account_Tag=?", withArgumentsInArray: [data["number"]!, data["description"]!,data["address"]!,data["name"]!,data["web_address"]!,data["uid"]!,data["pwd"]!,tag])
            sharedInstance.database!.close()
            return isUpdated
    }

    
    
    class func getTagsForCat(cat : String) -> [String]
    {
        var tags : [String] = []
        
        getInstance()
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT Account_Tag FROM Accounts where Category=?", withArgumentsInArray: [cat])
        if (resultSet != nil) {
            while resultSet.next() {
                tags.append(resultSet.stringForColumn("Account_Tag"))
            }
        }
        return tags
    }
    
    
    
/*
    
    func addStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO student_info (Name, Marks) VALUES (?, ?)", withArgumentsInArray: [studentInfo.Name, studentInfo.Marks])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE student_info SET Name=?, Marks=? WHERE RollNo=?", withArgumentsInArray: [studentInfo.Name, studentInfo.Marks, studentInfo.RollNo])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteStudentData(studentInfo: StudentInfo) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM student_info WHERE RollNo=?", withArgumentsInArray: [studentInfo.RollNo])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM student_info", withArgumentsInArray: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let studentInfo : StudentInfo = StudentInfo()
                studentInfo.RollNo = resultSet.stringForColumn("RollNo")
                studentInfo.Name = resultSet.stringForColumn("Name")
                studentInfo.Marks = resultSet.stringForColumn("Marks")
                marrStudentInfo.addObject(studentInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }

 */
 
}