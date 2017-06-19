loc=trindex
if [ ! -d $loc ]; then
	echo "Running sample.sh firstly"
	exit 1
fi
mkdir -p result
proj=$(pwd)/../..
for kws_fn in data/topics.kws.*; do 
	_kws=$(basename $kws_fn)
	num_kws=${_kws##*.}
	cp $loc/$num_kws/00/atropos/result/sample $proj/training/sample 
	cd $proj/training && bash train_super.sh && cd -
	cp $proj/training/atropos/result/samples.train result/samples.train.$num_kws
done
