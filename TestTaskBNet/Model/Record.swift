//
//  Record.swift
//  TestTaskBNet
//
//  Created by Ирина Соловьева on 14/05/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import Foundation


class Record {
    var body: String
    var da: Date
    var dm: Date
    
    init(body: String, da: Date, dm: Date) {
        self.body = body
        self.da = da
        self.dm = dm
    }

}
