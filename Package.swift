import PackageDescription

let package = Package(
    name:"LiteratyHeavenCrawler",
    targets:[],
    dependencies:[
        .Package( url: "https://github.com/PerfectlySoft/Perfect-Curl.git", majorVersion: 2 )
    ]
)
