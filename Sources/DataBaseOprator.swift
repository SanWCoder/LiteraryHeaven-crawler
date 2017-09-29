import MySQL
import PerfectLib
import PerfectHTTP
import Foundation
/// 0 : 成功 1：失败
let codeKey = "code"
let msgKey = "msg"
let dataKey = "data"
var baseResponseJson :[String:Any] = [codeKey:0,dataKey:[],msgKey:""]
/// 数据库操作类
class DataBaseOprator {
    class var mysql : MySQL{
        get{
            return DataBaseConnect.shareInstance.mysql
        }
    }
}
/// 用户操作类
class articleOprator: DataBaseOprator {
    
    /// 查询用户名密码是否匹配
    ///
    /// - Parameters:
    ///   - phone: 用户名
    ///   - password: 密码
    /// - Returns: 返回json
    class func insertArticle(title:String,content:String,author:String,image:String,webUrl:String) -> Bool? {
        print("INSERT into tb_article (title,content,author,image,webUrl) values ('\(title)','\(content)','\(author)','\(image)','\(webUrl)')")
        return mysql.query(statement: "INSERT into tb_article (title,content,author,image,webUrl) values ('\(title)','\(content)','\(author)','\(image)','\(webUrl)')")
    }
}
