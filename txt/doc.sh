#/bin/bash

echo "输入参数：${1}"
array=(11 22 33 44)
echo ${array[*]}
echo ${#array[@]}

for n in "${array[@]}"
do
	echo "for:${n}"
done

cat 20170331.txt | while read line
do
	if [ "${line}" == "a" ]
	then
		echo $line
	elif [ "${line}" == "b" ]
	then
		echo "line:${line}"
	elif [ $line == "1" ]
	then
		if [ $line -eq 1 ]
		then
			echo "line:${line}"
		fi
	else
		echo "${line}"
	fi
	
done

demoFunc() {
	echo "echo a demo func"
}

demoFunc
