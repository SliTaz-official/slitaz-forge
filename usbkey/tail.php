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
	<img src="#" id="qrcodeimg" alt="#" width="60" height="60"
	     onclick= "this.width = this.height = 300;" />
	<script type="text/javascript" src="/static/qrcode.js"></script>
	<script type="text/javascript">
		document.getElementById('qrcodeimg').src =
			QRCode.generatePNG(location.href, {ecclevel: 'H'});
	</script>
</p>
</div>

</body>
</html>
