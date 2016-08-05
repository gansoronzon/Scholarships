//
//  ScholarshipsAPI.swift
//  Scholarships
//
//  Created by Gansoronzon on 5/22/16.
//  Copyright © 2016 Gansoronzon. All rights reserved.
//

//API BASE URL
let apiBaseURL : String = "http://www.findscholarshipsabroad.com"

//API extension url's
let urlGetScholarhipList = apiBaseURL + "/admin/json/scholarshipsList.php"

import UIKit

class ScholarshipsAPI: AFHTTPSessionManager {
    
    //api error
    let errNone       = 0
    let errServer     = 1
    let errNetwork    = 2
    let errUserCancel = 3
    
    struct Singleton {
        static let sharedInstance = ScholarshipsAPI(baseURL: NSURL(string: "http://www.findscholarshipsabroad.com"), sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    class var sharedInstance: ScholarshipsAPI {
        return Singleton.sharedInstance
    }
    
    override init(baseURL url: NSURL!, sessionConfiguration configuration: NSURLSessionConfiguration!) {
        super.init(baseURL: url, sessionConfiguration: configuration)
        if !self.isEqual(nil) {
            self.responseSerializer = AFJSONResponseSerializer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Input: api url, post parameter(nsdictionary)
     
     Output: NSDictionary value
     response: -> serverees butsaj irex data
     error: -> aldaanii torol
     
     error type
     0: no error
     1: server error
     2: internet error
     3: empty data
     4: cancel request by user
     */
    func requestServer(api: String, dicParams: NSDictionary, completion: (result: NSDictionary) -> Void) {
        
        var response: NSDictionary!
        
        self.postServer(api, dicParams: dicParams) { (data, error) -> () in
            
            if data != nil {
                if let dicResult: NSDictionary = data?.objectForKey("response") as AnyObject? as? NSDictionary {
                    //response data irsen
                    response = [ "response" : dicResult, "error" : 0]
                }
                else {
                    //json error
                    response = [ "response" : "", "error" : 1]
                }
            }
            else {
                //error
                if error?.code == -999 {
                    //user cancel
                    response = [ "response" : "", "error" : 4]
                }
                else if error?.code == -1011 || error?.code == -1001 || error?.code == -1005 {
                    // server aldaa 50x, request time out
                    response = [ "response" : "", "error" : 1]
                }
                else if error?.code != -999 || error?.code != -1011 || error?.code != -1001 || error?.code != -1005 {
                    //network error
                    response = [ "response" : "", "error" : 2]
                }
            }
            
            completion(result: response)
        }
    }
    
    //MARK: Sample
    /* sample
     
     func getGardenList() {
     
     //set parameter
     var dicFormData: NSDictionary = [
     "type_id" : typeID,
     "page_index" : intPageIndex,
     "district_id" : intDiscrictID]
     
     networkManager.requestServer(urlGetGardensList, dicParams: dicFormData, completion: { (result) -> Void in
     
     let intErrorCode: Int = result.objectForKey("error") as! Int
     
     switch intErrorCode {
     case errNone :
     // aldaagui uyed iishee orj irne
     //parse json
     
     let json: NSDictionary = result.objectForKey("response") as! NSDictionary
     let array: NSArray = json.objectForKey("gardens") as! NSArray
     for item in array {
     //do something
     }
     case errServer :
     println("error server")
     case errNetwork :
     println("error network")
     default :
     println("cancel request by user")
     }
     })
     
     }
     
     sample end */
    
    func postServer(urlRequest: String, dicParams: NSDictionary, completion:(data: NSDictionary?, error:NSError?) -> ()) {
        self.POST(
            urlRequest,
            parameters: dicParams,
            success: { (sessionData: NSURLSessionDataTask, responseObject: AnyObject?)  in
                completion(data: (responseObject as! NSDictionary), error: nil)
            },
            failure: { (sessionData: NSURLSessionDataTask?, error: NSError) in
                completion(data: nil, error: error)
            }
        )
    }
}
