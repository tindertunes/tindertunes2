//
//  SettingsModels.swift
//  tindertunes
//
//  Created by Sydney Chiang on 3/18/21.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
    
}

struct Option{
    let title: String
    let handler: () -> Void
}
