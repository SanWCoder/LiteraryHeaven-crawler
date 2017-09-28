
//
//  SWDataRequest.swift
//  LiteratyHeavenCrawler
//
//  Created by SanW on 2017/9/28.
//  Copyright © 2017年 ONONTeam. All rights reserved.
//

import Foundation
import PerfectCURL

class SWDataRequest: NSObject {
    class func requestData()  {
        
        let url = "http://mil.k618.cn/news/201709/t20170928_13399459.html"
        do
        {
            let json: String =   try CURLRequest(url).perform().bodyString
            print(json)
        } catch{
            print("错误")
        }
        //        CURLRequest(url).perform {
        //            confirmation in
        //            do {
        //                let response = try confirmation()
        //                let json: [String:Any] = response.bodyJSON
        //                print(json)
        //
        //            } catch let error as CURLResponse.Error {
        //                print("出错，响应代码为： \(error.response.responseCode)")
        //            } catch {
        //                print("致命错误： \(error)")
        //            }
        //        }
    }
}
