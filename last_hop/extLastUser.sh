running_date=$(head ../date)
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet-$running_date git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd - 
fi

echo -n "We are going to remove $(pwd)/atropos/data/*, are you sure (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	rm -f atropos/data/*
fi

#Copy pid.tweet pid.origin_tweet
cp -f ../topic_tweets/data/* atropos/data
cd atropos/Spider && python exToretwLastHop.py && cd -
#write last user information to atropos/result/user_links.new
