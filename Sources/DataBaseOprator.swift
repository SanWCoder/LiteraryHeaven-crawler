import MySQL
import PerfectLib
import PerfectHTTP
import PerfectCrypto
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
class UserOprator: DataBaseOprator {
    
    /// 查询用户名密码是否匹配
    ///
    /// - Parameters:
    ///   - phone: 用户名
    ///   - password: 密码
    /// - Returns: 返回json
    class func userLogin(phone:String,password:String) -> String? {
        if !valideRegisted(phone: phone) {
            baseResponseJson[codeKey] = netCode.register.rawValue
            baseResponseJson[msgKey] = netCode.register.description
            baseResponseJson[dataKey] = []
            Log.info(message: "账号尚未注册" + "SELECT * FROM tb_user where phone = '\(phone)' and password = '\(password)'")
        }else if !mysql.query(statement: "SELECT * FROM tb_user where phone = '\(phone)' and password = '\(password)'"){
            baseResponseJson[codeKey] = netCode.oprataError.rawValue
            baseResponseJson[msgKey] = netCode.oprataError.description
            baseResponseJson[dataKey] = []
            Log.info(message: "查询出错 " + "SELECT * FROM tb_user where phone = '\(phone)' and password = '\(password)'")
        }
        else {
            let results = mysql.storeResults()!
            
            if results.numRows() == 0{
                baseResponseJson[codeKey] = netCode.pwsError.rawValue
                baseResponseJson[msgKey] = netCode.pwsError.description
                baseResponseJson[dataKey] = []
                Log.info(message: "手机号或密码错误 " + "SELECT * FROM tb_user where phone = '\(phone)' and password = '\(password)'")
            }
            else{
                baseResponseJson[codeKey] = netCode.success.rawValue
                baseResponseJson[msgKey] = netCode.success.description
                var responseDict :[String:Any] = [:]
                results.forEachRow(callback: { (row) in
                    responseDict["userId"] = row[0]
                    responseDict["nickName"] = row[2]
                    responseDict["sex"] = row[5]
                    responseDict["header"] = row[4]
                    responseDict["info"] = row[7]
                    responseDict["phone"] = row[3]
                    responseDict["token"] = row[10]
                })
                baseResponseJson[dataKey] = responseDict
                Log.info(message: "成功 " + "SELECT * FROM tb_user where phone = '\(phone)' and password = '\(password)'")
            }
        }
        do {
            return try baseResponseJson.jsonEncodedString()
        } catch{
            return nil
        }
    }
    
