cat << _EOT_

<div class="summary">
$(eval_ngettext "\$PKGS package" "\$PKGS packages" $PKGS)
$(eval_ngettext "and \$FILES file in \$SLITAZ_VERSION database" "and \$FILES files in \$SLITAZ_VERSION database" $FILES)
</div>

<!-- End of content -->
</div>

<!-- Footer -->
<div id="footer">
$(gettext "SliTaz Packages")
<p>
	<img src="#" id="qrcodeimg" alt="#" width="60" height="60"
	     onclick= "this.width = this.height = 300;" />
	<script type="text/javascript" src="http://mirror.slitaz.org/static/qrcode.js"></script>
	<script type="text/javascript">
		document.getElementById('qrcodeimg').src =
			QRCode.generatePNG(location.href, {ecclevel: 'H'});
	</script>
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
