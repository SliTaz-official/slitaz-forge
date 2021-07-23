#!/bin/sh

get()
{
	hexdump -v -s $1 -n ${4:-${3:-2}} -e "\"\" 1/${3:-2} \" %u\n\"" "$2"
}

n=$((1 + $(get 497 $1/fd001.img 1) + 1 + ($(get 500 $1/fd001.img 4)-1)/32))
last=$(($n*512))
first=$last
dir=$1
n=$((512*$(get 497 $1/fd001.img 1) + 512 - 20))
SET=""
if [ -s $1/fd100.img ]; then
	for i in 0 1 2 3; do
		x=$(get $n $1/fd001.img 4)
		last=$(($last+$x))
		[ $x -eq 0 ] && SET="" && break
		SET="$SET $last"
		n=$(($n+4))
	done
	file=$1/fd.img
	cat $1/fd???.img > $file
	set -- $first $SET
	while [ -n "$2" ]; do
		n=$(get $1 $file)
		shift
		case $n in
		\ 14128|\ 93) continue ;;
		esac
		rm $file
		SET=""
		break
	done
else
	if [ $(get 494 $1/fd001.img) -eq 490 ]; then
		SET="$(($first+$(get 490 $1/fd001.img 4)))"
		cat $1/fd???.img > $1/fd.img
		set -- $SET
	fi
fi
if [ -n "$SET" ]; then
	size=$1
	best=$1
	cd $dir
	for i in $(sed '/option value/!d;s|.*value=.||;s|. title.*||' ../format.js); do
		s=$((((($size-1)/$i)+1)*$i))
		[ $s -gt $best ] && best=$s
		dd of=fd.img bs=1 count=0 seek=$s 2> /dev/null
		[ -d $i ] || mkdir $i
		cd $i
		split -b $i ../fd.img xx
		set -- $SET
		n=1; sz=0
		ls xx* | while read x; do
			mv $x $(printf "fd%03d.img" $n)
			n=$(($n+1))
			sz=$(($sz+$i))
			if [ $sz -ge $1 ]; then
				n=$(($n-($n%100)+100))
				shift
				[ -n "$1" ] || break
			fi
		done
		md5sum fd* > md5sum
		rm fd*
		cd ..
	done
	dd of=fd.img bs=1 count=0 seek=$best 2> /dev/null
	cd ..
	echo $SET
fi
