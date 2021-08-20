#!/bin/sh

case "$1" in

set)
	shift
	for dir in $@; do
		for i in $dir/*0 ; do
			echo $i
			sh $0 md5sum $dir $(basename $i) | tee $i/md5sum
		done
	done ;;

md5sum)
	n=1; ofs=0; dir=${2:-4.0}; size=${3:-1474560}
	SETS="$(sed '/sets =/!d;s|.*\[||;s|\].*||;s|,| |g' index-$dir.html)"

	for max in $SETS; do :; done
	[ ! -s $dir/fd.img ] && cat $dir/fd???.img > $dir/fd.img && dd size=0 bs=1 seek=$max 2>/dev/null
	for max in $SETS; do
		while true; do
			[ $(stat -c %s $dir/fd.img) -gt $ofs ] || break 2
			dd if=$dir/fd.img bs=512 skip=$(($ofs/512)) count=$(($size/512)) \
			  2>/dev/null | md5sum | sed "s|-$|fd$(printf "%03d" $n).img|"
			ofs=$(($ofs+$size)); n=$(($n+1))
			[ $ofs -ge $max ] && n=$(($n-($n%100)+100)) && break
		done
	done ;;

*)	cat <<EOT
Usage:

$0 md5sum directory [floppy bytes]
   display the md5sum file

$0 set directory...
   create every directory/*/md5sum file
EOT
esac
