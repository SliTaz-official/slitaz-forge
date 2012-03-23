<?php include("../head.php"); ?>
<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<?php echo $howto ?>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<?php echo $characteristics ?>
		<h4><?php system("../helper.sh --stats confirmed"); echo $stats ?></h4>
	</div>
</div>
		
<!-- Content top. -->
<div id="content_top">
<div class="top_left"></div>
<div class="top_right"></div>
</div>

<!-- Content -->
<div id="content">

<a name="pictures"></a>
<?php echo $pictures ?>
<a href="../img/IMAG0222.jpg"><img src="../img/IMAG0222small.jpg" alt="Wide" width="19%" /></a>
<a href="../img/IMAG0224.jpg"><img src="../img/IMAG0224small.jpg" alt="Close" width="19%" /></a>
<a href="../img/IMAG0111.jpg"><img src="../img/IMAG0111small.jpg" alt="Close" width="19%" /></a>
<a href="../img/IMAG0225.jpg"><img src="../img/IMAG0225small.jpg" alt="Closer" width="19%" /></a>
<a href="../img/IMAG0209.jpg"><img src="../img/IMAG0209small.jpg" alt="Detail" width="19%" /></a>
<p>
<?php echo $note ?>
</p>
	
<a name="form"></a>
<?php echo $form ?>

<script type="text/javascript">
<!--
function valid(f)
{
	if (f.email.value.indexOf("@",0) < 0) {
		alert("<?php echo $enter_email ?>")
		f.email.focus()
		return
	}
	if (f.name.value == "") {
		alert("<?php echo $enter_name ?>")
		f.name.focus()
		return
	}
	if (f.surname.value == "") {
		alert("<?php echo $enter_surname ?>")
		f.surname.focus()
		return
	}
	if (f.address.value == "") {
		alert("<?php echo $enter_address ?>")
		f.address.focus()
		return
	}
	if (f.city.value == "") {
		alert("<?php echo $enter_city ?>")
		f.city.focus()
		return
	}
	if (f.country.value == "") {
		alert("<?php echo $enter_country ?>")
		f.country.focus()
		return
	}
	if (true) {
		f.submit()
	}
}
//-->
</script>
<form method="post" action="../preorder.php">
<input type="hidden" name="lang" value="<?php echo $lang ?>" />
<table width="100%">
<tbody>
	<tr>
		<td align="right">&nbsp;<?php echo $name ?></td>
		<td><input type="text" name="name" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo $surname ?></td>
		<td><input type="text" name="surname" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo $email ?></td>
		<td><input type="text" name="email" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo $address ?></td>
		<td><input type="text" name="address" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo "$zip <br /> $city"; ?></td>
		<td><input type="text" name="zip" style="width: 80px;" />
		<input type="text" name="city" style="width: 363px;" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo $country ?></td>
		<td><input type="text" name="country" /></td>
	</tr>
	<tr>
		<td align="right"><?php echo $count ?></td>
		<td><input type="text" name="count" value="1" size="5" 
			onblur="if (this.value &lt; 1) {this.value='1'}" style="width: 80px;"/>
		<?php echo $size ?>
		<select name="size">
			<option><?php echo $shell ?></option>
			<option selected="selected">4 <?php echo $gb ?></option>
			<option>8 <?php echo $gb ?></option>
			<option>16 <?php echo $gb ?></option>
			<option>32 <?php echo $gb ?></option>
			<option>64 <?php echo $gb ?></option>
		</select>
		</td>
	</tr>
	<tr>
		<td align="right"><?php echo $soft ?></td>
		<td>
			<select name="soft">
				<option value="none"><?php echo $none ?></option>
				<option value="core"><?php echo $core ?></option>
				<option value="pkgs"><?php echo $pkgs ?></option>
				<option value="web"><?php echo $web ?></option>
				<option selected="selected" value="all"><?php echo $all ?></option>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right"><?php echo $comments ?></td>
		<td colspan="4"><textarea name="comments" rows="5" cols="70%"></textarea></td>
	</tr>
</tbody>
</table>
<input type="submit" name="register" value="<?php echo "$register" ?>" />
</form>

<!-- End of content with round corner -->
</div>

<?php include("../tail.php"); ?>
