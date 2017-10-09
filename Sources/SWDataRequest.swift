
//
//  SWDataRequest.swift
//  LiteratyHeavenCrawler
//
//  Created by SanW on 2017/9/28.
//  Copyright © 2017年 ONONTeam. All rights reserved.
//

import Foundation
import PerfectCURL
import PerfectXML

class SWDataRequest: NSObject {

    class func requestData()  {

        let url = "http://www.hunliji.com/community"
        do
        {
            let json: String = try CURLRequest(url).perform().bodyString
            //            print("=== \(json)")
            parseHTML(html: json)
        } catch{
            print("====错误")
        }
        //                CURLRequest(url).perform {
        //                    confirmation in
        //                    do {
        //                        let response = try confirmation()
        //                        let json: [String:Any] = response.bodyJSON
        //                        print("=== \(json)")
        //
        //                    } catch let error as CURLResponse.Error {
        //                        print("出错，响应代码为： \(error.response.responseCode)")
        //                    } catch {
        //                        print("致命错误： \(error)")
        //                    }
        //                }
    }
    class func parseHTML(html:String) {
        let xDoc = HTMLDocument(fromSource: html)
        for item in (xDoc?.getElementsByTagName("dl"))! {
            let itemAtt = item.getAttribute(name: "class")
            
            if itemAtt == "huati-dl" {
                var title : String = ""
                var content : String = ""
                var webDetail : String = ""
                var image : String = ""
                var author : String = ""
                var createTime : String = ""
                for childItem in item.getElementsByTagName("dd") {
                    let childAtt = childItem.getAttribute(name: "class")
                    let firstChildNode = childItem.firstChild
                    
                    if childItem.nodeType != .documentNode && childAtt == "ht-imgs" {
                        image = (firstChildNode?.childNodes.first?.attributes?.getNamedItem(name: "src")?.nodeValue)!
                    }
                    if childItem.nodeType != .documentNode && childAtt == "ht-name"{
                        title = (firstChildNode?.nodeValue)!
                        webDetail = "http://www.hunliji.com\((firstChildNode?.attributes?.getNamedItem(name: "href")?.nodeValue)!)"
                    }
                    if childItem.nodeType != .documentNode && childAtt == "ht-text"{
                        content = (firstChildNode?.nodeValue)!
                    }
                    if childItem.nodeType != .documentNode && childAtt == "ht-source"{
                        author = childItem.nodeValue!
                    }
                }
                let insert = articleOprator.insertArticle(title: title, content: content, author: author, image: image, webUrl: webDetail)
                print(insert)
                print("title == \(title) createTime = \(createTime) content == \(content) webDetail == \(webDetail) image = \(image) author = \(author) \n")
            }
        }
        requestData()
    }
}
