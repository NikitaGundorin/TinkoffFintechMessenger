//
//  DummyDataProvider.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 24.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class DummyDataProvider: DataProvider {
    
    func getUser() -> Person {
        .init(firstName: "Nikita", secondName: "Gundorin", profileImage: nil)
    }
    
    func getConversations() -> [ConversationCellModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return [
            .init(name: "Ronald Robertson",
                  message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                  date: Date(),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(name: "Johnny Watson",
                  message: "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis.",
                  date: dateFormatter.date(from: "2020-09-28") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(name: "Martha Craig",
                  message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                  date: dateFormatter.date(from: "2020-09-28") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: true),
            .init(name: "Arthur Bell",
                  message: "Voluptate irure aliquip consectetur commodo ex ex.",
                  date: dateFormatter.date(from: "2020-09-25") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Jane Warren",
                  message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                  date: dateFormatter.date(from: "2020-09-16") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Morris Henry",
                  message: "Commodo ligula eget dolor. Aenean massa. Cum sociis natoque.",
                  date: dateFormatter.date(from: "2020-08-27") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Irma Flores",
                  message: "",
                  date: dateFormatter.date(from: "2020-08-01") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Colin Williams",
                  message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                  date: dateFormatter.date(from: "2020-07-15") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Cataleya Levy",
                  message: "",
                  date: dateFormatter.date(from: "2020-07-06") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Beatriz Garner",
                  message: "",
                  date: dateFormatter.date(from: "2020-06-01") ?? Date(),
                  isOnline: true,
                  hasUnreadMessages: false),
            .init(name: "Ronald Robertson",
                  message: "Penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
                  date: Date(),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(name: "Rui Roman",
                  message: "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
                  date: Date(),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(name: "Brenda Fisher",
                  message: "Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec.",
                  date: dateFormatter.date(from: "2020-09-26") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: true),
            .init(name: "Ami Samuels",
                  message: "Valputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nulla dictum felis eu pede.",
                  date: dateFormatter.date(from: "2020-09-25") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Muhammad Holland",
                  message: "Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi.",
                  date: dateFormatter.date(from: "2020-09-22") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Carrie-Ann Meyers",
                  message: "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac.",
                  date: dateFormatter.date(from: "2020-09-28 13:21") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Lilian Mcfarlane",
                  message: "",
                  date: dateFormatter.date(from: "2020-08-31") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Carrie Foley",
                  message: "Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.",
                  date: dateFormatter.date(from: "2020-08-12") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Saoirse Grant",
                  message: "Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum.",
                  date: dateFormatter.date(from: "2020-06-28") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            .init(name: "Spike Curry",
                  message: "",
                  date: dateFormatter.date(from: "2020-05-01") ?? Date(),
                  isOnline: false,
                  hasUnreadMessages: false),
            ]
    }
}
