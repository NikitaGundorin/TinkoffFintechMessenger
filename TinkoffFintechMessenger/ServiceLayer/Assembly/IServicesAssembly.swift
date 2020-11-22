//
//  IServicesAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    func conversationsDataProvider() -> IConversationsDataProvider
    func gcdUserDataProvider() -> IUserDataProvider
    func operationUserDataProvider() -> IUserDataProvider
    func themeService() -> IThemeService
    func channelsRepository() -> IChannelsRepository
    func messagesRepository(channelId: String, userId: String) -> IMessagesRepository
    func loggerService(sourceName: String) -> ILoggerService
}
