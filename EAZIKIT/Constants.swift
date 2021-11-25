//
//  Constants.swift
//  EAZIKIT
//
//  Created by APPLE on 12/11/18.
//  Copyright © 2018 Jobesk Inc. All rights reserved.
//

import Foundation
import SwiftyJSON



let BASE_URL = "http://eazkit.jobesk.com/"
let IMAGE_BASE_URL = "http://eazkit.jobesk.com/api/public"

var FIRST_TIME = String()
var SECOND_TIME = String()
var THIRD_TIME =  String()
var FIRST_IMAGE = String()
var DAILY_TIME = String()
var WHITEN_DAY = String()
var SESSIONS = JSON()
let DEFAULTS = UserDefaults.standard

func CHECK_EMAIL(testStr:String) -> Bool
{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}


var PRE_SESSION_IMAGE = String()
var PRE_SESSION_TIME = String()




