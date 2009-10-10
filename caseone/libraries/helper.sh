#!/bin/bash
line_style="*"
line_length=70

function draw_line()
{
	#echo "`python -c "print '$line_style'*$line_length"`"
	echo "**********************************************************************"
}
function draw_header()
{
	draw_line
	draw_string
	draw_string $1
	draw_string
	draw_line
}
function draw_plain_string()
{
	m="$line_style $1"
	if [ ${#m} -lt $line_length ];then
		let left_length=$line_length-${#m}-3
		blank_c="`python -c "print ' '*$left_length"`"
	fi	
	echo "$m $blank_c $line_style"	
}
function draw_string()
{
	nb="`echo $1 | wc -w`"
	if [ $nb -ge 2 ];then
		m="$line_style $1"
	else
		m="$line_style `_ $1`"
	fi
	if [ ${#m} -lt $line_length ];then
		let left_length=$line_length-${#m}-3
		blank_c="`python -c "print ' '*$left_length"`"
	fi	
	echo "$m $blank_c $line_style"
}
function draw_menu_action()
{
	i=1
	draw_string $1
	mm="$2"
	if [ ! -z $2 ];then
		for menu_item in `echo $mm | tr ":" " "`;do
			menus[$i]=`echo $menu_item | sed "s/__/ /g"`
			draw_string "$i) ${menus[$i]}"
			let i=$i+1
		done
		draw_line
	fi
}
function get_option()
{
	while read -p "`_ your_choise`: " index;do
		if [ ! -z "$index" ];then
			if [ ${#index} -eq 1 -o ${#index} -eq 2 ];then
				if is_numeric $index;then
					if [ $index -ge 1 -a $index -le $i ];then
						break
					fi
				fi
			fi
		fi
	done
	if [ ! -z $1 ];then
		if [ $1 = "-k" ];then
			echo "$index"
		else
			echo "${menus[$index]}"
		fi	
	else
		echo "${menus[$index]}"		
	fi
}
function rows_fields()
{
	fields=([0]="Student ID" [1]="First name" [2]="Middle name" [3]="Last name" [4]="Date enrollement" [5]="Stream ID" [6]="Address" [7]="Phone number" [8]="City" [9]="State" [10]="Zipcode")
	draw_header "Ket qua tim thay"
	i=0
	echo "$1" > "$tmp_dir/backup_current_row"
	while [ $i -le 10 ];do
		case $i in
			0) item=`echo $1 | cut -d":" -f1`;;
			1) item=`echo $1 | cut -d":" -f2`;;
			2) item=`echo $1 | cut -d":" -f3`;;
			3) item=`echo $1 | cut -d":" -f4`;;
			4) item=`echo $1 | cut -d":" -f5`;;
			5) item=`echo $1 | cut -d":" -f6`;;
			6) item=`echo $1 | cut -d":" -f7`;;
			7) item=`echo $1 | cut -d":" -f8`;;
			8) item=`echo $1 | cut -d":" -f9`;;
			9) item=`echo $1 | cut -d":" -f10`;;
			10) item=`echo $1 | cut -d":" -f11`
		esac
		if [ -z $item ];then
			item="----------"
		fi
		value="`echo $item | sed 's/__/ /g'`"
		draw_plain_string "${fields[$i]} : $value"
		let i=$i+1
	done
	draw_line
}
function col_field()
{
	if [ ! -z $1 ];then
		data=$1
	fi
	i=0
	x=""
	for item in `echo $data | tr ":" " "`;do
		segment="`fshift_segment $data`"
		echo "| $item $x"
		x=`col_field $segment`		
		let i=$i+1
	done
}
function auto_tab()
{
	# Cho cot address ra sau cung
	line=$1
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
	if [ ! -z $2 ];then
		if [ $2 -le 9 ];then
			stt="0$2"
		else
			stt=$2
		fi	
	fi
	if [ ! -z $3 ];then
		if [ $3 = "-e" ];then
			let fullwidth=$col_width*12
			python -c "print '-'*$fullwidth"
			echo "| $stt    $result$col_end" | sed "s/__/ /g"
		else
			let fullwidth=$col_width*11
			python -c "print '-'*$fullwidth"
			echo "| $stt    $result" | sed "s/__/ /g"
		fi
	else
		let fullwidth=$col_width*11
		python -c "print '-'*$fullwidth"
		echo "| $stt    $result" | sed "s/__/ /g"
	fi
}
function table_fields()
{
	header="`_ student_id`:`_ student_firstname`:`_ student_middlename`:`_ student_lastname`:`_ student_dateenroll`:`_ student_streamid`:`_ student_address`:`_ student_city`:`_ student_state`:`_ student_zipcode`:`_ student_phone`"
	if [ -z $2 ];then
		if [ ! -z $1 ];then
			i=1
			total_rows=`cat $1 | wc -l`
			printf "`_ result_found`\n" $total_rows
			if [ $i -eq 1 ];then
				auto_tab `echo $header | sed "s/ /__/g"` "0"
			fi
			if [ $total_rows -le $item_per_table ];then
				cat $1 | while read line;do
					auto_tab `echo $line | sed "s/ /__/g"` $i
					let i=$i+1
				done		
			else
				let sd=$total_rows%$item_per_table
				if [ $sd -eq 0 ];then
					let total_pages=$total_rows/$item_per_table
				else
					let x1=$total_rows/$item_per_table
					page=`echo $x1 | cut -d"." -f1`
					let page=$page+1
				fi
		
				i=1
				cat $1 | while read line;do
					if [ $i -ge 1 -a $i -le $item_per_table ];then
						auto_tab `echo $line | sed "s/ /__/g"` $i
					fi
					let i=$i+1
				done
				printf "`_ page_results`\n" $page
				echo "`_ page_nav`"
		
				i=1
				while read -p "`_ put_page_view`: " page_input;do
					length=`echo $page_input | wc -w`
					if [ $length -eq 1 ];then
						if [ $page_input = "x" ];then
							echo "`_ quit`"
							return
						fi
						if is_numeric $page_input;then
							if [ $page_input -ge 1 -a $page_input -le $page ];then
								let test=$page_input-1
								let start=($page_input-1)*$item_per_table
								let limit=$start+$item_per_table-1
								if [ $test -eq 0 ];then
									let start=1
									let limit=$start+$item_per_table-1
								fi
								cat $1 | while read line;do
									if [ $i -ge $start -a $i -le $limit ];then
										auto_tab `echo $line | sed "s/ /__/g"` $i
									fi
									let i=$i+1
								done
								printf "`_ page_current`\n" $page_input
								printf "`_ page_results`\n" $page
								echo "`_ page_nav`"
								
							else
								echo "`_ page_not_found`"
								echo "`_ quit`"
								return						
							fi
						fi
					fi
				done
			fi
		fi
	else
		if [ $2 = "-e" ];then
			dest_file=$3
			data_file=$5
			stream_id=$7
			i=1
			echo "`_ student_streamid`: $stream_id" > $dest_file
			echo "`_ semester_wise`: `echo $data_file | tr ':' ','`" >> $dest_file
			echo "`_ put_description`: `echo $9 | sed "s/__/ /g"`" >> $dest_file
			echo -n "`_ extracting_to` $dest_file..."
			auto_tab `echo $header | sed "s/ /__/g"` "*" -e >> $dest_file
			cat $1 | while read line;do
				auto_tab `echo $line | sed "s/ /__/g"` $i -e >> $dest_file
				let i=$i+1
			done
			echo "`_ done`"
		fi
	fi
}
