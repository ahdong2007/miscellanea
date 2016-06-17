
function sr {
    find . -type f -exec sed -i '' s/$1/$2/g {} +
}

function col {
  awk -v col=$1 '{print $col}'
}

function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}