#!/bin/sh

WD=$(cd $(dirname $0); pwd)
while read name iso; do
    [ -d $WD/$name ] || continue
    cd $WD/$name
    ISO=$(ls -t ../../$iso | sed q)
    [ -s "$ISO" ] || continue
    if [ ! -s fd001.img ] || [ $ISO -nt fd001.img ]; then
	rm -f fd* 2> /dev/null
	taziso $ISO floppyset > /dev/null
	md5sum fd* > md5sum
	mnt=/mnt$$
	mkdir $mnt
	mount -o loop,ro $ISO $mnt
	mtime=$(stat -c %y $mnt/md5sum | cut -f1 -d ' ')
	[ $(date --help 2>&1 | sed '/^BusyB/!d;s/.* v\([^ ]*\).*/\1/;s/\./ /g'\
		 | awk '{ printf "%d%02d\n",$1,$2 }') -gt 126 ] &&
		mtime=$(LC_ALL=C date '+%d %B %Y' -d $mtime)
	set -- $(sed '/ifmem/!d;s/.*ifmem //' $mnt/boot/isolinux/isolinux.cfg \
		| sed 's|^|echo |;s|\([0-9][0-9]*\) |$((\1/1024))M |g' | sh)
	umount $mnt 2> /dev/null || umount -l $mnt
	rmdir $mnt
		cat > description.html <<EOT
<p>This floppy set uses the BIOS instead of the linux driver. You can boot
SliTaz using unsupported floppy drives such as some PCMCIA devices.</p>
EOT
	if [ -z "$1" ]; then
		echo "Built on $mtime" > title
	else
		echo "Built on $mtime, needs up to ${1}b of RAM" > title
		n=0; x=1; while [ -n "$x" ]; do n=$(($n+2)); eval x=\$$n; done
		n=$((($n - 2) / 2))
		cat >> description.html <<EOT
<p>You can start with one of the $n following flavors:</p>

<ul>
EOT
		i=0
		while [ $i -lt $n ]; do
			eval flavor=\$$((($n - $i)*2))
			eval ram=\$$((($n - $i)*2 -1))
			cat >> description.html <<EOT
	<li><b>$flavor</b> needs ${ram}B of RAM and <span id="cnt$i">$(ls fd* | \
		awk "/fd$(($i+1))/{q=1}{if(!q)n++}END{print n}")</span> floppies:
		<tt>fd001.img</tt> to <tt>fd<span id="last$i">$(ls -r fd${i}* | sed 's|fd||;s|.img||;q')</span>.img</tt>.<br>
		$flavor provides $(while read f d; do 
			[ $f = $flavor ] && echo $d; done <<EOT
base the minimum SliTaz distribution subset in text mode
justx the minimum SliTaz distribution subset with X11 support
gtkonly the minimum SliTaz distribution subset with GTK+ support
core the default SliTaz distribution
EOT
	).</li>
EOT
			i=$(($i+1))
		done
		echo "</ul>" >> description.html
	fi
	cat >> description.html <<EOT

<p>Start your computer with <tt>fd001.img</tt>. It will show the kernel version
string and the kernel cmdline line. You can edit the cmdline. Most users can
just press Enter.</p>

<p>The floppy is then loaded into memory (one dot each 64KB) and you will be
prompted to insert the next floppy, <tt>fd002.img</tt>. And so on up to last
floppy.</p>
EOT
	[ -n "$1" ] && cat >> description.html <<EOT

<p>You will be prompted to insert extra floppies for the next flavors.
You can bypass this by using B to boot without loading extra floppies.</p>
EOT
	cd ..
	./mkindex.sh $name > index-$name.html
	[ -s $name/fd.img ] && rm $name/fd.img
	./mkmdsum.sh set $name > /dev/null
    fi
done <<EOT
rolling		iso/rolling/slitaz-rolling.iso
loram-rolling	iso/rolling/slitaz-rolling-loram.iso
next		iso/next/slitaz-next-*.iso
EOT
