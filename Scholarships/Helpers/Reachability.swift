//
//  Reachability.swift
//  Bagasse
//
//  Created by TCASSEMBLER on 11/24/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import SystemConfiguration

/**
* Reachability
* Class for checking network
*
* @author TCASSEMBLER
* @version 1.0
*/
public class Reachability {
    
    /**
     Checking if the device is connected to a network
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}