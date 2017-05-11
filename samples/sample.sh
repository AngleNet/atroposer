tweets=topic_tweets
if [ ! -d $tweets ]; then
	echo "Run seperator.sh firstly"
	exit 0
else
	echo -n "Should I run the seperator.sh (Y/N)?"
	read ans
	if echo "$ans"|grep -iq "^y"; then
		bash seperator.sh
	fi
fi
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
rm -rf atropos/data/* && rm -rf atropos/result/*
cp -rf $tweets/atropos/result/* atropos/data
cp -f ../last_hop/spide_users/data/user_links.new atropos/data
cp -rf ../last_hop/spide_tweets/data/* atropos/data
cd atropos/Preprocessing && python sampleGenerator.py && python sampStat.py && cd -
