#!/usr/bin/env bash

BASE_PATH=$(
  cd $(dirname "$0")
  pwd
)

COLOR_INFO='\033[0;34m'
COLOR_ERR='\033[0;35m'
NOCOLOR='\033[0m'
BLUE='\\033[0;34m\]'

PDFM_DIR="/Applications/Parallels Desktop.app"
PDFM_VER="19.0.0-54570"

LICENSE_FILE="${BASE_PATH}/licenses.json"
LICENSE_DST="/Library/Preferences/Parallels/licenses.json"

echo ""
echo "${COLOR_INFO}[*] Make sure your version is: https://download.parallels.com/desktop/v19/${PDFM_VER}/ParallelsDesktop-${PDFM_VER}.dmg"
echo ""
echo  "${COLOR_INFO}[*] Coyping new license file licenses.json${NOCOLOR}"

# stop prl_disp_service
if pgrep -x "prl_disp_service" &> /dev/null; then
  echo -e "${COLOR_INFO}[*] Stopping Parallels Desktop${NOCOLOR}"
  pkill -9 prl_client_app &>/dev/null
  # ensure prl_disp_service has stopped
  "${PDFM_DIR}/Contents/MacOS/Parallels Service" service_stop &>/dev/null
  sleep 1
  launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist &>/dev/null
  sleep 1
  pkill -9 prl_disp_service &>/dev/null
  sleep 1
  rm -f "/var/run/prl_*"
fi

if [ -f "${LICENSE_DST}" ]; then
  chflags -R 0 "${LICENSE_DST}" || {
    echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
    exit $?
  }
  rm -f "${LICENSE_DST}" >/dev/null || {
    echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
    exit $?
  }
fi

cp -f "${LICENSE_FILE}" "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}
chown root:wheel "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}
chmod 444 "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}
chflags -R 0 "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}
chflags uchg "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}
chflags schg "${LICENSE_DST}" || {
  echo -e "${COLOR_ERR}error $? at line $LINENO.${NOCOLOR}"
  exit $?
}

cp -f "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service" "/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service_patched"


echo ""
echo "${COLOR_ERR}为了使破解生效，您必须使用专门的脚本以启动程序。\n它位于“Parallels启动脚本”文件夹中。\n此外请不要移动或删除注入程序所在文件夹，否则会造成激活失效或程序异常。"${COLOR_INFO}""
echo  "${NOCOLOR}"
echo "[*] Parallels Desktop Crack Complete" 

