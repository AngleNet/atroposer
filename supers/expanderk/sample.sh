if [ -d result ]; then
	echo "'result' directory already exists, remove it fistly"; 
	exit 0
else
	mkdir result
fi
proj_dir=$(pwd)/../..
res_dir=$(pwd)
trending_index=${proj_dir}/features/trending_index
training=${proj_dir}/training
export NUM_RUNNER=24
for kws in data/topics.kws.*; do
	_kws=$(basename ${kws})
	num_kws=${_kws##*.}
	cd ${trending_inex} && bash clean.sh && cd -
	cp $kws ${trending_index}/topics.kws
	cd ${trending_index} && bash trindex.sh
	let num=NUM_RUNNER-1
	for i in $(seq -w 00 $num); do
		cat $i/result/sample >> sample
	done
	cd ${training} && bash run.sh
	cp atropos/result/samples.train ${res_dir}/samples.train.${num_kdw}
done
