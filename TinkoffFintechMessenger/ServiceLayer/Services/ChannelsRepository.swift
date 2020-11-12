//
//  ChannelsRepository.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 12.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class ChannelsRepository: Repository<Channel_db>, IChannelsRepository {
    
    // MARK: - IChannelsRepository
    
    func object(at indexPath: IndexPath) -> ChannelViewModel? {
        let channel = super.object(at: indexPath)
        return ChannelViewModel(channel: channel)
    }
    
    func fetchedObjects() -> [ChannelViewModel]? {
        guard let channels = super.fetchedObjects() else { return nil }
        return channels.compactMap { ChannelViewModel(channel: $0) }
    }
}
