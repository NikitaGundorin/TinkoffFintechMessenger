//
//  RootAssembly.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 07.11.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
