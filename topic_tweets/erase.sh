running_date=$(head ../date)
if [ ! -d check_runner ]; then
	echo "Run check.sh firstly"
	exit 0
fi

cd check_runner
while read line; do
	sed -i "s/$line//g' ${running_date}.topk_topic
done << cat ${running_date}.topk_topic.fail
