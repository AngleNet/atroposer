loc=trindex
if [ -d $loc ]; then
	rm -rf $loc
fi
proj=$(pwd)/../..
trindex=$proj/features/trending_index
cd $trindex && bash clean.sh && cd -
mkdir -p $loc && cd $loc
for kws_fn in ../data/topics.kws.*; do 
	_kws=$(basename $kws_fn)
	num_kws=${_kws##*.}
	mkdir -p $num_kws
	cp -rf $trindex/* $num_kws
	cp $kws_fn $num_kws/topics.kws
	cp ../trindex_super.sh $num_kws
	cd $num_kws && bash trindex_super.sh && cd -
done
