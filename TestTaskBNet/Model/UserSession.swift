//
//  UserSession.swift
//  TestTaskBNet
//
//  Created by Ирина Соловьева on 14/05/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import Foundation


//синглтон для хранения токена и сессии

class UserSession {
    
    static let instance = UserSession()
    
    private init(){}
    
    var token: String = "Zpm787z-tc-5K20Wey"
    var session: String = ""
    
    
}
