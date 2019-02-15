//
//  UIScreenShotTestUITests.swift
//  UIScreenShotTestUITests
//
//  Created by Анатолий on 15/02/2019.
//  Copyright © 2019 Анатолий. All rights reserved.
//

import XCTest


///
/// AutoScreen for 3 View Controller's:
/// - People
/// - Transfers
/// - Select
///
class UIScreenShotTestUITests: XCTestCase {
    
    struct LengButtons {
        
        enum LocalTypes {
            case en
            case ru
        }
        
        private var currentLocal: LocalTypes
        
        init(_ local: String) {
            if local == "en" {
                currentLocal = LocalTypes.en
            } else {
                currentLocal = LocalTypes.ru
            }
        }
        
        func peopleTab() -> String {
            switch currentLocal {
            case .en: return "People"
            case .ru: return "Люди"
            }
        }
        
        func tradeTab() -> String {
            switch currentLocal {
            case .en: return "Transfers"
            case .ru: return "Обмены"
            }
        }
    }
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() { }
    
    func testTrade() {
        
        // Check Localization
        let local = Locale.current.languageCode ?? "unowned"
        let localizationButton = LengButtons(local)
        
        
        // Create dependency of project
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        
        
        // Select tab Bar
        tabBarsQuery.buttons[localizationButton.peopleTab()].tap()
        
        
        // Wait Until Content is Load
        waitForElementToAppear(element: app.collectionViews.cells.element)
        
        
        // Make A ScreenShot
        let windowScreenshot0 = app.windows.firstMatch.screenshot()
        // Save ScreeenShot
        save(windowScreenshot0.image, with: "pepole_view_\(local).png")
        
        
        // Change Tab
        tabBarsQuery.buttons[localizationButton.transferTab()].tap()
        
        // Make A ScreenShot
        let windowScreenshot1 = app.windows.firstMatch.screenshot()
        // Save ScreeenShot
        save(windowScreenshot1.image, with: "transfer_view_\(local).png")
        
        // Tap For CollectionView Cell and Segue to Select Screen
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.otherElements.containing(.staticText, identifier:localizationButton.transferTab()).children(matching: .other).element(boundBy: 2).children(matching: .button).element.tap()
        
        // Select Two Cells in CollectionView
        let cellsQuery = collectionViewsQuery.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"19064").element.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"19020").element.tap()
        
        let element = cellsQuery.otherElements.containing(.staticText, identifier:"6589").element
        element.tap()
        element.tap()
        
        // Make A ScreenShot
        let windowScreenshot2 = app.windows.firstMatch.screenshot()
        // Save ScreeenShot
        save(windowScreenshot2.image, with: "create_transfer_\(local).png")
        
    }
    
    func save(_ chosenImage: UIImage, with name: String) {
        // TODO: Here, you can specify the path to the project.
        let directoryPath = "/Users/\(Your Name)/Documents/\(Folder)/"
        
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let filepath = directoryPath.appending(name)
        let url = NSURL.fileURL(withPath: filepath)
        
        do {
            let image = chosenImage.pngData()
            try image?.write(to: url)
            
        } catch {
            print(error)
        }
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: #file, atLine: Int(#line), expected: true)
            }
        }
    }
}

