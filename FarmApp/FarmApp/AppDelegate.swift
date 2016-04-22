//
//  AppDelegate.swift
//  FarmApp
//
//  Created by Patrick Little on 8/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var plants : [Plant] = []


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        readPlantsFromDataBase()
        return true
    }
    
    func readBestSeasons(seasons: AnyObject?!) -> [String]{
        var seasonsToAdd = [String]()
        if let seasonsDict = seasons as? NSDictionary{
            for season in seasonsDict {
                seasonsToAdd.append(season.value as! String)
            }
        }
        return seasonsToAdd
        
    }
    

    
    func readPlantsFromDataBase(){
        var plantsRef: Firebase!
        plantsRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Plants_Test")
        plantsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let seasons = snapshot.value["Best_Seasons"]
            let seasonsToAdd = self.readBestSeasons(seasons)
            let totalWeight = snapshot.value["Total_Weight"] as! Float
            let name = snapshot.value["Plant_Name"] as! String
            let notesVal = snapshot.value["Plant_Notes"]
            var notes = ""
            if let notesTemp = notesVal as? String{
                notes = notesTemp
            }
            
            let varietiesVal = snapshot.value["Varieties"]
            var varietiesToAdd = [Variety]()
            if let varietiesDict = varietiesVal as? NSDictionary {
                for variety in varietiesDict{
                    let seasons = variety.value["Best_Seasons"]
                    let seasonsToAdd = self.readBestSeasons(seasons)
                    let totalWeight = variety.value["Total_Weight"] as! Float
                    //let plantName = variety.value["Plant_Name"] as! String
                    let varietyName = variety.value["Variety_Name"] as! String
                    let varietyNotes = variety.value["Variety_Notes"] as! String
                    var bedHistoryToAdd = [BedHistory]()
                    var bedHistoryVals = variety.value["Bed_History"]
                    if let bedHistoryDict = bedHistoryVals as? NSDictionary{
                        for bedHistory in bedHistoryDict{
                            let bedID = bedHistory.value["BH_Bed_ID"] as! Int
                            let sectID = bedHistory.value["BH_Sect_ID"] as! Int
                            let date = bedHistory.value["BH_Date"] as! NSDictionary
                            let year = date.valueForKey("year") as! Int
                            let month = date.valueForKey("month") as! Int
                            let day = date.valueForKey("day") as! Int
                            let newDate = Date(year: year, month: month, day: day)
                            let newBedHistory = BedHistory(date: newDate, sectID: sectID, bedID: bedID)
                            bedHistoryToAdd.append(newBedHistory)
                        }
                    }
                    
                    let newVariety = Variety(name: varietyName, bestSeasons: seasonsToAdd, notes: varietyNotes, bedHistory: bedHistoryToAdd, plant: nil, varietyWeight: totalWeight)
                    varietiesToAdd.append(newVariety)
                }
            }
            
            let newPlant = Plant(name: name, bestSeasons: seasonsToAdd, notes: notes, varieties: varietiesToAdd, weight: totalWeight)
            for variety in newPlant.varieties{
                variety.plant = newPlant
            }
            self.plants.append(newPlant)
            LibraryAPI.sharedInstance.setPlants(self.plants)
            
            
            
        })
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        //send to database
        LibraryAPI.sharedInstance.saveAllDataToDB()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //send to database
        LibraryAPI.sharedInstance.saveAllDataToDB()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //send to database
        LibraryAPI.sharedInstance.saveAllDataToDB()
    }


}

