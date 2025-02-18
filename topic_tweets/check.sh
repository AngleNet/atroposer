running_date=$(head ../date)
loc=check_runner
if [ -d $loc ]; then
    echo -n "$loc exists, remove it (y/n)?"
    read ans
    if echo "$ans"|grep -iq "^y"; then
        rm -rf $loc
    fi
fi
mkdir -p $loc && cd $loc
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd - 
fi

input=trending_topics
cp ../../topics/${running_date}.topk_topic $input
cp ../../sub/*.sub .
num_runner=1
lines=$(wc -l $input |awk '{print $1}')
let even=lines/num_runner
let rem=lines%num_runner
if [ ! $rem -eq 0 ]; then
        let even=even+1
fi
split -l $even -d $input $input
runner=Spider/validateTopics.py
runner_dir=$(dirname $runner)
let num_runner=num_runner-1
for i in $(seq -w 00 $num_runner); do
    mkdir -p $i
    cp -r atropos/* $i;
    cp $i.sub $i/data/.sub;
    cp $input$i $i/data/${running_date}.topk_topic
    cd $i/$runner_dir;
    python $(basename $runner)
    cd -
done
cd ..

