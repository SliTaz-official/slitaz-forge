<?php if (!defined('APPLICATION')) exit();

// Conversations
$Configuration['Conversations']['Version'] = '2.0.16';

// Database
$Configuration['Database']['Name'] = 'slitaz_forum';
$Configuration['Database']['Host'] = 'localhost';
$Configuration['Database']['User'] = '***'; 
$Configuration['Database']['Password'] = '***';

// EnabledApplications
$Configuration['EnabledApplications']['Conversations'] = 'conversations';
$Configuration['EnabledApplications']['Skeleton'] = 'skeleton';
$Configuration['EnabledApplications']['Vanilla'] = 'vanilla';

// EnabledPlugins
$Configuration['EnabledPlugins']['HtmLawed'] = 'HtmLawed';
$Configuration['EnabledPlugins']['Gravatar'] = 'Gravatar';
$Configuration['EnabledPlugins']['FileUpload'] = 'FileUpload';
$Configuration['EnabledPlugins']['WhosOnline'] = 'WhosOnline';
$Configuration['EnabledPlugins']['Minify'] = 'Minify';
$Configuration['EnabledPlugins']['cleditor'] = 'cleditor';
$Configuration['EnabledPlugins']['Tagging'] = 'Tagging';

// Garden
$Configuration['Garden']['Title'] = 'SliTaz Forum';
$Configuration['Garden']['Cookie']['Salt'] = 'VS0GNTQ0ML';
$Configuration['Garden']['Cookie']['Domain'] = '';
$Configuration['Garden']['Version'] = '2.0.16';
$Configuration['Garden']['RewriteUrls'] = FALSE;
$Configuration['Garden']['CanProcessImages'] = TRUE;
$Configuration['Garden']['Installed'] = TRUE;
$Configuration['Garden']['Errors']['MasterView'] = 'error.master.php';
$Configuration['Garden']['Theme'] = 'slitaz-2';
$Configuration['Garden']['Messages']['Cache'] = 'a:1:{i:0;s:6:"[Base]";}';
$Configuration['Garden']['EditContentTimeout'] = '-1';
$Configuration['Garden']['RequiredUpdates'] = 'a:0:{}';
$Configuration['Garden']['UpdateCheckDate'] = 1292966704;
$Configuration['Garden']['Registration']['Method'] = 'Captcha';
$Configuration['Garden']['Registration']['CaptchaPrivateKey'] = '6Ld7zwgAAAAAAPo5ydoZaBn_8Wapn7nb0dypEf6M';
$Configuration['Garden']['Registration']['CaptchaPublicKey'] = '6Ld7zwgAAAAAALF1IeGgtdlEg1WYupYxd5ZqGIpg';
$Configuration['Garden']['Registration']['InviteExpiration'] = '-1 week';
$Configuration['Garden']['Registration']['InviteRoles'] = 'a:2:{i:8;s:1:"0";i:16;s:1:"0";}';

// Plugins
$Configuration['Plugins']['GettingStarted']['Dashboard'] = '1';
$Configuration['Plugins']['GettingStarted']['Categories'] = '1';
$Configuration['Plugins']['GettingStarted']['Plugins'] = '1';
$Configuration['Plugins']['GettingStarted']['Discussion'] = '1';
$Configuration['Plugins']['FileUpload']['Enabled'] = TRUE;
$Configuration['Plugins']['OpenID']['Enabled'] = FALSE;
$Configuration['Plugins']['Tagging']['Enabled'] = TRUE;

// Routes
$Configuration['Routes']['DefaultController'] = 'a:2:{i:0;s:10:"categories";i:1;s:8:"Internal";}';

// Vanilla
$Configuration['Vanilla']['Version'] = '2.0.16';
$Configuration['Vanilla']['Categories']['Use'] = TRUE;
$Configuration['Vanilla']['Discussions']['PerPage'] = '30';
$Configuration['Vanilla']['Comments']['AutoRefresh'] = '0';
$Configuration['Vanilla']['Comments']['PerPage'] = '50';
$Configuration['Vanilla']['Archive']['Date'] = '';
$Configuration['Vanilla']['Archive']['Exclude'] = FALSE;

// WhosOnline
$Configuration['WhosOnline']['Frequency'] = '20';
$Configuration['WhosOnline']['Location']['Show'] = 'every';
$Configuration['WhosOnline']['Hide'] = TRUE;

// Last edited by pankso (213.3.10.214)2010-12-21 16:25:04