function manager()
{
# Xác định và gọi action
	if [ $1 = "-a" ];then
		if [ -z $2 ];then
			action_list="add:edit:del:find:dump:exit" # Data cung cap cho ham ve menu
			draw_line
			draw_menu_action missing_action $action_list  # Ve menu
			user_act=`get_option`
			
			case  $user_act in
			"add") add_row;;
			"edit") edit_row;;
			"del") del_row;;
			"find") find_row;;
			"dump") export_data;;
			"exit") 
			echo "`_ quit`!"
			return 
			;;
			*) echo `_ wrong_agr`
			esac
		else
			case $2 in
			"add") add_row $3 $4;;
			"edit") edit_row $3 $4;;
			"del") del_row $3 $4;;
			"find") find_row $3 $4;;
			"dump") export_data $3 $4;;
			*) echo `_ wrong_agr`
			esac
		fi
	else
		action=`echo $1 | cut -d"=" -f2`
		case $action in
		"add") add_row $2 $3;;
		"edit") edit_row $2 $3;;
		"del") del_row $2 $3;;
		"find") find_row $2 $3;;
		"dump") export_data $2 $3;;
		*) echo `_ wrong_agr`
		esac
	fi
}

function add_row()
{
# Thêm sinh viên vào database.
# Chỉ thêm 1 sinh viên vào 1 database cùng lúc.
	get_db_name $1 $2
	if [ -e $db_dir/$db ];then
		last_id="`find_last_row $db_dir/$db`"
		if [ -z $last_id ];then
			last_id="$db$style_student_id"
		fi
		next_last_id="`next_last_id $last_id`"
		draw_header action_add_student
		get_student_firstname
		get_student_middlename
		get_student_lastname
		get_student_dateenroll
		get_student_streamid
		get_student_address
		get_student_phone
		get_student_city
		get_student_state
		get_student_zipcode
		echo "$next_last_id:$firstname:$middlename:$lastname:$date_enroll:$stream_id:$address:$phone:$city:$state:$zipcode" >> "$db_dir/$db"
		echo "`_ action_add_student_success`."
	else
		echo "`_ database_not_found`."
		echo "`_ quit`."
	fi
}
function del_row()
{
# Xóa sinh viên ra khỏi danh sách
	draw_header action_del_student
	get_db_name $1 $2
	if [ -e $db_dir/$db ];then
		if [ -e "$tmp_dir/after_delete_row" ];then
			rm "$tmp_dir/after_delete_row"
			rm "$tmp_dir/delete_item"
		fi
		read -p "`_ put_student_id`: " student_id
		found=0
		cat $db_dir/$db | while read line; do
			mssv=`echo $line | cut -d":" -f1`
			if [ ! -z $mssv ];then
				if [ $mssv = $student_id ];then
					echo $line > "$tmp_dir/delete_item"
				else
					echo $line >> "$tmp_dir/after_delete_row"
				fi
			fi
			let i=$i+1
		done
		if [ -e "$tmp_dir/delete_item" ];then
			if [ -e "$tmp_dir/after_delete_row" ];then
				rm "$db_dir/$db"
				mv "$tmp_dir/after_delete_row" "$db_dir/$db"
				rm "$tmp_dir/delete_item"
			fi
			echo "`_ action_del_student_success`"
		else
			if [ -e "$tmp_dir/after_delete_row" ];then
				rm "$tmp_dir/after_delete_row"
			fi
			echo "`_ student_not_found`"
		fi
	else
		echo "`_ database_not_found`."
		echo "`_ quit`."
	fi
}
function edit_row()
{
# Cập nhật thông tin sinh viên.
	draw_header action_edit_student
	get_db_name $1 $2
	if [ -e $db_dir/$db ];then
		if [ -e "$tmp_dir/after_edit_row" ];then
			rm "$tmp_dir/after_edit_row"
		fi
		read -p "`_ put_student_id`: " student_id
	
		i=0
		f="$tmp_dir/is_found"
		if [ -e $f ];then
			rm $f
		fi
		cat $db_dir/$db | while read line; do
			mssv=`echo $line | cut -d":" -f1`
			if [ $mssv = "$student_id" ];then
				rows_fields `echo $line | sed "s/ /__/g"`
				touch $f
				break
			fi
			let i=$i+1
		done
		if [ -e $f ];then
			get_student_firstname ^
			get_student_middlename ^
			get_student_lastname ^
			get_student_dateenroll ^
			get_student_streamid ^
			get_student_address ^
			get_student_phone ^
			get_student_city ^
			get_student_state ^
			get_student_zipcode ^
			cat $db_dir/$db | while read line; do
				mssv=`echo $line | cut -d":" -f1`
				if [ $mssv = "$student_id" ];then
					line="`echo $mssv:$firstname:$middlename:$lastname:$date_enroll:$stream_id:$address:$phone:$city:$state:$zipcode | sed 's/__/ /g'`"
				fi
				echo $line >> "$tmp_dir/after_edit_row"
				let i=$i+1
			done
			mv "$db_dir/$db" "$tmp_dir/backup"
			mv "$tmp_dir/after_edit_row" "$db_dir/$db"
			rm "$f"
			echo "`_ action_edit_student_success`"
		else
			echo "`_ student_not_found`"
		fi
	else
		echo "`_ database_not_found`."
		echo "`_ quit`."
	fi
}
function find_row()
{
# Tìm kiếm sinh viên theo các tiêu chí:
# + Mã số sinh viên
# + Tên sinh viên
# + Nghành học
# + Học kì
# + Thành phố
# + Mã vùng

	draw_header action_find_student
	get_db_name $1 $2
	menu="`_ student_id`:`_ student_name`:`_ student_streamid`:`_ semester_wise`:`_ student_city`:`_ student_state`"
	draw_line
	draw_menu_action select_find_type `echo $menu | sed "s/ /__/g"`
	selected_option=`get_option -k`

	case $selected_option in
	1)
		while read -p "`_ student_id`: " student_id;do
			if [ ! -z $student_id ];then
				break
			fi
		done
		find_student $db 1 "`echo $student_id | sed 's/ /__/g'`"
		;;
	3)
		get_student_streamid
		find_student $db 2 "`echo $stream_id | sed 's/ /__/g'`"
		;;
	4)
		i=1
		if [ -e "$tmp_dir/search_tmp_result" ];then
			rm "$tmp_dir/search_tmp_result"
		fi
		for item in `echo $db | tr ":" " "`;do
			cat "$db_dir/$item" >> "$tmp_dir/search_tmp_result"
		done
		table_fields "$tmp_dir/search_tmp_result"
		rm "$tmp_dir/search_tmp_result"
		return
		;;
	5)
		get_student_city
		find_student $db 3 "`echo $city | sed 's/ /__/g'`"
		;;
	6) 
		get_student_state
		find_student $db 4 "`echo $state | sed 's/ /__/g'`"
		;;
	2)
		while read -p "`_ put_student_name`: " student_name;do
			if [ ${#student_name} -ge 1 ];then
				break
			fi
		done
		find_student $db 5 "`echo $student_name | sed 's/ /__/g'`"
		;;
	esac
		
	if [ -e "$tmp_dir/search_tmp_result" ];then
		table_fields "$tmp_dir/search_tmp_result"
		rm "$tmp_dir/search_tmp_result"
	else
		echo "`_ student_not_found`"
	fi
}
function export_data()
{
# Xuất dữ liệu ra định dạng excel
	menu="`_ export_type_1`:`_ export_type_2`:`_ all`" #Stream wise and semester wise:Stream wise report of all students
	draw_header export_type
	draw_menu_action action_export `echo $menu | sed "s/ /__/g"`
	selected_option=`get_option -k`
	export_file="Export-`date +%d-%m-%Y`.txt"
	if [ -e "$tmp_dir/search_tmp_result" ];then
		rm "$tmp_dir/search_tmp_result"
	fi	
	case $selected_option in
		1) 
		#draw_line
		get_db_name $1 $2
		get_student_streamid
		find_student $db 2 "`echo $stream_id | sed 's/ /__/g'`"
		;;
		2) 
		#draw_line
		get_student_streamid
		db=$database
		find_student $db 2 "`echo $stream_id | sed 's/ /__/g'`"
		;;
		3)
		#draw_line
		get_db_name $1 $2
		for db_item in `echo $db | tr ':' ' '`;do
			cat "$db_dir/$db_item" >> "$tmp_dir/search_tmp_result"
		done
		;;
		*)
		echo `_ invaild_selection`
		echo `_ quit`
		return
		;;
	esac
	if [ -e "$tmp_dir/search_tmp_result" ];then
		read -p "`_ put_description`: " description
		description="`echo $description | sed 's/ /__/g'`"
		file_type_menu="Text:CSV:Excel"
		draw_line
		draw_menu_action action_export_type `echo $file_type_menu | sed "s/ /__/g"`
		file_type=`get_option -k`
		case $file_type in
		1)
		table_fields "$tmp_dir/search_tmp_result" -e $export_file -d "$db" -s "$stream_id" -m $description
		;;
		2)
		export_as_csv "$tmp_dir/search_tmp_result" -e $export_file -d "$db" -s "$stream_id" -m $description
		;;
		3)
		export_as_excel "$tmp_dir/search_tmp_result" -e $export_file -d "$db" -s "$stream_id" -m $description
		;;
		*)
		# Mac dinh la xuat ra TEXT
		table_fields "$tmp_dir/search_tmp_result" -e $export_file -d "$db" -s "$stream_id" -m $description
		esac
		rm "$tmp_dir/search_tmp_result"
	else
		echo "`_ student_not_found`"
	fi
}

