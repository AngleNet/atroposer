if [ ! -e topics.kws ]; then
	echo "Extract topics' keywords firstly"
	exit 0
fi
proj=$(pwd)/../../../..
cp $proj/topics/*.topk_topic .
cp $proj/samples/atropos/result/tweets.sample .
running_date=$(head $proj/date) 

if [ ! -d atropos ]; then
	git clone -b topic-in-tweet-$running_date  git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd -
fi

lines=$(wc -l tweets.sample|awk '{print $1}')
if [ "${NUM_RUNNER}x" != "x" ];then
	num_runner=${NUM_RUNNER}
else
	num_runner=1
fi
let even=lines/num_runner
let rem=lines%num_runner
if [ ! $rem -eq 0 ]; then
	let even=even+1
fi
split -l $even -d tweets.sample tweets.sample
let num_runner=num_runner-1

for i in $(seq -w 00 $num_runner); do
	if [ -d $i ]; then
		rm -rf $i
	fi
	mkdir $i
	cp -rf atropos $i
	cp tweets.sample$i $i/atropos/data/tweets.sample
	cp *.topk_topic $i/atropos/data/
	cp topics.kws $i/atropos/data
	cp *.txt $i/atropos/resource
	cd $i/atropos/features
	screen /usr/bin/python3 TrendingIndex.py
	cd -
done

