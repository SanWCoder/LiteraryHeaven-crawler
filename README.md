# LiteraryHeaven-crawler简介

LiteraryHeaven对应的数据抓取程序

对应客户端项目:[LiteraryHeaven](https://github.com/SanWCoder/LiteraryHeaven)

服务端项目:[LiteraryHeaven-server](https://github.com/SanWCoder/LiteraryHeaven-server)

不足之处，还望海涵，有问题可以随时交流哦😯 [:mail_SanW@163.com](http://mail.163.com/)

# 更新记录

2017.9.29--使用PerfectXML解析网页数据，并插入到相应库中

2017.9.28--v1.1.0

# 使用

```
~ git clone https://github.com/SanWCoder/LiteraryHeaven-crawler.git

~ cd LiteraryHeaven-crawler

~ swift build

~ .build/debug/LiteratyHeavenCrawler

// 如果需要生成xcode项目可调式
~ swift package generate-xcodeproj

```
# 数据库设计规范

该规范用于规范MySQL数据库的表设计，目的是希望规范数据库设计，尽量提前避免由于数据库设计不当而产生的麻烦。

#### 1>. 设计原则
* 用MySQL自增ID作为表的主键，类型选择INT类型 id INT NOT NULL AUTO_INCREMENT
* 减少表关联，对于常用的字段，以冗余的方式解决。例如：userid, username， 将用户名冗余存储到其他表
* 避免使用外键，由程序来控制表关联
* 字符规范：  
- 采用26个英文字符小写，0-9自然数，_下划线，不能出现其他字符（注释除外）
- 避免使用保留词作为表名，字段名
#### 2>. 数据库表命名规范
- 使用统一前缀： tb: 基础；td: 字典；to：业务
- 采用英文单词进行命名，单词用_下划线进行分割，例如：tb_user, tb_user_detail，要求见名知意
- 备份表，使用bak前缀和日期后缀，如：bak_user_20160128
- 临时表，使用tmp前缀和日期后缀，如：tmp_user_20160128
- 视图，使用v前缀，如：v_user_full_info
- 索引名，使用idx前缀，唯一索引使用uni前缀，如：idx_create_time; uni_username
#### 3>. 字段命名与类型规范
字段名命名，基本与表名要求相同，需要注意以下几点：

- 是/否(true/false) 字段，采用bit(1)类型, 1表示是；0表示否
- 枚举类型，可选值比较少的用tinyint 类型，支持-127~127, 如果需要，也可以使用tinyint unsigned无符号tinyint作为类型，支持0~256个枚举值。还不够的话，再用int类型
- varchar类型，长度是2的平方，如16, 32, 64, 128, 256 …; 长度不要设的太长，应选择满足需求的最短长度，如手机号：+8613838389438, varcha(16)就够用了
- 统一列命名

|  字段名	|  字段类型  |  描述  |
| :------ | :------- | :------: |
| id	| int	|自增主键|
| is_xxxx |	bit(1) | 表示true/false 值 |
| descs	| varchar | 描述信息 |
| remark	|varchar|备注信息|
| status |	tinyint | 状态 |
| order_no | int	| 排序 |
| create_time |	datetime |	创建时间 |
| creater | varchar | 创建人 |
| last_modify_time |	datetime | 最后修改时间 |
| last_modifier	| varchar | 最后修改人|

# 数据库表设计

#### tb_article

```
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `tb_article`
-- ----------------------------
DROP TABLE IF EXISTS `tb_article`;
CREATE TABLE `tb_article` (
`articleid` int(32) NOT NULL AUTO_INCREMENT,
`title` varchar(128) DEFAULT NULL,
`author` varchar(64) DEFAULT NULL,
`groupid` int(16) NOT NULL DEFAULT '0',
`image` varchar(128) DEFAULT NULL,
`content` text,
`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
`webUrl` varchar(128) DEFAULT NULL,
`anthor_head` varchar(128) DEFAULT NULL,
PRIMARY KEY (`articleid`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `tb_article`
-- ----------------------------
BEGIN;
INSERT INTO `tb_article` VALUES ('16', '【婚礼纪录】婚鞋大作战　裸粉色铆钉款简直绝了', 'by：苏小花花花来自：我的备婚流程331', '0', 'http://qnm.hunliji.com/FpoIK8zY8zx_Z7hnNZKdV-3hlw3s?imageView2/1/w/100/h/100', '6月份的时候在大阪买哒，这个价格实在一般，但是日本的服务太好了，不买都觉得对不起服务的小姐，哈哈，买来当婚鞋哒，10cm真的很高，而且真的很少有人穿的铆钉结婚，本来是想买jimmy choo哒，大阪的jimmy choo款式实在一般，上脚的一瞬间就感觉就是它啦\n第一双是一个小众牌子，非常舒适，鞋型比较秀气，有种mb的感觉，mb真的山寨或者雷同设计太多，看到这个反而有耳目一新的感觉，设计师介绍鞋上的钻都是施华洛世奇哒，个人很喜欢', '2017-09-29 14:01:15', 'http://www.hunliji.com/community/detail_272771', null);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

```
#### tb_artivleType

```
SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `tb_artivleType`
-- ----------------------------
DROP TABLE IF EXISTS `tb_artivleType`;
CREATE TABLE `tb_artivleType` (
`groupid` int(32) NOT NULL,
`groupTitle` varchar(64) DEFAULT NULL,
PRIMARY KEY (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `tb_artivleType`
-- ----------------------------
BEGIN;
INSERT INTO `tb_artivleType` VALUES ('1', '婚纱礼服'), ('2', '两性情感'), ('3', '婚纱拍照');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

```
