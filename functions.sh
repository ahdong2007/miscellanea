
# 对一个目录进行递归搜索和替换
# 比如：sr wrong_word correct_word
function sr {
    find . -type f -exec sed -i '' s/$1/$2/g {} +
}


# 格式化输出里取某一列
# 比如：git status -s | col 2
function col {
  awk -v col=$1 '{print $col}'
}


# 忽略前n个词
# docker rmi $(docker images | col 3 | xargs | skip 1)
function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}


function get_dir() {

	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}


function get_dir_with_link() {

	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  		DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  		SOURCE="$(readlink "$SOURCE")"
  		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	echo $DIR
}
