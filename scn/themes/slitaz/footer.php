		</div> <!-- #container -->

		<?php do_action( 'bp_after_container' ) ?>
		<?php do_action( 'bp_before_footer' ) ?>

		<script type="text/javascript" src="/wp-content/themes/custom-community/qrcode.js"></script>

		<div id="footer">
		<p>Copyright &copy; <?php echo date('Y'); ?>
				<a href="http://www.slitaz.org">SliTaz</a> - SCN is
				proudly powered by <a href="http://wordpress.org">WordPress</a>
				and <a href="http://buddypress.org">BuddyPress</a>
			</p>
			<p>
				<img src="#" alt="SliTaz @" onmouseover="this.title = location.href"
				 onclick="this.src = QRCode.generatePNG(location.href, {ecclevel: 'H'})" />
				<a href="http://twitter.com/slitaz">Twitter</a>
				<a href="http://www.facebook.com/slitaz">Facebook</a>
				<a href="http://distrowatch.com/slitaz">Distrowatch</a>
				<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
				<a href="http://flattr.com/profile/slitaz">Flattr</a>
			</p>

			<?php do_action( 'bp_footer' ) ?>
		</div><!-- #footer -->

		<?php do_action( 'bp_after_footer' ) ?>

		<?php wp_footer(); ?>

	</body>

</html>
