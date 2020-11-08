//
//  IPresentationAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    func baseNavigationViewController(rootViewController: UIViewController) -> BaseNavigationController
    func conversationsListViewController() -> ConversationsListViewController
    func conversationViewController(conversationName: String, channelId: String, userId: String) -> ConversationViewController
    func profileViewController(profileDataUpdatedHandler: @escaping () -> Void) -> ProfileViewController
    func themesViewController() -> ThemesViewController
    func createChannelAlertController(title: String?, message: String?) -> CreateChannelAlertController
}
