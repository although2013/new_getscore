仅供娱乐。。

```ruby
me = CheckOne.new("学号", "密码")

#获取登录 session
me.get_session

#在命令行输出该人本学期成绩
me.get_score.parse_html

#如果和上次查询成绩有变（成绩有更新）
if me.different?
  #下载全年级本学期成绩
  #（GetClassTxt#get_whole_page 中的 set_form_data 一行要改成你想要的学院代号）
  page = me.get_whole_page
  me.download_text(page)
end

```