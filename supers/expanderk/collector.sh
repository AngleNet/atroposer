set -x
loc=trindex
if [ ! -d $loc ]; then
	echo "Running sample.sh firstly"
	exit 1
fi
proj=$(pwd)/../..
for kws_fn in data/topics.kws.*; do 
	_kws=$(basename $kws_fn)
	num_kws=${_kws##*.}
	cp $loc/$num_kws/00/atropos/result/sample $proj/training/sample 
	cd $proj/training && bash train_super.sh && cd -
	exit
done
