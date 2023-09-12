#!/bin/bash
#=================================================
# File name: lean.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Clone community packages to package/community

#rm -rf package/libs/libnl-tiny
#rm -rf package/kernel/mac80211
#rm -rf package/kernel/mt76
#rm -rf package/network/services/hostapd
#rm -rf package/wwan
#svn export https://github.com/DHDAXCW/lede-rockchip/trunk/package/wwan package/wwan
#svn export https://github.com/openwrt/openwrt/trunk/package/libs/libnl-tiny package/libs/libnl-tiny
#svn export https://github.com/openwrt/openwrt/trunk/package/kernel/mac80211 package/kernel/mac80211
#svn export https://github.com/DHDAXCW/lede-rockchip/trunk/package/kernel/mt76 package/kernel/mt76
#svn export https://github.com/openwrt/openwrt/trunk/package/network/services/hostapd package/network/services/hostapd

# alist
# git clone https://github.com/sbwml/luci-app-alist package/alist
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang

mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package
rm -rf ../../customfeeds/luci/applications/luci-app-kodexplorer
rm -rf openwrt-package/verysync
rm -rf openwrt-package/luci-app-verysync

# Add luci-app-ssr-plus
git clone --depth=1 https://github.com/fw876/helloworld

# Add luci-app-passwall
# git clone https://github.com/xiaorouji/openwrt-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2
# svn export https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall

# Add luci-app-unblockneteasemusic
rm -rf ../../customfeeds/luci/applications/luci-app-unblockmusic
git clone --depth=1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add luci-app-onliner (need luci-app-nlbwmon)
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add ddnsto & linkease
svn export https://github.com/linkease/nas-packages-luci/trunk/luci/luci-app-ddnsto
svn export https://github.com/linkease/nas-packages/trunk/network/services/ddnsto

# Add OpenClash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

# Add luci-app-advanced
git clone --depth=1 https://github.com/sirpdboy/luci-app-advanced

# Add luci-app-netwizard
git clone --depth=1 https://github.com/sirpdboy/luci-app-netwizard

# Add luci-app-poweroff
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff

# Add luci-theme
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/data/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
git clone https://github.com/DHDAXCW/theme

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# alist
git clone https://github.com/sbwml/openwrt-alist --depth=1

# Add luci-app-smartdns & smartdns
svn export https://github.com/281677160/openwrt-package/trunk/luci-app-smartdns

# Add apk (Apk Packages Manager)
svn export https://github.com/openwrt/packages/trunk/utils/apk

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add luci-aliyundrive-webdav
rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav
rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
# svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
# svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
popd

# Add Pandownload
pushd package/lean
svn export https://github.com/immortalwrt/packages/trunk/net/pandownload-fake-server
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

# Fix libssh
pushd feeds/packages/libs
rm -rf libssh
svn export https://github.com/openwrt/packages/trunk/libs/libssh
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
# sed -i "/uci commit system/i\uci set system.@system[0].hostname='openwrt'" package/lean/default-settings/files/zzz-default-settings
# sed -i "s/hostname='.*'/hostname='Jejz'/g" ./package/base-files/files/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i '/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF./d' package/lean/default-settings/files/zzz-default-settings

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# Modify default IP
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

# svn co 复制 仓库下的文件夹 git clone 复制整个仓库

# 更换内核
# sed -i 's/KERNEL_PATCHVER:=*.*/KERNEL_PATCHVER:=6.1/g' target/linux/x86/Makefile       
# sed -i 's/KERNEL_TESTING_PATCHVER:=*.*/KERNEL_TESTING_PATCHVER:=6.1/g' target/linux/x86/Makefile
