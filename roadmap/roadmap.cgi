#!/bin/sh
#
. /usr/lib/slitaz/httphelper
header

# Default to next stable release.
rel="5.0"
[ "$(GET release)" ] && rel="$(GET release)"
taskdir="releases/$rel"

# Show a task.
show_task() {
	cat << EOT
<pre>
Task      : $TASK
People    : $PEOPLE
EOT
	if [ "$WIKI" ]; then
		echo "Wiki page : <a href="$WIKI">$WIKI</a>"
	fi
	if [ "$DESC" ]; then
		cat << EOT

Desccription
------------
$DESC
EOT
	fi
	echo '</pre>'
}

# Usage: list_tasks STATUS
list_tasks() {
	echo "<h3>Tasks List: $1</h3>"
	count=0
	for pr in 1 2 3 4
	do
		for task in $(fgrep -H "$1" $taskdir/*.conf | cut -d ":" -f 1)
		do
			. $task
			if [ "$PRIORITY" == "$pr" ]; then
				show_task
			fi
		done
	done
	[ "$1" == "TODO" ] && [ "$todo" == "0" ] && echo "All done."
	[ "$1" == "DONE" ] && [ "$done" == "0" ] && echo "Nothing done."
}

# xHTML header.
cat header.html

case " $(GET) " in
	*\ README\ *)
		echo '<h2>README</h2>'
		echo '<pre>'
		cat README
		echo '</pre>' ;;
	*)
		# Get the tasks done and todo
		tasks=$(ls -1 $taskdir/*.conf | wc -l)
		done=$(fgrep "DONE" $taskdir/*.conf | wc -l)
		todo=$(fgrep "TODO" $taskdir/*.conf | wc -l)
		pct=0
		[ $tasks -gt 0 ] && pct=$(( ($done * 100) / $tasks ))
		cat << EOT
<h2>Release: $rel</h2>

<p>
	Tasks: $tasks in total - $done finised - $todo todo
</p>
<div class="pctbar">
	<div class="pct" style="width: ${pct}%;">${pct}%</div>
</div>
<p>
	Tasks lists are order by priority. Please read the <a href="?README">README</a>
	for more information about SliTaz Roadmap web interface and Hg repo.
</p>
EOT
		cat $taskdir/$release/goals.html
		list_tasks TODO
		list_tasks DONE ;;
esac

# Close xHTML page
cat << EOT
</div>

<div id="footer">
	<a href="http://www.slitaz.org/">SliTaz Website</a> - Roadmap:
	<a href="?release=4.0">4.0</a>
</div>

</body>
</html>
EOT

exit 0
