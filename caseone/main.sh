#!/bin/bash
# Author: Le Dinh Thuong
# eMail: navaroiss@gmail.com
# Date: 26/9/2009
# Deadline: 26/10/2009

DEFAULT_LANG="vi"
PLUS_LANG="en"
PLUS_DB=""
PLUS_LIBS=""
D=":"

libraries="language.sh:display.sh:helper.sh:validate.sh:operation.sh:action.sh"
lang_conf="vi.conf:usage.txt"
database="A:B:C:D"
item_per_table=10

db_dir="./db"
lib_dir="./libraries"
tmp_dir="/tmp"
style_student_id="000000"
lang_dir="./lang"
col_width=13
	
function checking_files()
{
	for item in `echo $1 | tr ":" " "`; do
		file="$3$item"
		if [ -e $file ];then
			if [ $2 = "-r" ];then
				. $file
			fi
		else
			echo "[ERROR] Thiếu files."
			echo "[ERROR] Missing $file."
			exit
		fi
	done
}

function initialize_system()
{
	
	libs=`echo $libraries && echo $PLUS_LIBS`
	dbs=`echo $database && echo $PLUS_DBS`
	
	checking_files $libs -r "libraries/"
	checking_files $lang_conf -n "lang/$DEFAULT_LANG/"
	checking_files $dbs -n "db/"
}

function checking_agrument()
{
	if [ $# -eq 0 ]; then
		software_usage
	fi
	if [ ! -z $1 ]; then
		case $1 in
		"-h" | "--help") software_usage;;
		"-a" | "--action="*) manager $@;;
		"-l" | "--language="*) update_lang $1 $2;;
		*) echo `_ wrong_agr`;;
		esac
	fi
}

function start_program()
{
	# Kiểm tra các file hệ thống
	initialize_system
	# Kiểm tra tham số
	checking_agrument $@
}	
start_program $@
