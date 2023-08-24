require 'json'
require 'fileutils'
require './Utils'
require 'pathname'
require 'shellwords'

def readPrototypeKey(file, keyName)
  link = Shellwords.escape(file)
  %x{defaults read #{link} #{keyName}}.chomp
end

def parseAppInfo(appBaseLocate, appInfoFile)
  appInfo = {}
  appInfo['appBaseLocate'] = "#{appBaseLocate}"
  appInfo['CFBundleIdentifier'] = readPrototypeKey appInfoFile, 'CFBundleIdentifier'
  appInfo['CFBundleVersion'] = readPrototypeKey appInfoFile, 'CFBundleVersion'
  appInfo['CFBundleShortVersionString'] = readPrototypeKey appInfoFile, 'CFBundleShortVersionString'
  appInfo['CFBundleName'] = readPrototypeKey appInfoFile, 'CFBundleExecutable'
  appInfo
end

def scan_apps
  applist = []
  baseDir = '/Applications'
  lst = Dir.glob("#{baseDir}/*")
  lst.each do |app|
    appInfoFile = "#{app}/Contents/Info.plist"
    next unless File.exist?(appInfoFile)
    begin
      applist.push parseAppInfo app, appInfoFile
      # puts "检查本地App: #{appInfoFile}"
    rescue StandardError
      next
    end
  end
  applist
end

def checkCompatible(compatibleVersionCode, compatibleVersionSubCode, appVersionCode, appSubVersionCode)
  return true if compatibleVersionCode.nil? && compatibleVersionSubCode.nil?
  compatibleVersionCode&.each do |code|
    return true if appVersionCode == code
  end

  compatibleVersionSubCode&.each do |code|
    return true if appSubVersionCode == code
  end
  false
end

def main

  puts "Environment Prepare Setting..."

  ret = %x{csrutil status}.chomp
  # System Integrity Protection status: disabled.
  if ret.include?("status: enabled")
    # puts "给老子把你那个b SIP关了先！是不是关SIP犯法？\n要求里写了要先关SIP，能不能认真看看我写的说明？\n如果你看了还没关，说明你确实是SB\n如果你没看说明，那你更SB。\nWhatever，U ARE SB。"
    # return
  end

  puts "====================================\n"
  puts "自动注入脚本开始执行...\n"
  puts "Automatic Inject Script Checking...\n"
  puts "Design By QiuChenly # github.com/qiuchenly\n"
  puts "Modified Edition By RainCandy Technology github.com/RainCandyTech\n"
  puts "====================================\n"
  puts "注入时请根据提示输入'y' 或者按下回车键跳过这一项。\n"
  puts "When i find useful options, pls follow my prompts enter 'y' or press enter key to jump that item.\n"

  install_apps = scan_apps

  config = File.read("config.json")
  config = JSON.parse config
  basePublicConfig = config['basePublicConfig']
  appList = config['AppList']

  #prepare resolve package lst
  appLst = []
  appList.each do |app|
    packageName = app['packageName']
    if packageName.is_a?(Array)
      packageName.each { |name|
        tmp = app.dup
        tmp['packageName'] = name
        appLst.push tmp
      }
    else
      appLst.push app
    end
  end

  appLst.each { |app|
    packageName = app['packageName']
    appBaseLocate = app['appBaseLocate']
    bridgeFile = app['bridgeFile']
    injectFile = app['injectFile']
    supportVersion = app['supportVersion']
    supportSubVersion = app['supportSubVersion']
    extraShell = app['extraShell']
    needCopy2AppDir = app['needCopyToAppDir']
    deepSignApp = app['deepSignApp']
    disableLibraryValidate = app['disableLibraryValidate']
    entitlements = app['entitlements']
    noSignTarget = app['noSignTarget']
    noDeep = app ['noDeep']

    localApp = install_apps.select { |_app| _app['CFBundleIdentifier'] == packageName }
    if localApp.empty? && (appBaseLocate.nil? || !Dir.exist?(appBaseLocate))
      next
    end

    if localApp.empty?
      puts "[🔔] 此App包不是常见类型结构，请注意当前App注入的路径是 #{appBaseLocate}"
      puts "[🔔] This App Folder is not common struct,pls attention now inject into the app path is #{appBaseLocate}"
      # puts "读取的是 #{appBaseLocate + "/Contents/Info.plist"}"
      localApp.push(parseAppInfo appBaseLocate, appBaseLocate + "/Contents/Info.plist")
    end

    localApp = localApp[0]
    if appBaseLocate.nil?
      appBaseLocate = localApp['appBaseLocate']
    end
    bridgeFile = basePublicConfig['bridgeFile'] if bridgeFile.nil?

    unless checkCompatible(supportVersion, supportSubVersion, localApp['CFBundleShortVersionString'], localApp['CFBundleVersion'])
      puts "[😅] [#{localApp['CFBundleName']}] - [#{localApp['CFBundleShortVersionString']}] - [#{localApp['CFBundleIdentifier']}]不是受支持的版本，跳过注入😋。\n"
      next
    end

    puts "[🤔] [#{localApp['CFBundleName']}] - [#{localApp['CFBundleShortVersionString']}] - [#{localApp['CFBundleIdentifier']}]是受支持的版本，是否需要注入？y/n(默认n)\n"
    action = gets.chomp
    next if action != 'y'
    puts "开始注入App: #{packageName}"

    dest = appBaseLocate + bridgeFile + injectFile
    backup = dest + "_backup"

    if File.exist? backup
      puts "备份的原始文件已经存在,需要直接用这个文件注入吗？y/n(默认y)\n"
      puts "Find Previous Target File Backup, Are u use it inject？y/n(default is y)\n"
      action = gets.chomp
      # action = 'y'
      if action == 'n'
        FileUtils.remove(backup)
        FileUtils.copy(dest, backup)
      else

      end
    else
      FileUtils.copy(dest, backup)
    end

    current = Pathname.new(File.dirname(__FILE__)).realpath
    current = Shellwords.escape(current)
    # set shell +x permission
    sh = "chmod +x #{current}/tool/insert_dylib"
    # puts sh
    system sh
    backup = Shellwords.escape(backup)
    dest = Shellwords.escape(dest)

    sh = "sudo #{current}/tool/insert_dylib #{current}/tool/libInjectLib.dylib #{backup} #{dest}"
    unless needCopy2AppDir.nil?
        system "sudo cp #{current}/tool/libInjectLib.dylib #{Shellwords.escape(appBaseLocate + bridgeFile)}libInjectLib.dylib"
        sh = "sudo #{current}/tool/insert_dylib #{Shellwords.escape(appBaseLocate + bridgeFile)}libInjectLib.dylib #{backup} #{dest}"
    end
    # puts sh
    system sh

    signPrefix = "codesign -f -s - --timestamp=none --all-architectures"

    if noDeep.nil?
      puts "Need Deep Sign."
      signPrefix = "#{signPrefix} --deep"
    end

    unless entitlements.nil?
      signPrefix = "#{signPrefix} --entitlements #{current}/tool/#{entitlements}"
    end

    # 签名目标文件 如果加了--deep 会导致签名整个app
    if noSignTarget.nil?
      puts "开始签名..."
      system "#{signPrefix} #{dest}"
    end

    unless disableLibraryValidate.nil?
      sh = "sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true"
      system sh
    end

    unless extraShell.nil?
      system "sudo sh #{current}/tool/" + extraShell
    end

    if deepSignApp
       system "#{signPrefix} #{Shellwords.escape(appBaseLocate)}"
    end
  }
end

main
