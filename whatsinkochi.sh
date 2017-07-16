#!/bin/sh

if ! hash pup 2>/dev/null; then
	echo "I require pup, this requires one-time installation...";
	brew install pup;
fi

LINE_COUNTER=0;
DAY=$(date +'%-d');

echo "Figuring out what's in Kochi for today...";

curl -s http://www.kochiaidad.ee/?go=al20 | pup 'p[style="text-align: center;"] > span text{}' | while read line; do
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