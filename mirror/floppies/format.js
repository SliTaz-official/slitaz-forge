window.URL = window.URL || window.webkitURL;
function download(ref, range, name) {
	var xhr = new XMLHttpRequest();
      
	xhr.open('GET', ref, true);
	xhr.setRequestHeader("Range", "bytes="+range);
	xhr.responseType = 'blob';
	xhr.onload = function () {
	    var a = document.createElement('a'), file;
	    file = new Blob([xhr.response], { type : 'application/octet-stream' });
	    a.href = window.URL.createObjectURL(file);
	    a.download = name;
	    a.click();
	};
	xhr.send();
}

function format(size) {
	var max = sets[sets.length-1];
	var cols = Math.floor(Math.sqrt(max/size)+2);
	var lines = Math.floor(((max/size)+1)/cols+1);
	var e = document.getElementById('floppies');
	var s, i, j, ofs, fd, fds, curset;
	for (i = 0, ofs = 0, curset = 0, fd = 1, s = ""; i < lines; i++) {
		s += "<tr>";
		for (j = 0; j < cols; j++) {
			fds = ""+fd; if (fd < 100) fds = "0"+fds; if (fd < 10) fds = "0"+fds;
			s += "<td>";
			if (ofs < max) {
				s += "<a href=\"javascript:download('"+dir+"/fd.img', '"+ofs+"-";
				ofs = Number.parseInt(ofs)+Number.parseInt(size);
				s += (ofs-1)+"', 'fd"+fds+".img')\">fd"+fds+"</a>";
				if (ofs >= sets[curset]) {
					curset++;
					fd = (Math.floor(fd/100)+1)*100;
				} else fd++;
			}
			if (i == lines-1 && j == cols-1) {
				s += "<a href=\""+dir+"/"+size+"/md5sum\">md5</a>"
			}
			s += "</td>";
		}
		s += "</tr>";
	}
	e.innerHTML = s;
	for (i = 0, ofs = 0, curset = 0, fd = 0; ofs < max;) {
		i++; fd++;
		ofs = Number.parseInt(ofs)+Number.parseInt(size);
		if (ofs >= sets[curset]) {
			fds = ""+fd; if (fd < 100) fds = "0"+fds; if (fd < 10) fds = "0"+fds;
			e = document.getElementById('cnt'+curset);
			if (e) e.innerHTML = i;
			e = document.getElementById('last'+curset);
			if (e) e.innerHTML = fds;
			curset++;
			fd = (Math.floor(fd/100)+1)*100-1;
		}
	}
}

var e = document.getElementById('format');
try {
	var dummy = new Blob();
	e.innerHTML="<select onChange='format(this.value)' style='background: #666; color: #FFF;' title='80 tracks 2 sides floppy list'>" +
		"<option value='737280' title='/dev/fd0u720 3½ DD (2,16)'>720K</option>" +
		"<option value='819200' title='/dev/fd0u800 3½ DD (2,120)'>800K</option>" +
		"<option value='1228800' title='/dev/fd0h1200 5¼ (2,8)'>1.2MB</option>" +
		"<option value='1474560' title='/dev/fd0u1440 3½ HD (2,28) or /dev/fd0h1440 5¼ (2,40)' selected>1.44MB</option>" +
		"<option value='1638400' title='/dev/fd0u1600 3½ HD (2,124) or /dev/fd0h1600 5¼ (2,92)'>1.60MB</option>" +
		"<option value='1720320' title='/dev/fd0u1680 3½ HD (2,44)'>1.68MB</option>" +
		"<option value='1966080' title='/dev/fd0u1920 3½ HD (2,100)'>1.92MB</option>" +
		"<option value='2949120' title='/dev/fd0u2880 3½ ED (2,32)'>2.88MB</option>" +
		"<option value='3932160' title='/dev/fd0u3840 3½ ED (2,112)'>3.84MB</option>" +
		"</select>";
}
catch (err) {
	e.innerHTML="1.44MB"; 
}
