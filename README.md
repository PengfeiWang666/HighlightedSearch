# HighlightedSearch
类似微信的客户端本地搜索、搜索关键字高亮显示

Demo 效果如图所示
![](https://github.com/PengfeiWang666/HighlightedSearch/blob/master/HighlightedSearch/ReadMeImage/test.gif)

支持：
* 汉字支持汉字直接搜索、拼音全拼搜索、拼音简拼搜索
* 搜索匹配到的关键字高亮显示
* 搜索结果优先显示全部匹配、其次是拼音全拼匹配、拼音简拼匹配；关键字在结果字符串中位置越靠前，优先显示
* 支持搜索英文、汉字、电话号码及混合搜索

* 英文名称及电话号码的搜索直接使用完全匹配的方式即可
* 重难点是汉字的拼音相关的拼音全拼、简拼搜索，比如 “刘亦菲” 对应的搜索关键字`有且只有`以下三大类总计 25 种匹配
  * 汉字：“刘”、“亦”、“菲”、“刘亦”、“亦菲”、“刘亦菲”
  * 简拼相关："l"、"y"、"f"、"ly"、"yf"、"lyf" 
  * 全拼相关："li"、"liu"、"liuy"、"liuyi"、"liuyif"、"liuyife"、"liuyifei"、"yi"、"yif"、"yife"、"yifei"、"fe"、"fei"
* 拼音的重难点还包括：比如搜索关键字为“xian”，既要匹配出“先”，也要匹配出“西安”

代码细节讲解
[]()
