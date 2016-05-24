

#
# Usage: 
#   input:  Strings with color, parameter must be in double quotes, and no * included
#   Output: Strings with colors
#
#   <r> --> Red \033[40;31m
#   <g> --> Green \033[40;32m
#   <y> --> Yellow \033[40;33m
#   <b> --> Blue \033[40;34m
#   <p> --> purple \033[40;35m
#   <c> --> cyan \033[40;36m
#   <w> --> white \033[40;37m
#   <d> --> Default \033[0m
#
cecho() {

  tmp_str=$1

  tmp_str=`echo $tmp_str | sed  -e 's/<r>/\\\033\[47;31m/g' \
  								-e 's/<g>/\\\033\[47;32m/g' \
  								-e 's/<y>/\\\033[47;33m/g'  \
  								-e 's/<b>/\\\033\[47;34m/g' \
  								-e 's/<p>/\\\033\[47;35m/g' \
  								-e 's/<c>/\\\033\[47;36m/g' \
  								-e 's/<w>/\\\033\[47;37m/g' \
  								-e 's/<d>/\\\033\[0m/g' \
  								-e 's/$/\\\033\[0m/g'`

  if [ $(basename $SHELL) == 'ksh' ]; then
    echo $tmp_str
  else
    echo -e $tmp_str
  fi
}
