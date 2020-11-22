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
    
    func object(at indexPath: IndexPath) -> ChannelModel? {
        let channel = super.object(at: indexPath)
        return ChannelModel(channel: channel)
    }
    
    func fetchedObjects() -> [ChannelModel]? {
        guard let channels = super.fetchedObjects() else { return nil }
        return channels.compactMap { ChannelModel(channel: $0) }
    }
}
