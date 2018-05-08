//
//  RealmMigration.swift
//  FlyPass
//
//  Created by Daniel Klinkert Houfer on 5/8/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

let newDBVersion:UInt64 = 1

class RealmMigration {
    
    
    class func realmMigrate() {
        
        let currentVersion = Realm.Configuration.defaultConfiguration.schemaVersion
        
        if currentVersion == newDBVersion {
            //db updated
            return
        }
        
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            
            print("Migration complete.")
        }
        
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: newDBVersion, migrationBlock: migrationBlock)
        
    }
}
