#!/bin/sh

if ! hash pup 2>/dev/null; then
  echo "I need pup, this requires one-time installation...";
  brew install pup;
fi

URL="http://www.kochiaidad.ee/?go=al20";
[ "$1" == "--debug" ] && DEBUG=1 || DEBUG=0;
DAY=$(date +'%-d');
LINE_COUNTER=0;

if ((DEBUG == 1)); then
  echo "Printing out full menu...";
else
  echo "Figuring out what's in Kochi for today...";
fi

print_date () {
  echo "--- $1 ---";
}

print_supp () {
  echo "Supp: $1";
}

print_praad () {
  echo "Praad: $1";
}

main () {
  curl -s ${URL} | pup '#normalcontent p > span text{}' | while read line; do
    if ((LINE_COUNTER > 2)); then
      echo "--- Head isu! ---";
      exit 0;
    fi

    if ((LINE_COUNTER > 0)); then
      if ((LINE_COUNTER == 1)); then
        print_supp "$line";
      fi
      if ((LINE_COUNTER == 2)); then
        print_praad "$line";
      fi
      ((LINE_COUNTER++));
      continue;
    fi

    if echo ${line} | grep -qi " $DAY."; then
      print_date "$line";
      ((LINE_COUNTER++));
    fi
  done
}

main

#if ((${LINES_PROCESSED} == 0)); then
#  echo "Nothing's found. Maybe they haven't updated the menu yet?\nTip: use --debug option to print the full menu.";
#  exit 0;
#fi
