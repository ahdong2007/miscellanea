

#
# echo the status with same column size
#
echo_ok() {
  COL_SIZE=60
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;32m ok \\033[0;39m]"
}

echo_failure() {
  COL_SIZE=60
  STRING="$1"
  echo -e "${STRING} \\033[${COL_SIZE}G [\\033[1;31mFAILED\\033[0;39m]"
}

# sample testing
echo_ok "starting networking"
echo_failure "starting tomcat"