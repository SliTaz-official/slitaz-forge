#!/bin/sh
#
# Small CGI example to display TazIRC Log Bot logs.
#
. /usr/lib/slitaz/httphelper

host="irc.freenode.net"
chan="slitaz"
logdir="log/$host/$chan"

# HTML 5 header
html_header() {
	cat lib/header.html | sed -e s!'%LOG%'!"$log"!g
}

# HTML 5 footer
html_footer() {
	if [ -f "lib/footer.html" ]; then
		cat $tiny/lib/footer.html
	else
		cat << EOT

<!-- End content -->
</div>

<div id="footer">&hearts;</div>

</body>
</html>
EOT
	fi
}

# Handle GET actions 
case " $(GET) " in
	*\ log\ *)
		# Display a daily log
		log="$(GET log)"
		header
		html_header
		echo "<h2>#${chan} $log</h2>"
		IFS="|"
		cat ${logdir}/${log}.log | while read time user text
		do
			cat << EOT
<div class="box">
<span class="date">[$time]</span> <span style="color: #0000FF;">$user:</span> $text
</div>
EOT
		done
		unset IFS
		html_footer ;;
	*\ webirc\ *)
		# Web IRC
		log="#slitaz"
		header
		html_header
		cat << EOT
<div style="text-align: center;">
	<iframe 
		src="http://webchat.freenode.net?channels=%23slitaz&uio=OT10cnVlJjExPTI0Ng32"
		width="647" height="400">
	</iframe>
</div>
EOT
		html_footer ;;
	*)
		# Info, log list and stats. 
		log="Logs"
		header
		html_header
		cat << EOT
<h2>Welcome to SliTaz IRC World!</h2>
<p>
	This service let you read online the SliTaz IRC support channel on
	Freenode and provide a <a href="?webirc">web IRC client</a>. On a
	SliTaz system you can also use a graphical or a text mode IRC client
	such as Xchat or TazIRC: 
</p>
<pre>
$ tazirc irc.freenode.net [nick] slitaz
</pre>

<h2>#${chan} $log</h2>

<pre>
EOT
		for log in $(ls $logdir/*.log | sort -r -n)
		do
			count="$(wc -l $log | awk '{print $1}')"
			log="$(basename ${log%.log})"
			echo "<a href='?log=$log'>$log</a> $count messages"
		done
		echo "</pre>"
		total=$(wc -l ${logdir}/*.log | tail -n 1 | awk '{print $1}')
		echo "<p>Total: $total messages</p>"
		unset IFS
		html_footer
esac

exit 0
