<!-- Start of footer and copy notice -->
<div id="copy">
<p>
Copyright &copy; <span class="year"></span> <a href="http://www.slitaz.org/">SliTaz</a> -
<a href="http://www.gnu.org/licenses/gpl.html">GNU General Public License</a>
</p>
<!-- End of copy -->
</div>

<!-- Bottom and logo's -->
<div id="bottom">
<p>
<a href="http://validator.w3.org/check?uri=referer"><img src="/static/xhtml10.png" alt="Valid XHTML 1.0" title="Code validé XHTML 1.0" style="width: 80px; height: 15px;" /></a>
</p>
<p>
	<!-- script type="text/javascript" src="/static/qrcode.js"></script -->
	<script type="text/javascript">
	function QRCodePNG(str, obj) {
		try {
			return QRCode.generatePNG(str, {ecclevel: 'H'});
		}
		catch (any) {
			var element = document.createElement("script");
			element.src = "/static/qrcode.js";
			element.type ="text/javascript"; 
			element.onload = function() {
				obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
			};
			document.body.appendChild(element);
		}
	}
	</script>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
		onclick="this.src = QRCodePNG(location.href, this)" />
</p>
</div>

</body>
</html>
