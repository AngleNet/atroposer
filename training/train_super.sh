if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi
cp sample atropos/data/samples.trindex
cp ../samples/atropos/result/tweets.sample atropos/data
cp ../users/user_links.new atropos/data/users
if [ -d atropos/data/user_tweets ]; then
	rm -rf atropos/data/user_tweets
fi
mkdir -p atropos/data/user_tweets && cp -f ../user_tweets/spide_tweets/data/* atropos/data/user_tweets

cd atropos/features && python sampleGenerator.py && cd -
