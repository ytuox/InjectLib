# QiuChenly InjectShell（恢复 Parallels Desktop 19 激活功能）
本项目基于「秋城落叶开源项目」的 InjectLib 项目和外网的修改版 Parallels Desktop 激活脚本修改而来。
原作者：[QiuChenly](https://twitter.com/QiuChenly)

# 免责声明
根据中华人民共和国《计算机软件保护条例》第十七条规定：“为了学习和研究软件内含的设计思想和原理，通过安装、显示、传输或者存储软件等方式使用软件的，可以不经软件著作权人许可，不向其支付报酬。”您需知晓本站所有内容资源均来源于网络，仅供用户交流学习与研究使用，版权归属原版权方所有，版权争议与本站无关，用户本人下载后不能用作商业或非法用途，需在24小时之内删除，否则后果均由用户承担责任。


# 使用
1. 下载解压，双击运行“原神_启动.command"并输入密码，按照提示操作。
2. 要是你不差这几分钟时间，从头到尾先认真读一遍这个 Readme，可能你看完之后会解决你的部分疑惑。

# 已知问题
程序出现"[应用程序]想要访问你的钥匙串"弹窗<br>
   ![img.png](img.png)<br>
对于某些 App 的补丁，脚本会自动对其签名以保证能在 SIP 打开的情况下使用；但是保存在钥匙串里的信息只能被 App 的官方签名版本读取，自签名版本无法读取。
解决方案：在钥匙串中删除对应 App 用到的相关信息。

# 环境
代码运行最低操作系统要求&此代码编译环境

- 最低运行 macOS High Sierra 10.13
- 编译SDK macOS 14.0
- 目标部署平台 macOS 10.13
- CMakeLists 环境变量
    - set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13")
- 检查二进制文件的最低macOS版本兼容性
    - ```find . -name "*.*" | xargs otool -l | grep -E "(minos|sdk)"```

# 兼容

新增的SIP栏说明:<br>

- ❌: 只能关闭SIP使用<br>
- ✅: 可以在打开SIP的机器上使用<br>

| App                                            | 版本                                                                                                  | ARM64 | Intel | SIP | 特殊要求                                                                                                                                                                            |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------|:-----:|:-----:|-----|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Affinity Photo 2/Designer 2/Publisher 2 全家桶    | 2.1.1                                                                                               |   ✅   |   ✅   | ❌   | 需要从Mac App Store 下载                                                                                                                                                              |
| App Cleaner & Uninstaller                      | 8.2.2                                                                                               |   ✅   |   ✅   | ✅   | 因为签名会导致提示盗版，有空在再弄。                                                                                                                                                                       | 
| CleanMyMac X                                   | 通杀                                                                                                  |   ✅   |   ✅   | ✅   | com.macpaw.CleanMyMac4.Menu 单独也要注入 Helper 每个版本不一样还是需要单独处理 暂时不弄了 不要下大陆特供版 更新地址: https://s3-us-west-2.amazonaws.com/updateinfo.devmate.com/com.macpaw.CleanMyMac4/beta/updates.xml | 
| Elpass                                         | [通杀](https://elpass.app/macos/Elpass-1.5.6-490.zip)                                                 |   ✅   |   ✅   | ✅   | 无法使用云同步 签名后的app通病 无解 搭配Surge脚本可以做到5138年授权                                                                                                                                       |
| Infuse Pro                                     | 通杀                                                                                                  |   ✅   |   ✅   | ❌   |                                                                                                                                                                                 | 
| Microsoft Office Word/PowerPoint/Excel/Outlook | 通杀                                                                                                  |   ✅   |   ✅   | ✅   | 365订阅版 需要从Mac App Store 下载                                                                                                                                                       |
| MWEB Pro                                       | 通杀                                                                                                  |   ✅   |   ✅   | ❌   |                                                                                                                                                                                 | 
| Navicat Premium                                | 通杀                                                                                                  |   ✅   |   ✅   | ✅   | 需要从 Mac App Store 下载                                                                                                                                                              |
| Navicat 16 For Oracle                           | 通杀                                                                                                  |   ❌   |   ✅   | ✅   | 需要从 Mac App Store 下载 我下不到ARM64的版本                                                                                                                                                 |
| Omi录屏专家                                        | 通杀                                                                                                  |   ✅   |   ✅   | ❌   | 需要从 Mac App Store 下载                                                                                                                                                              | 
| OmniPlayer                                     | 通杀                                                                                                  |   ✅   |   ✅   | ❌   | 需要从 Mac App Store 下载                                                                                                                                                              |
| Parallels Desktop                                          | 18.2.0 - 19.0.0                                                                                              |   ✅   |   ✅   | ✅   | 需要使用专门的启动器启动程序                                                                                                                                                            | 
| Paste                                          | 4.0.5                                                                                               |   ✅   |   ✅   | ✅   |                                                                                                                                                                                 | 
| ProxyMan                                       | [4.9.1](https://download.proxyman.io/49001/Proxyman_4.9.1.dmg)                                      |   ✅   |   ✅   | ✅   | 更新地址: https://proxyman.io/osx/version.xml                                                                                                                                       |
| Stash                                          | [2.3.0](https://mac-release-static.stash.ws/Stash-build-221.zip)                                    |   ❌   |   ✅   | ❌   | 无法设置全局代理 不知道哪里有问题 总体体验较差 不如 Surge                                                                                                                                                |
| Sublime Text                                   | [通杀](https://download.sublimetext.com/sublime_text_build_4154_mac.zip)                              |   ✅   |   ✅   | ✅   | 授权信息下面找。                                                                                                                                                                        |
| Surge 5                                        | [通杀](https://dl.nssurge.com/mac/v5/Surge-5.3.1-2377-cac8e042e93f0418baf87ec6ef85dc2c.zip)           |   ✅   |   ✅   | ✅   |                                                                                                                                                         | 
| 解优2                                            | 通杀                                                                                                  |   ✅   |   ✅   | ❌   |                                                                                                                                                                                 | 

| Adobe 全家桶               | 版本           | ARM64 | Intel | 特殊说明                         |
|:------------------------|:-------------|:-----:|:-----:|:-----------------------------|
| Adobe PhotoShop         | 通杀           |   ❌   |   ✅   | PS:神经滤镜已经完美可用                |
| Adobe PhotoShop Beta    | 通杀           |   ❌   |   ✅   | 支持创意填充/神经滤镜 需要随便登录个账户        |
| Adobe Acrobat           | 23.003.20244 |   ✅   |   ✅   |                              |
| Adobe Illustrator       | 27.8.1       |   ✅   |   ❔   | ARM64 测试通过 X86没有测试过 大家自行测试   |
| Adobe Lightroom Classic | 12.4         |   ❌   |   ❌   | 功能不可用 等后续更新                  |
| Adobe Premiere Pro      | 23.5         |   ❔   |   ❔   | M1/x86版本灰度测试 测试报告有效/无效 我没有安装 |

# 激活注意

## Sublime Text Dev

```
----- BEGIN LICENSE -----
秋城落叶@52pojie.com
Unlimited User License
EA7E-8888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
88888888888888888888888888888888
------ END LICENSE ------
```
## Stash

https://mac-release.stash.ws/appcast.xml

## ELPass

https://elpass.app/macos/appcast-beta.xml

## Surge
Surge 盗版用户请支持正版。<br>
更新地址: https://www.nssurge.com/mac/v5/appcast-signed-beta.xml <br>

一切完美。感谢QQ 302***3398 用户无偿提供授权信息。<br>
目前错误已全部修正。<br>
之前安装过旧版本的用户进 Surge 后先卸载一遍 Helper 帮助程序才能正常安装帮助程序挂上代理。点击安装帮助程序没反应的不是破解的问题，如要解决请先点一下卸载帮助程序。<br>

Surge 开启 MitM 和脚本功能，然后: <br>

1. 在你的配置文件中加入例子中提供文件中的 Script 字段信息:
   [Surge脚本配置例子.conf](Surge%E6%BF%80%E6%B4%BB%E8%84%9A%E6%9C%AC%2FSurge%E8%84%9A%E6%9C%AC%E9%85%8D%E7%BD%AE%E4%BE%8B%E5%AD%90.conf)
   ![img.png](imgs/img.png)
   ![img_1.png](imgs/img_1.png)
   ![img_1.png](imgs/img_2.png)

2. [paddle_act.js](Surge%E6%BF%80%E6%B4%BB%E8%84%9A%E6%9C%AC%2Fpaddle_act.js) 这个文件一定要复制到 conf 文件所在目录中。

3. 记得打开 HTTPS 解密，并且信任证书，MitM 域名加入*.paddleapi.com 保存即可。<br>
   如果要实现五千年授权需要打开增强模式并加入新的域名: api.elpass.app<br>
   ![img.png](imgs/img3.png)

4. 在 App 中随意输入序列号和邮箱，点击激活后秒激活。

已测试支持以下 App:

| App         | 版本    | 特殊说明 |
|:------------|:------|:-----|
| AlDente Pro | 1.22  |      |
| AirBuddy    | 2.6.3 |      |
| TG pro      | 2.8.2 |      |

# 提示

1. 会自动扫描本地安装的 App，你只需要在想注入的 App 后面输入 y 即可。
2. 对于 Adobe App，如果不想让官方 ACC 胡乱生成垃圾，可以[在这个仓库下载 v6 版本的离线安装包](https://github.com/Drovosek01/adobe-packager)，然后配合 AntiCC 之类的组件运行 Adobe 产品。
3. 在激活之后，由于 App 仍然依赖这些注入代码，所以不要移动注入文件夹或者删除注入文件夹，否则会造成破解不稳定和程序崩溃。

# 警告
对于部分 App ，请一定要事先关闭 SIP，因为脚本使用的注入方式要求系统环境关闭 SIP。


