//
//  NetworkStatusError.swift
//  AANetwork
//
//  Created by Amir Ardalan on 5/5/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
enum NetworkStatusError:Int,Error{
    case Bad_Request                                = 400
    case Not_Authorized_to_access_this_service      = 401
    case Method_not_supported                       = 405
    case Token_expired                              = 420
    case Token_Already_Exist                        = 421
    case Server_error                               = 500
    case Invalid_credentials_supplied               = 600
    case User_Expired                               = 601
    case Data_Overused                              = 602
    case Maximum_Limitation_Per_User                = 603
    case Pin_Depleted                               = 604
    case Already_Login                              = 605
    case User_is_not_logged_in                      = 606
    case PIN_is_disabled                            = 607
}
