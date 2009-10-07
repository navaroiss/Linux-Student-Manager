#!/bin/bash
max_length=10

function test_string()
{
	case $1 in
	*[a-z]*|"") return 1;;
	*) return 0
	esac
}
function is_numeric()
{
	if test_string $1;then
		return 0
	else
		return 1
	fi
}
function is_string()
{
	if test_string $1;then
		return 1
	else
		return 0
	fi
}
function test_dbarg()
{
	case $1 in
	"--database="*) 
		i=0
		dbs="`echo $1 | cut -d'=' -f2`"
		for item in `echo $dbs | tr ':' ' '`;do
			if [ -e $db_dir/$item ];then
				let i=$i+1
			fi
		done
		if [ $i -ge 1 ];then
			return 1
		else
			return 0
		fi
		;;
	*) 
	return 0
	esac
}
function is_dbarg()
{
	if test_dbarg $1;then
		return 1
	else
		return 0
	fi
}
function test_leapyear()
{
	let t1=$1%400
	let t2=$1%100
	let t3=$1%4
	if [ $t1 -eq 0 ];then
		return 1
	else 
		if [ ! $t2 -eq  0 -a $t3 -eq 0 ];then
			return 1
		else
			return 0
		fi
	fi
}
function is_leapyear()
{
	if test_leapyear $1;then
		return 1
	else
		return 0
	fi
}
function test_monthname()
{
	case $1 in
		"jan"|"feb"|"mar"|"apr"|"may"|"jun"|"jul"|"aug"|"sep"|"oct"|"nov"| "dec") return 1;;
		*) return 0
	esac
}
function is_monthname()
{
	if test_monthname $1; then
		return 1
	else
		return 0
	fi
}
function test_date()
{
	# dd-mm-yyyy
	#31 28/29 31 30 31 30 31 31 30 31 30 31
	day="`echo $1 | cut -d'-' -f1`"
	month="`echo $1 | cut -d'-' -f2`"
	year="`echo $1 | cut -d'-' -f3`"
	current_year="`date +%Y`"
	if [ $day = $month ];then
		if [  $month = $year ];then
			return 0
		fi
	fi
	if [ $day -lt 1 -o $day -gt 31 ];then
		return 0
	fi
	if is_string $month;then
		if ! is_monthname $month;then
			return 0
		fi
	else
		if [ $month -lt 1 -o $month -gt 12 ];then
			return 0
		fi	
	fi
	if [ $year -lt 1970 -o $year -gt $current_year ];then
		return 0
	fi
	case $month in
		4|6|9|11|04|06|09|"apr"|"jun"|"sep"| "nov" )
			if [ $day -eq 31 ];then
				return 0
			fi
			;;
		2|02| "feb")
			if is_leapyear $year; then
				if [ $day -gt 29 ];then
					return 0
				fi
			else
				if [ $day -gt 28 ];then
					return 0
				fi			
			fi
			;;
		*) 
			return 1
			;;
	esac
	return 1
}
function is_date()
{
	if test_date $1;then
		return 1
	else
		return 0
	fi
}
function test_streamwise()
{
	case $1 in
		"CS" | "IT" | "ET" | "EE" | "EI" | "ME" | "CE") return 1;;
		*) return 0
	esac
}
function is_streamwise()
{
	if test_streamwise $1; then
		return 1
	else
		return 0
	fi
}
function test_match()
{
	result=`echo $1 | grep $2`	
	if [ ! -z $result ];then
		return 1
	fi
	return 0
}
function is_match()
{
	if test_match $1 $2;then
		return 1
	else
		return 0
	fi	
}
