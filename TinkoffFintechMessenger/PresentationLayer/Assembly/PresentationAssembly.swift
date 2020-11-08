//
//  PresentationAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class PresentationAssembly: IPresentationAssembly {
    var serviceAssembly: IServicesAssembly
    
    // MARK: - Initializer
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - Public methods
    
    func baseNavigationViewController(rootViewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: rootViewController)
    }
    
    func conversationsListViewController() -> ConversationsListViewController {
        let conversationsListViewController = ConversationsListViewController()
        conversationsListViewController.presentationAssembly = self
        conversationsListViewController.dataProvider = serviceAssembly.conversationsDataProvider()
        conversationsListViewController.userDataProvider = serviceAssembly.gcdUserDataProvider()
        
        return conversationsListViewController
    }
    
    func conversationViewController(conversationName: String, channelId: String, userId: String) -> ConversationViewController {
        let vc = ConversationViewController()
        vc.dataProvider = serviceAssembly.conversationsDataProvider()
        vc.conversationName = conversationName
        vc.channelId = channelId
        vc.userId = userId
        return vc
    }
    
    func profileViewController(profileDataUpdatedHandler: @escaping () -> Void) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let profileViewController = storyboard.instantiateInitialViewController() as? ProfileViewController {
            profileViewController.profileDataUpdatedHandler = profileDataUpdatedHandler
            profileViewController.gcdDataProvider = serviceAssembly.gcdUserDataProvider()
            profileViewController.operationDataProvider = serviceAssembly.operationUserDataProvider()

            return profileViewController
        }
        
        return ProfileViewController()
    }
    
    func themesViewController() -> ThemesViewController {
        let themesViewController = ThemesViewController()
        themesViewController.themePickerDelegate = Appearance.shared
        return themesViewController
    }
    
    func createChannelAlertController(title: String?, message: String?) -> CreateChannelAlertController {
        return CreateChannelAlertController(title: title, message: message, preferredStyle: .alert)
    }
}
