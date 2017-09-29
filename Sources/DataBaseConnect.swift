import MySQL
import PerfectLib

/// 数据库连接类
class DataBaseConnect{
    let dataBaseName = "LiteraryDB"

    var host : String{ // 地址
        get {
            return "127.0.0.1"
        }
    }
    var user : String{ // mysql用户名
        get {
            return "root"
        }
    }
    var password : String{ // mysql密码
        get {
            return "123456"
        }
    }
    var mysql : MySQL!  // mysql实例
    static let shareInstance = DataBaseConnect.init() // 单例
    private init() {
        if mysql == nil{
            mysql = MySQL()
            // 连接mysql
            let connected = mysql.connect(host: host, user: user, password: password)
            guard connected else {
                Log.info(message: "数据库连接失败")
                return
            }
            guard selectDB(dataBaseName: dataBaseName) else {
                Log.info(message: "选择数据库失败")
                return
            }
        }
    }
    /// 切换数据库
    func selectDB(dataBaseName:String) -> Bool{
        guard mysql.selectDatabase(named: dataBaseName) else {
            Log.info(message: "数据库选择失败")
            return false
        }
        Log.info(message: "数据库选择成功")
        return true
    }
}

