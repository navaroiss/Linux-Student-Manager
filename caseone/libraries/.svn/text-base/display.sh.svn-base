#!/bin/bash
FORGROUND_COLOR=0
BACKGROUND_COLOR=1

function display_bold()
{
	#Chữ đậm
	tput bold
}
function display_reset()
{
	#Reset lại các thiết lập ban đầu cho chế độ hiển hiện
	tput reset
}
function display_default()
{
	#Reset lại các thiết lập ban đầu cho chế độ hiển hiện
	tput sgr0
}
function display_foreground_color()
{
	#Thiết lập nền cho foreground
	tput setaf {FORGROUND_COLOR}
}
function display_background_color()
{
	#Thiết lập background
	tput setab {BACKGROUND_COLOR}
}
