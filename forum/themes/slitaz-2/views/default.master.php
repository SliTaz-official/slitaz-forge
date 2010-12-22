<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<?php $this->RenderAsset('Head'); ?>
	</head>
	<body id="<?php echo $BodyIdentifier; ?>" class="<?php echo $this->CssClass; ?>">
		<div id="Wrapper">
			<div id="Main">
				<div id="ContentHolder">
					<div id="Content">
						<?php $this->RenderAsset('Content'); ?>
					</div>
				</div>
				<div id="PanelHolder">
					<div id="Panel">
					
					<div class="Box">
						<h4>Navigation</h4>

					<?php
				  $Session = Gdn::Session();
					if ($this->Menu) {
						$this->Menu->AddLink('Dashboard', T('Dashboard'), '/dashboard/settings', array('Garden.Settings.Manage'));
						// $this->Menu->AddLink('Dashboard', T('Users'), '/user/browse', array('Garden.Users.Add', 'Garden.Users.Edit', 'Garden.Users.Delete'));
						$this->Menu->AddLink('Activity', T('Activity'), '/activity');
					 $Authenticator = Gdn::Authenticator();
						if ($Session->IsValid()) {
							$Name = $Session->User->Name;
							$CountNotifications = $Session->User->CountNotifications;
							if (is_numeric($CountNotifications) && $CountNotifications > 0)
								$Name .= ' <span>'.$CountNotifications.'</span>';
								
							$this->Menu->AddLink('User', "Profile ($Name)", '/profile/{UserID}/{Username}', array('Garden.SignIn.Allow'), array('class' => 'UserNotifications'));
							$this->Menu->AddLink('SignOut', T('Sign Out'), $Authenticator->SignOutUrl(), FALSE, array('class' => 'NonTab SignOut'));
						} else {
							$Attribs = array();
							if (C('Garden.SignIn.Popup') && strpos(Gdn::Request()->Url(), 'entry') === FALSE)
								$Attribs['class'] = 'SignInPopup';
								
							$this->Menu->AddLink('Entry', T('Sign In'), $Authenticator->SignInUrl($this->SelfUrl), FALSE, array('class' => 'NonTab'), $Attribs);
						}
						echo $this->Menu->ToString();
					}
				?>
					</div>
					<?php $this->RenderAsset('Panel'); ?>
					</div>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
			
			<div id="Header">
			
			<a href="http://forum.slitaz.org/"><img id="logo"
			src="themes/slitaz/images/logo.png" title="www.slitaz.org" alt="www.slitaz.org"
			style="border: 0px solid ; width: 200px; height: 74px;" /></a>
			<p id="titre">#!/Support/Forum</p>
				
			</div>
			
			<div id="Nav">
				
				<div id="Search">
					<?php
						$Form = Gdn::Factory('Form');
						$Form->InputPrefix = '';
						echo 
							$Form->Open(array('action' => Url('/search'), 'method' => 'get')),
							$Form->TextBox('Search'),
							$Form->Button('Search', array('Name' => '')),
							$Form->Close();
					?>
				</div>
			</div>
			
			<div id="Footer">
				Copyright &copy; 2010 <a href="http://www.slitaz.org/">SliTaz</a> -
				<a href="http://vanillaforums.org">Powered by Vanilla</a>
			</div>
		</div>

		<?php $this->FireEvent('AfterBody'); ?>
	</body>
</html>
