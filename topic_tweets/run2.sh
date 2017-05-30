runner=Spider/topicRetweetSpider.py
runner_dir=$(dirname $runner)
num_runner=2
for i in $(seq -w 00 $num_runner); do
    cp $i.sub $i/data/.sub;
    cp $input$i $i/data/$input;
    cd $i/$runner_dir;
    screen python $(basename $runner)
    cd -
done

