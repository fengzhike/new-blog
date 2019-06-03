---
title: outlook
date: 2019-06-03 19:15:18
tags: [邮箱]
categories: 常用工具
---
# outlook搜索不到邮件怎么办
邮件搜索不到，肯定是索引坏了，outlook怎么创建索引呢？
## 手动处理
1. 关闭outlook
2. 打开~/资源库/Mail/Vx/MailData(Vx 是你的版本)
3. 删除任何以“Envelope Index”开头的文件，如Envelope Index或Envelope Index-shm
4. 打开outlook，自动创建

## 命令行
```
sudo mdutil -i off / 
 
sudo mdutil -E / 
 
sudo mdutil -i on /
```

重建索引时间取决于待索引的邮件数量，邮件越多，等待时间越长
