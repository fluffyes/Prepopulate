//
//  Person.swift
//  Prepopulate
//
//  Created by Soulchild on 09/01/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import Foundation
import CoreData

enum RaceEnum: Int16 {
    case human = 0
    case goat = 1
    case skeleton = 2
    case flower = 3
}

extension Person {
    var raceEnum: RaceEnum {
        set {
            self.race = newValue.rawValue
        }
        get {
            return RaceEnum(rawValue: self.race) ?? .human // default is human if not set
        }
    }
    
    class func prepopulateUsingSeed() {
        let fileManager = FileManager.default
        
        // "<Path to your app folder>/Library/Application Support"
        let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!
        
        // By default, Core Data will use the "<Your app name>.sqlite" file inside Application Support Directory
        let databasePath = applicationSupportPath + "/Prepopulate.sqlite"
        let databaseShmPath = applicationSupportPath + "/Prepopulate.sqlite-shm"
        let databaseWalPath = applicationSupportPath + "/Prepopulate.sqlite-wal"
        
        // if there is already a sqlite database file, remove it (along with .sqlite-shm and .sqlite-wal)
        if(fileManager.fileExists(atPath: databasePath)){
            try? fileManager.removeItem(atPath: databasePath)
            try? fileManager.removeItem(atPath: databaseShmPath)
            try? fileManager.removeItem(atPath: databaseWalPath)
        }
        
        let seedPath = Bundle.main.path(forResource: "Seed", ofType: "sqlite")!
        let seedShmPath = Bundle.main.path(forResource: "Seed", ofType: "sqlite-shm")!
        let seedWalPath = Bundle.main.path(forResource: "Seed", ofType: "sqlite-wal")!
        
        do {
            // Old Apple method requires pointer to ObjcBool
            var isDir : ObjCBool = true
            
            // Create the Library/Application Support folder if it doesn't exist yet
            if !fileManager.fileExists(atPath: applicationSupportPath, isDirectory: &isDir){
                try fileManager.createDirectory(atPath: applicationSupportPath, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Copy over the database to the Application Support Folder
            try fileManager.copyItem(atPath: seedPath, toPath: databasePath)
            try fileManager.copyItem(atPath: seedShmPath, toPath: databaseShmPath)
            try fileManager.copyItem(atPath: seedWalPath, toPath: databaseWalPath)
        } catch {
            print("failed to copy over database files")
        }
        
        print("copied database file successfully!")
    }
}
