//
//  FarmAppTests.swift
//  FarmAppTests
//
//  Created by Patrick Little on 8/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import XCTest
@testable import FarmApp

class FarmAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDatePrint(){
        let date1 = Date(year: 2014, month: 3, day: 4)
        XCTAssert(date1.printSlash() == "3/4/2014")
        
    }
    func testBedHistoryPrint(){
        let variety1 = Variety(name: "Wheat", bestSeasons: [], notes: [], bedHistory: BedHistory())
        let date1 = Date(year: 2014, month: 3, day: 4)
        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),dateHarvested: Date(year: 2016,month: 1,day: 1),notes: ["test"],variety: variety1)
        let cropHistory1 = CropHistory(numCrops: 1, crops: [crop1])
        let bed1 = Bed(id: 1, currentCrop: crop1, cropHistory: cropHistory1)
        
        let bedHistory = BedHistory(date: date1, bed: bed1)
        print("hi")
        
       XCTAssert(bedHistory.print() == ("\(date1.printSlash())" + " Bed: " + bed1.getID() + "\n"), bedHistory.print())
       
    }
}
