loc=topic_tweets # Seperate topic tweets to user tweets
mkdir -p $loc && cd $loc 
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
rm -rf atropos/data/* && rm -rf atropos/result/*
cp -rf ../../last_hop/spide_tweets/data/* atropos/data
cd atropos/Preprocessing && python twseperator.py && cd -
cd ..
