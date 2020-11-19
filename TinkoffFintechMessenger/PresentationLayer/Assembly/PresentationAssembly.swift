//
//  PresentationAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class PresentationAssembly: IPresentationAssembly {
    
    // MARK: - Private properties
    
    private let serviceAssembly: IServicesAssembly
    
    // MARK: - Initializer
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - IPresentationAssembly
    
    func baseNavigationViewController(rootViewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: rootViewController)
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        let conversationsListViewController = ConversationsListViewController()
        conversationsListViewController.presentationAssembly = self
        conversationsListViewController.dataProvider = serviceAssembly.conversationsDataProvider()
        conversationsListViewController.userDataProvider = serviceAssembly.gcdUserDataProvider()
        conversationsListViewController.repository = serviceAssembly.channelsRepository()
        conversationsListViewController.logger = serviceAssembly.loggerService(sourceName: "ConversationsListViewController")
        return conversationsListViewController
    }
    
    func conversationViewController(conversationModel: ConversationModel, userId: String) -> ConversationViewController {
        let conversationViewController = ConversationViewController()
        conversationViewController.dataProvider = serviceAssembly.conversationsDataProvider()
        conversationViewController.model = conversationModel
        conversationViewController.repository = serviceAssembly.messagesRepository(channelId: conversationModel.identifier,
                                                                                   userId: userId)
        conversationViewController.logger = serviceAssembly.loggerService(sourceName: "ConversationViewController")
        return conversationViewController
    }
    
    func profileViewController(profileDataUpdatedHandler: @escaping () -> Void) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let profileViewController = storyboard.instantiateInitialViewController() as? ProfileViewController {
            profileViewController.presentationAssembly = self
            profileViewController.profileDataUpdatedHandler = profileDataUpdatedHandler
            profileViewController.gcdDataProvider = serviceAssembly.gcdUserDataProvider()
            profileViewController.operationDataProvider = serviceAssembly.operationUserDataProvider()
            
            return profileViewController
        }
        
        return ProfileViewController()
    }
    
    func themesViewController() -> ThemesViewController {
        let themesViewController = ThemesViewController()
        themesViewController.themeService = serviceAssembly.themeService()
        return themesViewController
    }
    
    func createChannelAlertController(title: String?, message: String?) -> CreateChannelAlertController {
        return CreateChannelAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func networkImagesViewController() -> NetworkImagesViewController {
        let networkImagesViewController = NetworkImagesViewController()
        return networkImagesViewController
    }
}
