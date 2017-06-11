proj_dir=$(pwd)/../..
_date=$(head ${proj_dir}/date)
if [ -d atropos ]; then
	cd atropos && git pull && cd -
else
	git clone topic-in-tweet-${_date} git://github.com/anglenet/atropos
fi
cp data/${_date}.topk_topic atropos/data
cp data/topics.kws atropos/data
cd atropos/Preprocessing && python topkTopicSeries.py && cd -
cp atropos/result/${_date}.topk_topic.* data

if [ -d result ]; then
	echo "'result' directory already exists, remove it fistly"; 
	exit 0
else
	mkdir result
fi
proj_dir=$(pwd)/../..
res_dir=$(pwd)/result
trending_index=${proj_dir}/features/trending_index
training=${proj_dir}/training
export NUM_RUNNER=24
for topk in data/${_date}.topk_topic.*; do
	_k=$(basename ${topk})
	k=${_k##*.}
	cd ${trending_inex} && bash clean.sh && cd -
	cp ${topk} ${trending_index}/${_date}.topk_topic
	cp data/topics.kws.${k} ${trending_index}/topics.kws
	cd ${trending_index} && bash trindex.sh
	let num=NUM_RUNNER-1
	for i in $(seq -w 00 $num); do
		cat $i/result/sample >> sample
	done
	cd ${training} && bash run.sh
	cp atropos/result/samples.train ${res_dir}/samples.train.${k}
done
