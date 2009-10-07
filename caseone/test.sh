function auto_tab()
{
	line=$1
	col_width=13
	result=""
	ii=1
	col_end=""
	for item in `echo $line | tr ":" " "`;do
		item="| `echo $item | sed 's/__/ /g'`"
		if [ ${#item} -lt $col_width ];then
			let space_width=$col_width-${#item}
			if [ $ii -eq 7 ];then
				result=$result
				col_end=$item`python -c "print '__'*$space_width"`
			else
				result=$result$item`python -c "print '__'*$space_width"`
			fi
		else
			if [ $ii -eq 7 ];then
				result=$result
				col_end=$item
			else
				result=$result$item
			fi
		fi
		let ii=$ii+1
	done
	python -c "print '-'*160"
	echo "| $2 $result$col_end" | sed "s/__/ /g"
}
header="Student ID:First name:Middle name:Last name:Enrollement:Stream ID:Address:Phone :City:State:Zipcode"
auto_tab `echo $header | sed "s/ /__/g"` 0
i=1
cat db/A | while read line;do
	auto_tab `echo $line | sed "s/ /__/g"` $i
	let i=$i+1
done
