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
cp -rf ../last_hop/spide_tweets/data/*.tweet atropos/data
cp -rf ../last_hop/spide_tweets/data/*.origin_tweet atropos/data
cp -rf $tweets/atropos/result/*.tweet atropos/data # Including user_links.new
cp -rf $tweets/atropos/result/*.origin_tweet atropos/data # Including user_links.new
cp -rf $tweets/atropos/result/user_links.new atropos/data # Including user_links.new
cp $tweets/atropos/data/trending_topics atropos/data
cd atropos/Preprocessing && python sampleGenerator.py && python sampStat.py && cd -
