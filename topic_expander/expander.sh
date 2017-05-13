tweets=../topic_tweets
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
rm -rf atropos/data/* && rm -rf atropos/result/*
cp -rf $tweets/data/* atropos/data # Including user_links.new
cp -rf $tweets/trending_topics atropos/data
cd atropos/Preprocessing && python topicExpander.py && cd -
rm -rf data && mkdir data
cp atropos/result/* data && cp atropos/data/trending_topics data && cp ../topics/*.topk_topic data
tar czf data.tar.gz data
