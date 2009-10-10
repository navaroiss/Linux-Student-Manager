#!/bin/bash
function get_data_from_backup()
{
	old_data=`cat $tmp_dir/backup_current_row`
	case $1 in
		1) item=`echo $old_data | cut -d":" -f1`;;
		2) item=`echo $old_data | cut -d":" -f2`;;
		3) item=`echo $old_data | cut -d":" -f3`;;
		4) item=`echo $old_data | cut -d":" -f4`;;
		5) item=`echo $old_data | cut -d":" -f5`;;
		6) item=`echo $old_data | cut -d":" -f6`;;
		7) item=`echo $old_data | cut -d":" -f7`;;
		8) item=`echo $old_data | cut -d":" -f8`;;
		9) item=`echo $old_data | cut -d":" -f9`;;
		10) item=`echo $old_data | cut -d":" -f10`;;
		11) item=`echo $old_data | cut -d":" -f11`
	esac
	echo $item
}
function find_last_row()
{
	if [ ! -z $1 ];then
		cat $1 | sort -t ":" -r | head -n1 | cut -d":" -f1
	fi
}
function next_last_id()
{
	# A09999
	#
	# A10000
	string=$1
	i=0
	number=0
	prx=""
	while [ $i -lt ${#string} ];do
		int="${string:$i:1}" # Cat tu vi tri thu $i 1 ki tu
		if is_numeric $int;then
			strlen=${#string}	
			pcl=${string:$i:$strlen}
			if [ $int -ge 1 ];then
				if is_numeric $pcl; then
					let e=${#string}-$i+1
					number="${string:$i:$e}"
					break
				fi
			else
				prx="$prx$int"	
			fi
		else
			prx="$prx$int"	
		fi
		let i=$i+1
	done
	let number=$number+1
	let sd=$number%10
	if [ $sd -eq 0 ];then
		let prxlenth=${#prx}-1
		prx="${prx:0:$prxlenth}"
	fi
	echo "$prx$number"
}

function get_db_value()
{
	echo $1 | cut -d'=' -f2
}

function get_db_name()
{
	# draw_line
	if [ ! -z $1 ] ; then
		if [ $1 = "-db" ];then
			if [ ! -z $2 ];then
				db=$2
			else
				draw_menu_action select_database $database
				db=`get_option`
			fi		
		else
			if is_dbarg $1; then
				db=`get_db_value $1`
			else
				draw_menu_action select_database $database
				db=`get_option`				
			fi
		fi
	else
		draw_menu_action select_database $database
		db=`get_option`
	fi
}
function get_student_firstname()
{
	while read -p "`_ student_firstname`: " firstname;do
		if [ ! -z $1 ];then
			if [ "$firstname" = "$1" ];then
				firstname=`get_data_from_backup 2`
				break
			fi
		fi
		length=`echo $firstname | wc -w`
		if [ $length -eq 1 ] && is_string $firstname;then
			break
		fi
	done
}
function get_student_middlename()
{
	while read -p "`_ student_middlename`: " middlename;do
		if [ ! -z $1 ];then
			if [ "$middlename" = "$1" ];then
				middlename=`get_data_from_backup 3`
				break
			fi
		fi
		length=`echo $middlename | wc -w`
		if [ $length -eq 1 ] && is_string $middlename;then
			break
		fi
	done
}
function get_student_lastname()
{
	while read -p "`_ student_lastname`: " lastname;do
		if [ ! -z $1 ];then
			if [ "$lastname" = "$1" ];then
				lastname=`get_data_from_backup 4`
				break
			fi
		fi
		length=`echo $lastname | wc -w`
		if [ $length -eq 1 ] && is_string $lastname;then
			break
		fi
	done
}
function get_student_dateenroll()
{
	while read -p "`_ student_dateenroll`: " date_enroll;do
		if [ ! -z $1 ];then
			if [ "$date_enroll" = "$1" ];then
				date_enroll=`get_data_from_backup 5`
				break
			fi
		fi
		if [ ! -z $date_enroll ];then
			if is_date $date_enroll;then
				break
			fi
		fi
	done
}
function get_student_streamid()
{
	while read -p "`_ student_streamid` (CS/IT/ET/EE/EI/ME/CE): " stream_id;do
		if [ ! -z $1 ];then
			if [ "$stream_id" = "$1" ];then
				stream_id=`get_data_from_backup 6`
				break
			fi
		fi
		length=`echo $stream_id | wc -w`
		if [ $length -eq 1 ];then
			if is_streamwise $stream_id;then
				break
			fi
		fi
	done
}
function get_student_phone()
{
	while read -p "`_ student_phone`: " phone;do
		if [ ! -z $1 ];then
			if [ "$phone" = "$1" ];then
				phone=`get_data_from_backup 8`
				break
			fi
		fi
		length=`echo $phone | wc -w`
		if [ $length -eq 1 ];then
			if [ ${#phone} -ge 7 ];then
				if is_numeric $phone;then
					break			
				fi
			fi
		fi
	done
}
function get_student_address()
{
	while read -p "`_ student_address`: " address;do
		if [ ! -z $1 ];then
			if [ "$address" = "$1" ];then
				address=`get_data_from_backup 7`
				break
			fi
		fi
		length=`echo $address | wc -w`
		if [ $length -ge 1 ];then
			break
		fi
	done
}
function get_student_city()
{
	while read -p "`_ student_city`: " city;do
		if [ ! -z $1 ];then
			if [ "$city" = "$1" ];then
				city=`get_data_from_backup 9`
				break
			fi
		fi
		length=`echo $city | wc -w`
		if [ $length -ge 1 ];then
			break
		fi
	done
}
function get_student_state()
{
	while read -p "`_ student_state`: " state;do
		if [ ! -z $1 ];then
			if [ "$state" = "$1" ];then
				state=`get_data_from_backup 10`
				break
			fi
		fi
		length=`echo $state | wc -w`
		if [ $length -ge 1 ];then
			break
		fi
	done
}
function get_student_zipcode()
{
	while read -p "`_ student_zipcode`: " zipcode;do
		if [ ! -z $1 ];then
			if [ "$zipcode" = "$1" ];then
				zipcode=`get_data_from_backup 11`
				break
			fi
		fi
		length=`echo $zipcode | wc -w`
		if [ $length -ge 1 ];then
			break
		fi
	done
}
function find_student()
{
	if [ -e "$tmp_dir/search_tmp_result" ];then
		rm "$tmp_dir/search_tmp_result"
	fi
	for db_item in `echo $1 | tr ":" " "`;do
		if [ -e $db_dir/$db_item ];then
			cat "$db_dir/$db_item" | while read line;do
				case $2 in
					1) value=`echo $line | cut -d':' -f1`;;
					2) value=`echo $line | cut -d':' -f6`;;
					3) value=`echo $line | cut -d':' -f9`;;
					4) value=`echo $line | cut -d':' -f10`;;
					5) 
					firstname=`echo $line | cut -d':' -f2`
					middlename=`echo $line | cut -d':' -f3`
					lastname=`echo $line | cut -d':' -f4`
					value="$firstname $middlename $lastname $middlename $firstname"
					;;
				esac
				if is_match `echo $value | sed "s/ /__/g"` $3 ;then
					echo $line >> "$tmp_dir/search_tmp_result"
				fi
			done
		fi
	done
}
function fshift_segment()
{
	if [ ! -z $1 ];then
		i=0;
		data=`echo $1 | sed "s/ /__/g"`
		rs=""
		sp=""
		for item in `echo $data | tr ":" " "`;do
			if [ ! $i -eq 0 ];then
				if [ ! $rs = "" ];then
					sp=":"
				fi
				rs="$rs$sp$item"	
			fi
			let i=$i+1
		done
		echo $rs
	fi
}
function export_as_excel()
{
	excel_content=`cat $lib_dir/xlsformat`
	excel_file="`echo $3 | sed 's/\.txt/\.xls/'`"
	if [ ! -z $1 ];then
		if [ -e $1 ];then
			export_date=`date +%d-%m-%Y`
			echo -n "`_ extracting_to` $excel_file..."
			echo $excel_content > $excel_file
			case $selected_option in
				1) export_type=`_ export_type_1` ;;
				2) export_type=`_ export_type_2` ;;
				3) export_type=`_ export_type_3` ;;
				*) export_type=`_ export_type_1`
			esac
			echo "<tr><td class=xl24 colspan=11>$export_type</td></tr>" >> $excel_file
			if [ ! -z $stream_id ];then
				echo "<tr><td class=xl24 width=64>`_ student_streamid`</td><td class=xl24 colspan=10> $stream_id</td></tr>" >> $excel_file
			fi
			echo "<tr><td class=xl24 width=64>`_ semester_wise`</td><td class=xl24 colspan=10> `echo $5 | tr ':' ','`</td></tr>" >> $excel_file
			if [ ! -z $put_description ];then
				echo "<tr><td class=xl24 width=64>`_ put_description`</td><td class=xl24 colspan=10> `echo $9 | sed 's/__/ /g'`</td></tr>" >> $excel_file
			fi
			echo "<tr><td class=xl24 width=64>`_ date_generate`</td><td class=xl24 colspan=10>$export_date</td></tr>" >> $excel_file
			echo "<tr><td class=xl24 colspan=11></td></tr>" >> $excel_file
			header="`_ student_id`:`_ student_firstname`:`_ student_middlename`:`_ student_lastname`:`_ student_dateenroll`:`_ student_streamid`:`_ student_address`:`_ student_phone`:`_ student_city`:`_ student_state`:`_ student_zipcode`"
			echo "<tr><td class=xl24 width=64>`echo $header | sed "s/:/<\/td><td class=xl24 width=64>/g"`</td></tr>" >> $excel_file
			cat $1 | while read line;do
				row=`echo $line | sed "s/:/<\/td><td class=xl24 width=64>/g"`
				echo "<tr><td class=xl24 width=64>$row</td></tr>" >> $excel_file
			done
			echo "</table></body></html>" >> $excel_file
			echo "`_ done`"
		fi
	fi
}
function export_as_csv()
{
	if [ ! -z $1 ];then
		if [ -e $1 ];then
			export_date=`date +%d-%m-%Y`
			csv_file="`echo $3 | sed 's/\.txt/\.csv/'`"
			echo -n "`_ extracting_to` $csv_file..."
			header="mssv:firstname:middlename:lastname:date_enroll:streamid:address:phone:city:state:zipcode"
			echo "\"`echo $header | sed 's/:/";"/g'`\"" > $csv_file
			cat $1 | while read line;do
				line=`echo $line | sed 's/:/";"/g'`
				echo "\"$line\"" >> $csv_file
			done
			echo "`_ done`"
		fi
	fi
}
