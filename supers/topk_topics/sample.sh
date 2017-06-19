set -x
proj_dir=$(pwd)/../..
_date=$(head ${proj_dir}/date)
if [ -d atropos ]; then
	cd atropos && git pull && cd -
else
	git clone -b topic-in-tweet git://github.com/anglenet/atropos
fi
cp $proj_dir/topics/${_date}.topk_topic atropos/data
cp data/topics.kws atropos/data
cd atropos/Preprocessing && python topkTopicSeries.py && cd -
cp atropos/result/${_date}.topk_topic.* data
cp atropos/result/topics.kws.* data

trindex=$proj_dir/features/trending_index
cd $trindex && bash clean.sh && cd -
mkdir -p trindex && cd trindex
for fn in ../data/${_date}.topk_topic.*; do 
	_k=$(basename $fn)
	k=${_k##*.}
	mkdir -p $k
	cp -rf $trindex/* $k
	cp $fn $k/${_date}.topk_topic
	cp ../data/topics.kws.$k $k/topics.kws
	cp ../trindex_super.sh $k
	cd $k && bash trindex_super.sh && cd -
done
