#!/bin/bash
function _()
{
# Hàm translation cho các ngôn ngữ
	# Hàm tìm chuỗi có giá trị tương ứng của ngôn ngữ dựa vào từ khóa cung cấp.
	l=`get_lang`
	cat $lang_dir/$l/$l.conf | while read line; do
		key=`echo $line | cut -d"=" -f1`
		if [ ! $1 = "" ]; then
			if [ $1 = "$key" ];then
				echo `echo $line | cut -d"=" -f2`
			fi
		else
			return 1
		fi
	done
}

function get_lang()
{
# Xác định ngôn ngữ đang dùng
	if [ -e $tmp_store_lang ];then
		soft_lang=`cat "$lang_dir/config.conf"`
		if [ ! -z $soft_lang ];then
			echo $soft_lang
		else
			echo $DEFAULT_LANG
		fi
	else
		echo $DEFAULT_LANG
	fi
}

function software_usage()
{
# In hướng dẫn sử dụng
 	display_bold
 	tput clear
 	if _; then
	 	display_default 
 	else
		cat $lang_dir/`get_lang`/usage.txt
 	fi
	display_default
}

function define_lang()
{
# Định nghĩa ngôn ngữ sẽ dùng cho phần mềm này.
# Mặc định ban đầu là tiếng Việt.
	if [ ! -z $1 ];then
		_usage="$lang_dir/$1/usage.txt"
		_data="$lang_dir/$1/$1.conf"
		if [ -e $_data -a -e $_usage ];then
			export SOFT_LANG=$1
		fi
	fi

	if [ -z $SOFT_LANG ];then
		if [ ! -z $DEFAULT_LANG ]; then
			export SOFT_LANG=$DEFAULT_LANG
		fi
	fi
	echo "$SOFT_LANG" > "$lang_dir/config.conf"
}
function list_lang()
{
# Liệt kê danh sách các ngôn ngữ có thể sử dụng cho phần mềm
	current_lang=`cat $lang_dir/config.conf`
	lang_name=`cat "$lang_dir/$current_lang/name.conf" | cut -d"-" -f2`
	echo "`_ current_lang`: $lang_name"
	echo "`_ select_language`:"
	i=1
	for item in `ls ./lang`;do
		if [ -d "$lang_dir/$item" ];then
			ct=`cat $lang_dir/$item/name.conf`
			echo "$i) $ct"
			lang[$i]=$item
			let i=$i+1
		fi
	done
	index=0
	while [ $index -lt 1 -o $index -ge $i ];do 
		read -p ">>> " index
		if is_string $index;then
			index=0
		fi
	done
	if [ ! -z ${lang[$index]} ];then
		define_lang ${lang[$index]}
	fi
}
function update_lang()
{
# Cập nhật ngôn ngữ
	if [ ! -z $1 ];then
		if [ $1 = "-l" ];then
			if [ ! -z $2 ];then
				if [ -e "$lang_dir/$2/name.conf" ];then
					define_lang $2
				else
					list_lang
				fi
			else
				list_lang
			fi
		else
			lang=`echo $1 | cut -d"=" -f2`
			define_lang $lang
		fi
		echo "`_  selected_lang`" 
	fi
}