    /// 注册
    ///
    /// - Parameters:
    ///   - phone: 账号
    ///   - nickname: 昵称
    ///   - password: 密码
    /// - Returns: <#return value description#>
    class func userRegister(phone:String,nickname : String,password:String,uuid:String) -> String? {
        if valideRegisted(phone: phone) {
            baseResponseJson[codeKey] = netCode.registered.rawValue
            baseResponseJson[msgKey] = netCode.registered.description
            baseResponseJson[dataKey] = []
            Log.info(message: "账号已注册" + "INSERT INTO tb_user (phone,nickname,password) VALUES ('\(phone)','\(nickname)','\(password)')")
        }else{
            let dateTem = String(stringInterpolationSegment: Date())
            let date = dateTem.substring(to: dateTem.index(dateTem.startIndex, offsetBy: 19))
            if !mysql.query(statement: "INSERT INTO tb_user (phone,nickname,password,uuid,create_time,token) VALUES ('\(phone)','\(nickname)','\(password)','\(uuid)','\(date)','\((uuid.md5() + date.md5()).md5())')") {
                baseResponseJson[codeKey] = netCode.oprataError.rawValue
                baseResponseJson[msgKey] = netCode.oprataError.description
                baseResponseJson[dataKey] = []
                Log.info(message: "插入失败 " + "INSERT INTO tb_user (phone,nickname,password,uuid,create_time,token) VALUES ('\(phone)','\(nickname)','\(password)','\(uuid)','\(date)','\((uuid.md5() + date.md5()).md5())')")
            }
            else{
                baseResponseJson[codeKey] = netCode.success.rawValue
                baseResponseJson[msgKey] = netCode.success.description
                baseResponseJson[dataKey] = []
                Log.info(message: "成功 " + "INSERT INTO tb_user (phone,nickname,password) VALUES ('\(phone)','\(nickname)','\(password)')")
            }
        }
        do {
            return try baseResponseJson.jsonEncodedString()
        } catch{
            return nil
        }
    }
    class func updateUserInfo(request : HTTPRequest) -> String? {
        let token : String = request.header(HTTPRequestHeader.Name.custom(name: "token"))!
        if token.isEmpty || (!token.isEmpty && !valideToken(token: token)){
            baseResponseJson[codeKey] = netCode.userLogin.rawValue
            baseResponseJson[msgKey] = netCode.userLogin.description
            baseResponseJson[dataKey] = []
        }
        else{
            let  nickName : String? = request.param(name: "nickName")
            let header  : String? = request.param(name: "header")
            let sex : String? = request.param(name: "sex")
            let info  : String? = request.param(name: "info")
            var sql = ""
            //            print("nick = \(nickName),header = \(header),sex = \(sex),info = \(info)")
            if (nickName == nil && header == nil && sex == nil && info == nil) {
                baseResponseJson[codeKey] = netCode.paramError.rawValue
                baseResponseJson[msgKey] = netCode.paramError.description
                baseResponseJson[dataKey] = []
            }
            else if nickName != nil{
                sql = "UPDATE tb_user SET nickname = '\(nickName!)'"
            }
            else if header != nil{
                sql = "UPDATE tb_user SET head = '\(header!)'"
            }
            else if sex != nil{
                sql = "UPDATE tb_user SET sex = '\(sex!)'"
            }
            else if info != nil{
                sql = "UPDATE tb_user SET info = '\(info!)'"
            }
            Log.info(message: sql)
            if !mysql.query(statement: sql) {
                baseResponseJson[codeKey] = netCode.oprataError.rawValue
                baseResponseJson[msgKey] = netCode.oprataError.description
                baseResponseJson[dataKey] = []
            }
            else{
                baseResponseJson[codeKey] = netCode.success.rawValue
                baseResponseJson[msgKey] = netCode.success.description
                baseResponseJson[dataKey] = []
            }
        }
        do {
            return try baseResponseJson.jsonEncodedString()
        } catch{
            return nil
        }
    }
    /// 验证账号是否已经注册
    ///
    /// - Parameter phone: 账号
    /// - Returns: <#return value description#>
    class func valideRegisted(phone:String) -> Bool {
        guard mysql.query(statement: "SELECT * FROM tb_user where phone = '\(phone)'") else {
            return false
        }
        guard (mysql.storeResults()?.numRows())! == 1 else {
            return false
        }
        return true
    }
    
    /// 验证用户token是否存在
    ///
    /// - Parameter token: token值
    /// - Returns: <#return value description#>
    class func valideToken(token : String) -> Bool {
        guard mysql.query(statement: "SELECT * FROM tb_user where token = '\(token)'") else {
            return false
        }
        guard (mysql.storeResults()?.numRows())! == 1 else {
            return false
        }
        return true
    }
}

/// 文章操作类
class articleOprator: DataBaseOprator {
    
    /// 请求文章信息
    ///
    /// - Parameter request: 请求
    /// - Returns: <#return value description#>
    class func articleInfo(request : HTTPRequest) -> String? {
        let articleId = request.param(name: "articleId") ?? "0"
        let count = request.param(name: "count") ?? "20"
        let type = request.param(name: "type") ?? "1"
        Log.info(message: "SELECT * FROM tb_article where articleid > '\(articleId)' and groupid = '\(type)' limit \(count)")
        if !mysql.query(statement: "SELECT * FROM tb_article where articleid > '\(articleId)' and groupid = '\(type)' limit \(count)") {
            baseResponseJson[codeKey] = netCode.oprataError.rawValue
            baseResponseJson[msgKey] = netCode.oprataError.description
            baseResponseJson[dataKey] = []
        }
        else {
            baseResponseJson[codeKey] = netCode.success.rawValue
            baseResponseJson[msgKey] = netCode.success.description
            var responseArrray : [Dictionary<String, Any>] = []
            mysql.storeResults()?.forEachRow(callback: { (row) in
                var responseDict : [String:Any] = [:]
                responseDict["articleId"] = row[0]
                responseDict["articleTitle"] = row[1]
                responseDict["authorNick"] = row[2]
                responseDict["iconImage"] = row[8]
                responseDict["clickCount"] = row[6]
                responseDict["articleImage"] = row[4]
                responseDict["webUrl"] = row[7]
                responseArrray.append(responseDict)
            })
            baseResponseJson[dataKey] = responseArrray
            Log.info(message: "成功 " + "SELECT * FROM tb_article where articleid > '\(articleId)' and groupid = '\(type)' limit \(count)")
        }
        do {
            return try baseResponseJson.jsonEncodedString()
        } catch{
            return nil
        }
    }
}
