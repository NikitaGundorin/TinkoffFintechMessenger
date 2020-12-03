//
//  GCDDataManagerTests.swift
//  MessengerTests
//
//  Created by Nikita Gundorin on 01.12.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

@testable import Messenger
import XCTest

class GCDDataManagerTests: XCTestCase {

    func testUserIdIsRecievedSuccessfully() throws {
        // Arrange
        let dataManagerMock = DataManagerMock()
        dataManagerMock.userId = "CF6BBCB5-5F06-428D-AF11-E04612BED8F6"
        let gcdUserDataProvider = GCDUserDataProvider(dataManager: dataManagerMock)
        let expectation = self.expectation(description: "Getting user data")
        var recievedId: String?
        
        // Act
        gcdUserDataProvider.getUserId { id in
            recievedId = id
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertEqual(recievedId, dataManagerMock.userId)
        XCTAssertEqual(dataManagerMock.getUserIdCount, 1)
    }
    
    func testUserDataIsLoadedSuccessfully() throws {
        // Arrange
        let dataManagerMock = DataManagerMock()
        let fileName = "fileName"
        let userData = User(fullName: "Nikita Gundorin",
                            description: "iOS developer",
                            imageFileName: fileName)
        let userImageData = UIImage(named: "logo")?.pngData()
        dataManagerMock.userData = userData
        dataManagerMock.userImageData = userImageData
        let gcdUserDataProvider = GCDUserDataProvider(dataManager: dataManagerMock)
        let expectation = self.expectation(description: "Loading user data")
        var recievedUserModel: UserModel?
        
        // Act
        gcdUserDataProvider.loadUserData { user in
            recievedUserModel = user
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertEqual(recievedUserModel?.fullName, userData.fullName)
        XCTAssertEqual(recievedUserModel?.description, userData.description)
        XCTAssertTrue(recievedUserModel?.profileImage?.isEqual(to: UIImage(data: userImageData ?? Data())) ?? false)
        XCTAssertEqual(dataManagerMock.loadUserDataCount, 1)
        XCTAssertEqual(dataManagerMock.loadUserImageCount, 1)
        XCTAssertEqual(dataManagerMock.recievedImageFileName, fileName)
    }
    
    func testUserDataWithoutImageIsLoadedSuccessfully() throws {
        // Arrange
        let dataManagerMock = DataManagerMock()
        let userData = User(fullName: "Nikita Gundorin",
                            description: "iOS developer",
                            imageFileName: nil)
        dataManagerMock.userData = userData
        let gcdUserDataProvider = GCDUserDataProvider(dataManager: dataManagerMock)
        let expectation = self.expectation(description: "Loading user data without image")
        var recievedUserModel: UserModel?
        
        // Act
        gcdUserDataProvider.loadUserData { user in
            recievedUserModel = user
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertEqual(recievedUserModel?.fullName, userData.fullName)
        XCTAssertEqual(recievedUserModel?.description, userData.description)
        XCTAssertNil(recievedUserModel?.profileImage)
        XCTAssertEqual(dataManagerMock.loadUserDataCount, 1)
        XCTAssertEqual(dataManagerMock.loadUserImageCount, 1)
        XCTAssertNil(dataManagerMock.recievedImageFileName)
    }
    
    func testUserDataIsSavedSuccessfully() throws {
        // Arrange
        let fullName = "Nikita"
        let description = "iOS developer"
        let imageUrl = "url"
        let image = UIImage(named: "logo")
        let dataManager = DataManagerMock()
        dataManager.userDataSaved = true
        dataManager.userImageUrl = imageUrl
        let gcdUserDataProvider = GCDUserDataProvider(dataManager: dataManager)
        let expectation = self.expectation(description: "Saving data")
        var isSavedSuccessfully = false
        
        // Act
        gcdUserDataProvider.saveUserData(UserModel(fullName: fullName,
                                                   description: description,
                                                   profileImage: image)) { isSuccessful in
                                                    isSavedSuccessfully = isSuccessful
                                                    expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Assert
        XCTAssertTrue(isSavedSuccessfully)
        XCTAssertEqual(dataManager.saveUserDataCount, 1)
        XCTAssertEqual(dataManager.saveUserImageCount, 1)
        XCTAssertEqual(dataManager.recievedImageData, image?.pngData())
        XCTAssertEqual(dataManager.recievedUser?.fullName, fullName)
        XCTAssertEqual(dataManager.recievedUser?.description, description)
        XCTAssertEqual(dataManager.recievedUser?.imageFileName, imageUrl)
    }
    
    func testUserDataWithoutImageIsSavedSuccessfully() throws {
        // Arrange
        let fullName = "Nikita"
        let description = "iOS developer"
        let dataManager = DataManagerMock()
        dataManager.userDataSaved = true
        let gcdUserDataProvider = GCDUserDataProvider(dataManager: dataManager)
        let expectation = self.expectation(description: "Saving data without image")
        var isSavedSuccessfully = false
        
        // Act
        gcdUserDataProvider.saveUserData(UserModel(fullName: fullName,
                                                   description: description,
                                                   profileImage: nil)) { isSuccessful in
            isSavedSuccessfully = isSuccessful
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil )
        
        // Assert
        XCTAssertTrue(isSavedSuccessfully)
        XCTAssertEqual(dataManager.saveUserDataCount, 1)
        XCTAssertEqual(dataManager.saveUserImageCount, 1)
        XCTAssertNil(dataManager.recievedImageData)
        XCTAssertEqual(dataManager.recievedUser?.fullName, fullName)
        XCTAssertEqual(dataManager.recievedUser?.description, description)
        XCTAssertNil(dataManager.recievedUser?.imageFileName)
    }
}
