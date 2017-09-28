# LiteraryHeaven-crawler

LiteraryHeaven对应的数据抓取程序

# 更新记录

2017.9.28--v1.1.0

# 数据库设计sql

## tb_article

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
`author` varchar(16) DEFAULT NULL,
`groupid` int(16) NOT NULL DEFAULT '0',
`image` varchar(128) DEFAULT NULL,
`content` varchar(256) DEFAULT NULL,
`create_time` datetime DEFAULT NULL,
`webUrl` varchar(128) DEFAULT NULL,
`anthor_head` varchar(128) DEFAULT NULL,
PRIMARY KEY (`articleid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `tb_article`
-- ----------------------------
BEGIN;
INSERT INTO `tb_article` VALUES ('1', '已婚新娘良心建议！婚纱买绝对是错！', '女王', '1', 'http://qnm.hunliji.com/o_1bqrin58e1c1l1dtf18ev9pu1o1rn.jpg?imageView2/1/w/100/h/100', '很多新娘都在纠结一个问题，婚纱是买还是租？结婚只结一次，肯定是买！no，no，no！楼主只想说，买了肯定后悔死你！几大件衣服占衣柜不说，还不能丢！最后只能转手低价卖出去！卖的时候，心里还很不是滋味！新娘们，千万不要觉得租的婚纱不好看！楼主花了3999元租了三套服装，一套秀禾服，一套主婚纱，一套敬酒服！还送了一个全天跟妆！特地提供试纱图片和婚礼当天图片供你们参考！你们自己看吧', '2017-12-06 00:00:00', 'http://news.sina.com.cn/sf/news/hqfx/2017-09-27/doc-ifymfcih6446366.shtml', 'http://img2.imgtn.bdimg.com/it/u=1343212205,678582139&fm=214&gp=0.jpg'), ('2', '已婚新娘tips：选纱别光看款式！ 大婚这几个重点也要注意！', '猫猫', '1', 'http://qnm.hunliji.com/Fn06pUtt404WF4Axuhqpdh1g9fPO', '亲爱的，邀请你参加【9月好物】活动哦，在【淘婚品】频道晒出你的婚品更有机会上首页头条~还有精致落地灯等你哦', '2017-12-22 00:00:00', 'http://www.chinaz.com/news/2017/0927/809116.shtml', 'http://diy.qqjay.com/u2/2012/0618/ed6982355b1340095aeaf79072bdc1cc.jpg');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;

```
## tb_artivleType

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
