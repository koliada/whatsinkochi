#!/bin/sh

if ! hash pup 2>/dev/null; then
  echo "I need pup, this requires one-time installation...";
  brew install pup;
fi

URL="http://www.kochiaidad.ee/?go=al20";
DAY=$(date +'%-d');
LINE_COUNTER=0;

echo "Figuring out what's in Kochi for today...";

curl -s ${URL} | pup 'p[style="text-align: center;"] > span text{}' | while read line; do
  if ((LINE_COUNTER > 2)); then
    echo "--- Head isu! ---";
    exit 0;
  fi

  if ((LINE_COUNTER > 0)); then
    if ((LINE_COUNTER == 1)); then
      echo "Supp: $line";
    fi
    if ((LINE_COUNTER == 2)); then
      echo "Praad: $line";
    fi
    ((LINE_COUNTER++));
    continue;
  fi

  if echo ${line} | grep -qi "$DAY."; then
    echo "--- $line ---";
    ((LINE_COUNTER++));
  fi
done

if ((LINE_COUNTER == 0)); then
  echo "Nothing's found for today. Maybe they haven't updated the menu yet?";
  exit 0;
fi
