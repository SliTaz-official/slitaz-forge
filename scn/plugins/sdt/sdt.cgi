#!/bin/sh
#
# TinyCM Plugin - SliTaz Distro Tracker
#
# sdt.cgi: SliTaz Distros over the world. We don't track users
# info, no mail or IP but the localization. The goal of Sdt is to help 
# show where SliTaz OS's are in the world. DB is in the flat file: 
# sdt.txt & using | as separator for easy parsing.
#

sdtdb="$tiny/$content/sdt/sdt.txt"

sdt_summary() {
	cat << EOT
<pre>
DB file    : <a href="content/sdt/sdt.txt">sdt.txt</a>
DB size    : $(du -sh $sdtdb | cut -d "	" -f 1)
Distro     : $(wc -l $sdtdb | cut -d " " -f 1)
</pre>
EOT
}

sdt_table() {
	cat << EOT
<table>
	<thead>
		<td>$(gettext "Date")</td>
		<td>$(gettext "User")</td>
		<td>$(gettext "Country")</td>
		<td>$(gettext "Release")</td>
		<td>$(gettext "Kernel")</td>
		<td>$(gettext "Mode")</td>
	</thead>
EOT
	IFS="|"
	cat ${sdtdb} | while read date user country release kernel mode;
	do
		cat << EOT
	<tr>
		<td>$date</td>
		<td>$user</td>
		<td>$country</td>
		<td>$release</td>
		<td>$kernel</td>
		<td>$mode</td>
	</tr>
EOT
	done && unset IFS
	echo "</table>"
}

sdt_check_ua() {
	if ! echo "$HTTP_USER_AGENT" | fgrep -q "SliTaz/SDT"; then
		echo "Only SDT clients are accepted" && exit 1
	fi
}

case " $(GET sdt) " in
	*\ add\ *)
		sdt_check_ua
		date="$(date +%Y%m%d)"
		user=$(GET user)
		release=$(GET release)
		kernel=$(GET kernel)
		mode=$(GET mode)
		country=$(GET country)
		message=$(GET message)
		cat << EOT
SliTaz Distro Tracker
--------------------------------------------------------------------------------
Date       : ${date}
User       : ${user}
Country    : ${country}
Release    : ${release}
Kernel     : ${kernel}
Mode       : ${mode}
--------------------------------------------------------------------------------
EOT
		# Add to DB
		echo "$date|$user|$country|$release|$kernel|$mode" >> ${sdtdb}
		echo "Distro added to the database. Thank you :-)"; echo
		exit 0 ;;
	
	*\ geoloc\ *) 
		# Show IP and country
		header "Content-Type: text/plain"
		echo "$REMOTE_ADDR"
		exit 0 ;;
	
	*\ country\ *) 
		# Show distros by country
		;;
	
	*\ sdt\ *)
		d="SliTaz Distro Tracker"
		header
		html_header
		user_box
		cat << EOT
<h2>$d</h2>
<p>
	$(gettext "Add your SliTaz distro to the database. Open a terminal and execute:") 
	<b>sdt send [username]</b>
<p>
EOT
		sdt_summary
		echo "<h3>Distros table</h3>"
		echo "<pre>"
		sdt_table
		echo "</pre>"
		html_footer
		exit 0 ;;
	
	*\ raw\ *)
		# Plain text stats
		header "Content-Type: text/plain"
		cat << EOT
Server time      : $(date)
Database size    : $(du -sh $sdtdb | cut -d "	" -f 1)
Distro tracked   : $(wc -l $sdtdb | cut -d " " -f 1)
EOT
		exit 0 ;;
esac
