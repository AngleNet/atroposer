running_date=$(head ../date)
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
	git clone -b topic-in-tweet-$running_date git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
rm -rf atropos/data/* && rm -rf atropos/result/*
find ../last_hop/spide_tweets/data -name '*.tweet' -exec cp {} atropos/data/ \;
find ../last_hop/spide_tweets/data -name '*.origin_tweet' -exec cp {} atropos/data/ \;
find $tweets/atropos/result -name '*.tweet' -exec cp {} atropos/data/ \;
find $tweets/atropos/result -name '*.origin_tweet' -exec cp {} atropos/data/ \;
cp $tweets/atropos/result/user_links.new atropos/data
cp $tweets/atropos/data/trending_topics atropos/data
cd atropos/Preprocessing && python sampleGenerator.py && python sampStat.py && cd -
