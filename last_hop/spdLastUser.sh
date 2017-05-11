loc=spide_users
echo -n "We are going to remove $(pwd)/$loc, are you sure (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
	rm -rf $loc
fi
mkdir -p $loc && cd $loc
if [ ! -d atropos ]; then
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
else
	cd atropos && git pull && cd - 
fi
#Copy incomplete user links.
cp ../atropos/result/user_links.new ./user_links
#Copy .sub files
cp ../*.sub .
#Copy user links library to avoid unnessarary spiding.
cp ../../users/user_links.new atropos/resource/user_links.new
input=user_links
num_runner=3
lines=$(wc -l $input |awk '{print $1}')
let even=lines/num_runner
let rem=lines%num_runner
if [ ! $rem -eq 0 ]; then
        let even=even+1
fi
split -l $even -d $input $input
runner=Runner/userSpider.py
runner_dir=$(dirname $runner)
let num_runner=num_runner-1
for i in $(seq -w 00 $num_runner); do
    mkdir -p $i
    cp -r atropos/* $i;
    cp $i.sub $i/data/.sub;
    cp $input$i $i/data/$input;
    cd $i/$runner_dir;
    screen python $(basename $runner)
    cd -
done
cd ..
