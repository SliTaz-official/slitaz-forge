cat << _EOT_

<div class="summary">
$(eval_gettext "\$PKGS packages in \$SLITAZ_VERSION database")
</div>

<!-- End of content -->
</div>

<!-- Footer -->
<div id="footer">
$(gettext "SliTaz Packages")
<p>
	<script type="text/javascript">
		function QRCodePNG(str, obj) {
			try {
				obj.height = obj.width += 300;
				return QRCode.generatePNG(str, {ecclevel: 'H'});
			}
			catch (any) {
				var element = document.createElement("script");
				element.src = "http://mirror.slitaz.org/static/qrcode.js";
				element.type ="text/javascript";
				element.onload = function() {
					obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
				};
				document.body.appendChild(element);
			}
		}	
	</script>
	<img src="http://mirror.slitaz.org/static/qr.png" alt="#" 
	     onmouseover= "this.title = location.href"
	     onclick="this.src = QRCodePNG(location.href, this)" />
</p>
</div>

<script type="text/javascript">
	var q=document.getElementById('query');
	var v=q.value; q.value=''; q.focus(); q.value=v;
	document.getElementById('ticker').style.visibility='hidden';
</script>
</body>
</html>
_EOT_
