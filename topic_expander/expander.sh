tweets=../topic_tweets
running_date=$(head ../date)
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet-$running_date git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
rm -rf atropos/data/* && rm -rf atropos/result/*
cp -rf $tweets/data/* atropos/data # Including user_links.new
cp -rf $tweets/runner/trending_topics atropos/data
cd atropos/Preprocessing && python topicExpander.py && cd -
rm -rf data && mkdir data
cp atropos/result/* data && cp atropos/data/trending_topics data && cp ../features/trending_index/*.txt data
while read line; do
	echo $line | grep 'Total_Reads' > /dev/null
	if [ $? -eq 0 ] || [ -z "$line" ] ; then
		continue
	fi
	pid=$(echo $line| awk -F, '{print $1}')
	if [ ! -e "atropos/result/$pid" ]; then
		sed -i "/$pid/d" data/trending_topics
	fi
done < atropos/data/trending_topics
tar czf data.tar.gz data
scp data.tar.gz qhcert:/tmp
