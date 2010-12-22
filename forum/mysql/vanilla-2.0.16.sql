-- MySQL dump 10.11
--
-- Host: localhost    Database: slitaz_forum
-- ------------------------------------------------------
-- Server version	5.0.32-Debian_7etch12-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `GDN_Activity`
--

DROP TABLE IF EXISTS `GDN_Activity`;
CREATE TABLE `GDN_Activity` (
  `ActivityID` int(11) NOT NULL auto_increment,
  `CommentActivityID` int(11) default NULL,
  `ActivityTypeID` int(11) NOT NULL,
  `ActivityUserID` int(11) default NULL,
  `RegardingUserID` int(11) default NULL,
  `Story` text collate utf8_unicode_ci,
  `Route` varchar(255) collate utf8_unicode_ci default NULL,
  `CountComments` int(11) NOT NULL default '0',
  `InsertUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  PRIMARY KEY  (`ActivityID`),
  KEY `FK_Activity_CommentActivityID` (`CommentActivityID`),
  KEY `FK_Activity_ActivityUserID` (`ActivityUserID`),
  KEY `FK_Activity_InsertUserID` (`InsertUserID`)
) ENGINE=MyISAM AUTO_INCREMENT=11612 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_ActivityType`
--

DROP TABLE IF EXISTS `GDN_ActivityType`;
CREATE TABLE `GDN_ActivityType` (
  `ActivityTypeID` int(11) NOT NULL auto_increment,
  `Name` varchar(20) collate utf8_unicode_ci NOT NULL,
  `AllowComments` tinyint(1) NOT NULL default '0',
  `ShowIcon` tinyint(1) NOT NULL default '0',
  `ProfileHeadline` varchar(255) collate utf8_unicode_ci NOT NULL,
  `FullHeadline` varchar(255) collate utf8_unicode_ci NOT NULL,
  `RouteCode` varchar(255) collate utf8_unicode_ci default NULL,
  `Notify` tinyint(1) NOT NULL default '0',
  `Public` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`ActivityTypeID`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Category`
--

DROP TABLE IF EXISTS `GDN_Category`;
CREATE TABLE `GDN_Category` (
  `CategoryID` int(11) NOT NULL auto_increment,
  `ParentCategoryID` int(11) default NULL,
  `CountDiscussions` int(11) NOT NULL default '0',
  `AllowDiscussions` tinyint(4) NOT NULL default '1',
  `Name` varchar(30) collate utf8_unicode_ci NOT NULL,
  `Description` varchar(250) collate utf8_unicode_ci default NULL,
  `Sort` int(11) default NULL,
  `InsertUserID` int(11) NOT NULL,
  `UpdateUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  `DateUpdated` datetime NOT NULL,
  `UrlCode` varchar(30) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`CategoryID`),
  KEY `FK_Category_InsertUserID` (`InsertUserID`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Comment`
--

DROP TABLE IF EXISTS `GDN_Comment`;
CREATE TABLE `GDN_Comment` (
  `CommentID` int(11) NOT NULL auto_increment,
  `DiscussionID` int(11) NOT NULL,
  `InsertUserID` int(11) default NULL,
  `UpdateUserID` int(11) default NULL,
  `DeleteUserID` int(11) default NULL,
  `Body` text collate utf8_unicode_ci NOT NULL,
  `Format` varchar(20) collate utf8_unicode_ci default NULL,
  `DateInserted` datetime default NULL,
  `DateDeleted` datetime default NULL,
  `DateUpdated` datetime default NULL,
  `Flag` tinyint(4) NOT NULL default '0',
  `ReplyCommentID` int(11) default NULL,
  `CountReplies` int(11) NOT NULL default '0',
  `Score` float default NULL,
  `Attributes` text collate utf8_unicode_ci,
  PRIMARY KEY  (`CommentID`),
  KEY `FK_Comment_DiscussionID` (`DiscussionID`),
  KEY `FK_Comment_InsertUserID` (`InsertUserID`),
  KEY `FK_Comment_ReplyCommentID` (`ReplyCommentID`),
  KEY `FK_Comment_DateInserted` (`DateInserted`),
  FULLTEXT KEY `TX_Comment` (`Body`)
) ENGINE=MyISAM AUTO_INCREMENT=10904 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_CommentWatch`
--

DROP TABLE IF EXISTS `GDN_CommentWatch`;
CREATE TABLE `GDN_CommentWatch` (
  `UserID` int(11) NOT NULL,
  `CommentID` int(11) NOT NULL,
  `DateLastViewed` datetime NOT NULL,
  `CountReplies` int(11) NOT NULL default '0',
  PRIMARY KEY  (`UserID`,`CommentID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Conversation`
--

DROP TABLE IF EXISTS `GDN_Conversation`;
CREATE TABLE `GDN_Conversation` (
  `ConversationID` int(11) NOT NULL auto_increment,
  `Contributors` varchar(255) collate utf8_unicode_ci NOT NULL,
  `FirstMessageID` int(11) default NULL,
  `InsertUserID` int(11) NOT NULL,
  `DateInserted` datetime default NULL,
  `UpdateUserID` int(11) NOT NULL,
  `DateUpdated` datetime NOT NULL,
  `CountMessages` int(11) NOT NULL,
  `LastMessageID` int(11) NOT NULL,
  PRIMARY KEY  (`ConversationID`),
  KEY `FK_Conversation_FirstMessageID` (`FirstMessageID`),
  KEY `FK_Conversation_InsertUserID` (`InsertUserID`),
  KEY `FK_Conversation_UpdateUserID` (`UpdateUserID`),
  KEY `FK_Conversation_DateInserted` (`DateInserted`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_ConversationMessage`
--

DROP TABLE IF EXISTS `GDN_ConversationMessage`;
CREATE TABLE `GDN_ConversationMessage` (
  `MessageID` int(11) NOT NULL auto_increment,
  `ConversationID` int(11) NOT NULL,
  `Body` text collate utf8_unicode_ci NOT NULL,
  `Format` varchar(20) collate utf8_unicode_ci default NULL,
  `InsertUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  PRIMARY KEY  (`MessageID`),
  KEY `FK_ConversationMessage_InsertUserID` (`InsertUserID`),
  KEY `FK_ConversationMessage_DateInserted` (`DateInserted`),
  KEY `FK_ConversationMessage_ConversationID` (`ConversationID`)
) ENGINE=MyISAM AUTO_INCREMENT=96 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Discussion`
--

DROP TABLE IF EXISTS `GDN_Discussion`;
CREATE TABLE `GDN_Discussion` (
  `DiscussionID` int(11) NOT NULL auto_increment,
  `CategoryID` int(11) NOT NULL,
  `InsertUserID` int(11) NOT NULL,
  `UpdateUserID` int(11) NOT NULL,
  `LastCommentID` int(11) default NULL,
  `Name` varchar(100) collate utf8_unicode_ci NOT NULL,
  `CountComments` int(11) NOT NULL default '1',
  `CountBookmarks` int(11) default NULL,
  `CountViews` int(11) NOT NULL default '1',
  `Closed` tinyint(1) NOT NULL default '0',
  `Announce` tinyint(1) NOT NULL default '0',
  `Sink` tinyint(1) NOT NULL default '0',
  `DateInserted` datetime default NULL,
  `DateUpdated` datetime NOT NULL,
  `DateLastComment` datetime default NULL,
  `Attributes` text collate utf8_unicode_ci,
  `CountReplies` int(11) NOT NULL default '0',
  `Body` text collate utf8_unicode_ci NOT NULL,
  `Format` varchar(20) collate utf8_unicode_ci default NULL,
  `Tags` varchar(255) collate utf8_unicode_ci default NULL,
  `LastCommentUserID` int(11) default NULL,
  `Score` float default NULL,
  PRIMARY KEY  (`DiscussionID`),
  KEY `FK_Discussion_CategoryID` (`CategoryID`),
  KEY `FK_Discussion_InsertUserID` (`InsertUserID`),
  KEY `FK_Discussion_LastCommentID` (`LastCommentID`),
  KEY `IX_Discussion_DateLastComment` (`DateLastComment`),
  FULLTEXT KEY `TX_Discussion` (`Name`,`Body`)
) ENGINE=MyISAM AUTO_INCREMENT=2286 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Draft`
--

DROP TABLE IF EXISTS `GDN_Draft`;
CREATE TABLE `GDN_Draft` (
  `DraftID` int(11) NOT NULL auto_increment,
  `DiscussionID` int(11) default NULL,
  `CategoryID` int(11) default NULL,
  `InsertUserID` int(11) NOT NULL,
  `UpdateUserID` int(11) NOT NULL,
  `Name` varchar(100) collate utf8_unicode_ci default NULL,
  `Tags` varchar(255) collate utf8_unicode_ci default NULL,
  `Closed` tinyint(1) NOT NULL default '0',
  `Announce` tinyint(1) NOT NULL default '0',
  `Sink` tinyint(1) NOT NULL default '0',
  `Body` text collate utf8_unicode_ci NOT NULL,
  `Format` varchar(20) collate utf8_unicode_ci default NULL,
  `DateInserted` datetime NOT NULL,
  `DateUpdated` datetime default NULL,
  PRIMARY KEY  (`DraftID`),
  KEY `FK_Draft_DiscussionID` (`DiscussionID`),
  KEY `FK_Draft_CategoryID` (`CategoryID`),
  KEY `FK_Draft_InsertUserID` (`InsertUserID`)
) ENGINE=MyISAM AUTO_INCREMENT=9605 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Invitation`
--

DROP TABLE IF EXISTS `GDN_Invitation`;
CREATE TABLE `GDN_Invitation` (
  `InvitationID` int(11) NOT NULL auto_increment,
  `Email` varchar(200) collate utf8_unicode_ci NOT NULL,
  `Code` varchar(50) collate utf8_unicode_ci NOT NULL,
  `InsertUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  `AcceptedUserID` int(11) default NULL,
  PRIMARY KEY  (`InvitationID`),
  KEY `FK_Invitation_InsertUserID` (`InsertUserID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Media`
--

DROP TABLE IF EXISTS `GDN_Media`;
CREATE TABLE `GDN_Media` (
  `MediaID` int(11) NOT NULL auto_increment,
  `Name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `Type` varchar(128) collate utf8_unicode_ci NOT NULL,
  `Size` int(11) NOT NULL,
  `StorageMethod` varchar(24) collate utf8_unicode_ci NOT NULL,
  `Path` varchar(255) collate utf8_unicode_ci NOT NULL,
  `InsertUserID` int(11) NOT NULL,
  `DateInserted` datetime NOT NULL,
  `ForeignID` int(11) default NULL,
  `ForeignTable` varchar(24) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`MediaID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Message`
--

DROP TABLE IF EXISTS `GDN_Message`;
CREATE TABLE `GDN_Message` (
  `MessageID` int(11) NOT NULL auto_increment,
  `Content` text collate utf8_unicode_ci NOT NULL,
  `Format` varchar(20) collate utf8_unicode_ci default NULL,
  `AllowDismiss` tinyint(1) NOT NULL default '1',
  `Enabled` tinyint(1) NOT NULL default '1',
  `Application` varchar(255) collate utf8_unicode_ci default NULL,
  `Controller` varchar(255) collate utf8_unicode_ci default NULL,
  `Method` varchar(255) collate utf8_unicode_ci default NULL,
  `AssetTarget` varchar(20) collate utf8_unicode_ci default NULL,
  `CssClass` varchar(20) collate utf8_unicode_ci default NULL,
  `Sort` int(11) default NULL,
  PRIMARY KEY  (`MessageID`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Permission`
--

DROP TABLE IF EXISTS `GDN_Permission`;
CREATE TABLE `GDN_Permission` (
  `PermissionID` int(11) NOT NULL auto_increment,
  `RoleID` int(11) NOT NULL default '0',
  `JunctionTable` varchar(100) collate utf8_unicode_ci default NULL,
  `JunctionColumn` varchar(100) collate utf8_unicode_ci default NULL,
  `JunctionID` int(11) default NULL,
  `Garden.Email.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Settings.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Routes.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Messages.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Applications.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Plugins.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Themes.Manage` tinyint(4) NOT NULL default '0',
  `Garden.SignIn.Allow` tinyint(4) NOT NULL default '0',
  `Garden.Registration.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Applicants.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Roles.Manage` tinyint(4) NOT NULL default '0',
  `Garden.Users.Add` tinyint(4) NOT NULL default '0',
  `Garden.Users.Edit` tinyint(4) NOT NULL default '0',
  `Garden.Users.Delete` tinyint(4) NOT NULL default '0',
  `Garden.Users.Approve` tinyint(4) NOT NULL default '0',
  `Garden.Activity.Delete` tinyint(4) NOT NULL default '0',
  `Garden.Activity.View` tinyint(4) NOT NULL default '0',
  `Garden.Profiles.View` tinyint(4) NOT NULL default '0',
  `Vanilla.Settings.Manage` tinyint(4) NOT NULL default '0',
  `Vanilla.Categories.Manage` tinyint(4) NOT NULL default '0',
  `Vanilla.Spam.Manage` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.View` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Add` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Edit` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Announce` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Sink` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Close` tinyint(4) NOT NULL default '0',
  `Vanilla.Discussions.Delete` tinyint(4) NOT NULL default '0',
  `Vanilla.Comments.Add` tinyint(4) NOT NULL default '0',
  `Vanilla.Comments.Edit` tinyint(4) NOT NULL default '0',
  `Vanilla.Comments.Delete` tinyint(4) NOT NULL default '0',
  `Plugins.Debugger.View` tinyint(4) NOT NULL default '0',
  `Plugins.Debugger.Manage` tinyint(4) NOT NULL default '0',
  `Plugins.Attachments.Upload.Allow` tinyint(4) NOT NULL default '0',
  `Plugins.Attachments.Download.Allow` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`PermissionID`),
  KEY `FK_Permission_RoleID` (`RoleID`)
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Photo`
--

DROP TABLE IF EXISTS `GDN_Photo`;
CREATE TABLE `GDN_Photo` (
  `PhotoID` int(11) NOT NULL auto_increment,
  `Name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `InsertUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  PRIMARY KEY  (`PhotoID`),
  KEY `FK_Photo_InsertUserID` (`InsertUserID`)
) ENGINE=MyISAM AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Role`
--

DROP TABLE IF EXISTS `GDN_Role`;
CREATE TABLE `GDN_Role` (
  `RoleID` int(11) NOT NULL auto_increment,
  `Name` varchar(100) collate utf8_unicode_ci NOT NULL,
  `Description` varchar(500) collate utf8_unicode_ci default NULL,
  `Sort` int(11) default NULL,
  `Deletable` tinyint(1) NOT NULL default '1',
  `CanSession` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`RoleID`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_SearchDocument`
--

DROP TABLE IF EXISTS `GDN_SearchDocument`;
CREATE TABLE `GDN_SearchDocument` (
  `DocumentID` int(11) NOT NULL auto_increment,
  `TableName` varchar(50) collate utf8_unicode_ci NOT NULL,
  `PrimaryID` int(11) NOT NULL,
  `PermissionJunctionID` int(11) default NULL,
  `Title` varchar(100) collate utf8_unicode_ci NOT NULL,
  `Summary` varchar(200) collate utf8_unicode_ci NOT NULL,
  `Url` varchar(255) collate utf8_unicode_ci NOT NULL,
  `InsertUserID` int(11) NOT NULL,
  `DateInserted` datetime NOT NULL,
  PRIMARY KEY  (`DocumentID`)
) ENGINE=MyISAM AUTO_INCREMENT=5633 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_SearchKeyword`
--

DROP TABLE IF EXISTS `GDN_SearchKeyword`;
CREATE TABLE `GDN_SearchKeyword` (
  `KeywordID` int(11) NOT NULL auto_increment,
  `Keyword` varchar(50) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`KeywordID`),
  KEY `FK_SearchKeyword_Keyword` (`Keyword`)
) ENGINE=MyISAM AUTO_INCREMENT=26642 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_SearchKeywordDocument`
--

DROP TABLE IF EXISTS `GDN_SearchKeywordDocument`;
CREATE TABLE `GDN_SearchKeywordDocument` (
  `KeywordID` int(11) NOT NULL,
  `DocumentID` int(11) NOT NULL,
  PRIMARY KEY  (`KeywordID`,`DocumentID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_TableType`
--

DROP TABLE IF EXISTS `GDN_TableType`;
CREATE TABLE `GDN_TableType` (
  `TableName` varchar(50) collate utf8_unicode_ci NOT NULL,
  `PermissionTableName` varchar(50) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`TableName`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Tag`
--

DROP TABLE IF EXISTS `GDN_Tag`;
CREATE TABLE `GDN_Tag` (
  `CountDiscussions` int(11) NOT NULL default '0',
  `TagID` int(11) NOT NULL auto_increment,
  `Name` varchar(255) collate utf8_unicode_ci NOT NULL default 'unique',
  `InsertUserID` int(11) default NULL,
  `DateInserted` datetime NOT NULL,
  PRIMARY KEY  (`TagID`),
  KEY `FK_Tag_InsertUserID` (`InsertUserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_TagDiscussion`
--

DROP TABLE IF EXISTS `GDN_TagDiscussion`;
CREATE TABLE `GDN_TagDiscussion` (
  `TagID` int(11) NOT NULL,
  `DiscussionID` int(11) NOT NULL,
  PRIMARY KEY  (`TagID`,`DiscussionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_User`
--

DROP TABLE IF EXISTS `GDN_User`;
CREATE TABLE `GDN_User` (
  `UserID` int(11) NOT NULL auto_increment,
  `Name` varchar(20) collate utf8_unicode_ci NOT NULL,
  `Password` varbinary(50) NOT NULL,
  `About` text collate utf8_unicode_ci,
  `Email` varchar(200) collate utf8_unicode_ci NOT NULL,
  `ShowEmail` tinyint(1) NOT NULL default '0',
  `Gender` enum('m','f') collate utf8_unicode_ci NOT NULL default 'm',
  `CountVisits` int(11) NOT NULL default '0',
  `CountInvitations` int(11) NOT NULL default '0',
  `CountNotifications` int(11) default NULL,
  `InviteUserID` int(11) default NULL,
  `DiscoveryText` text collate utf8_unicode_ci,
  `Preferences` text collate utf8_unicode_ci,
  `Permissions` text collate utf8_unicode_ci,
  `Attributes` text collate utf8_unicode_ci,
  `DateSetInvitations` datetime default NULL,
  `DateOfBirth` datetime default NULL,
  `DateFirstVisit` datetime default NULL,
  `DateLastActive` datetime default NULL,
  `DateInserted` datetime NOT NULL,
  `DateUpdated` datetime default NULL,
  `HourOffset` int(11) NOT NULL default '0',
  `CacheRoleID` int(11) default NULL,
  `Admin` tinyint(1) NOT NULL default '0',
  `CountDiscussions` int(11) default NULL,
  `CountUnreadDiscussions` int(11) default NULL,
  `CountComments` int(11) default NULL,
  `CountDrafts` int(11) default NULL,
  `CountBookmarks` int(11) default NULL,
  `CountUnreadConversations` int(11) default NULL,
  `HashMethod` varchar(10) collate utf8_unicode_ci default NULL,
  `Photo` varchar(255) collate utf8_unicode_ci default NULL,
  `Score` float default NULL,
  `Deleted` tinyint(1) NOT NULL default '0',
  `DateAllViewed` datetime default NULL,
  PRIMARY KEY  (`UserID`),
  KEY `FK_User_Name` (`Name`)
) ENGINE=MyISAM AUTO_INCREMENT=1893 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserAuthentication`
--

DROP TABLE IF EXISTS `GDN_UserAuthentication`;
CREATE TABLE `GDN_UserAuthentication` (
  `UniqueID` varchar(30) collate utf8_unicode_ci NOT NULL,
  `UserID` int(11) NOT NULL,
  `ForeignUserKey` varchar(255) collate utf8_unicode_ci NOT NULL,
  `ProviderKey` varchar(64) collate utf8_unicode_ci NOT NULL,
  PRIMARY KEY  (`ForeignUserKey`,`ProviderKey`),
  KEY `FK_UserAuthentication_UserID` (`UserID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserAuthenticationNonce`
--

DROP TABLE IF EXISTS `GDN_UserAuthenticationNonce`;
CREATE TABLE `GDN_UserAuthenticationNonce` (
  `Nonce` varchar(200) collate utf8_unicode_ci NOT NULL,
  `Token` varchar(128) collate utf8_unicode_ci NOT NULL,
  `Timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`Nonce`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserAuthenticationProvider`
--

DROP TABLE IF EXISTS `GDN_UserAuthenticationProvider`;
CREATE TABLE `GDN_UserAuthenticationProvider` (
  `AuthenticationKey` varchar(64) collate utf8_unicode_ci NOT NULL,
  `AuthenticationSchemeAlias` varchar(32) collate utf8_unicode_ci NOT NULL,
  `URL` varchar(255) collate utf8_unicode_ci default NULL,
  `AssociationSecret` text collate utf8_unicode_ci NOT NULL,
  `AssociationHashMethod` enum('HMAC-SHA1','HMAC-PLAINTEXT') collate utf8_unicode_ci NOT NULL,
  `AuthenticateUrl` varchar(255) collate utf8_unicode_ci default NULL,
  `RegisterUrl` varchar(255) collate utf8_unicode_ci default NULL,
  `SignInUrl` varchar(255) collate utf8_unicode_ci default NULL,
  `SignOutUrl` varchar(255) collate utf8_unicode_ci default NULL,
  `PasswordUrl` varchar(255) collate utf8_unicode_ci default NULL,
  `ProfileUrl` varchar(255) collate utf8_unicode_ci default NULL,
  PRIMARY KEY  (`AuthenticationKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserAuthenticationToken`
--

DROP TABLE IF EXISTS `GDN_UserAuthenticationToken`;
CREATE TABLE `GDN_UserAuthenticationToken` (
  `Token` varchar(128) collate utf8_unicode_ci NOT NULL,
  `ProviderKey` varchar(64) collate utf8_unicode_ci NOT NULL,
  `ForeignUserKey` varchar(255) collate utf8_unicode_ci default NULL,
  `TokenSecret` varchar(64) collate utf8_unicode_ci NOT NULL,
  `TokenType` enum('request','access') collate utf8_unicode_ci NOT NULL,
  `Authorized` tinyint(4) NOT NULL,
  `Timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `Lifetime` int(11) NOT NULL,
  PRIMARY KEY  (`Token`,`ProviderKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserComment`
--

DROP TABLE IF EXISTS `GDN_UserComment`;
CREATE TABLE `GDN_UserComment` (
  `UserID` int(11) NOT NULL,
  `CommentID` int(11) NOT NULL,
  `Score` float default NULL,
  `DateLastViewed` datetime default NULL,
  PRIMARY KEY  (`UserID`,`CommentID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserConversation`
--

DROP TABLE IF EXISTS `GDN_UserConversation`;
CREATE TABLE `GDN_UserConversation` (
  `UserID` int(11) NOT NULL,
  `ConversationID` int(11) NOT NULL,
  `CountReadMessages` int(11) NOT NULL default '0',
  `CountNewMessages` int(11) NOT NULL default '0',
  `CountMessages` int(11) NOT NULL default '0',
  `LastMessageID` int(11) default NULL,
  `DateLastViewed` datetime default NULL,
  `DateCleared` datetime default NULL,
  `Bookmarked` tinyint(1) NOT NULL default '0',
  `Deleted` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`UserID`,`ConversationID`),
  KEY `FK_UserConversation_LastMessageID` (`LastMessageID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserDiscussion`
--

DROP TABLE IF EXISTS `GDN_UserDiscussion`;
CREATE TABLE `GDN_UserDiscussion` (
  `UserID` int(11) NOT NULL,
  `DiscussionID` int(11) NOT NULL,
  `Score` float default NULL,
  `CountComments` int(11) NOT NULL default '0',
  `DateLastViewed` datetime default NULL,
  `Dismissed` tinyint(1) NOT NULL default '0',
  `Bookmarked` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`UserID`,`DiscussionID`),
  KEY `FK_UserDiscussion_DiscussionID` (`DiscussionID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserMeta`
--

DROP TABLE IF EXISTS `GDN_UserMeta`;
CREATE TABLE `GDN_UserMeta` (
  `UserID` int(11) NOT NULL,
  `Name` varchar(255) collate utf8_unicode_ci NOT NULL,
  `Value` text collate utf8_unicode_ci,
  PRIMARY KEY  (`UserID`,`Name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_UserRole`
--

DROP TABLE IF EXISTS `GDN_UserRole`;
CREATE TABLE `GDN_UserRole` (
  `UserID` int(11) NOT NULL,
  `RoleID` int(11) NOT NULL,
  PRIMARY KEY  (`UserID`,`RoleID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `GDN_Whosonline`
--

DROP TABLE IF EXISTS `GDN_Whosonline`;
CREATE TABLE `GDN_Whosonline` (
  `UserID` int(11) NOT NULL default '11',
  `Timestamp` int(11) NOT NULL default '11'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table structure for table `access`
--

DROP TABLE IF EXISTS `access`;
CREATE TABLE `access` (
  `aid` int(11) NOT NULL auto_increment,
  `mask` varchar(255) NOT NULL default '',
  `type` varchar(255) NOT NULL default '',
  `status` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
CREATE TABLE `actions` (
  `aid` varchar(255) NOT NULL default '0',
  `type` varchar(32) NOT NULL default '',
  `callback` varchar(255) NOT NULL default '',
  `parameters` longtext NOT NULL,
  `description` varchar(255) NOT NULL default '0',
  PRIMARY KEY  (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `actions_aid`
--

DROP TABLE IF EXISTS `actions_aid`;
CREATE TABLE `actions_aid` (
  `aid` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `authmap`
--

DROP TABLE IF EXISTS `authmap`;
CREATE TABLE `authmap` (
  `aid` int(10) unsigned NOT NULL auto_increment,
  `uid` int(11) NOT NULL default '0',
  `authname` varchar(128) NOT NULL default '',
  `module` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`aid`),
  UNIQUE KEY `authname` (`authname`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

--
-- Table structure for table `batch`
--

DROP TABLE IF EXISTS `batch`;
CREATE TABLE `batch` (
  `bid` int(10) unsigned NOT NULL auto_increment,
  `token` varchar(64) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `batch` longtext,
  PRIMARY KEY  (`bid`),
  KEY `token` (`token`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
CREATE TABLE `blocks` (
  `bid` int(11) NOT NULL auto_increment,
  `module` varchar(64) NOT NULL default '',
  `delta` varchar(32) NOT NULL default '0',
  `theme` varchar(64) NOT NULL default '',
  `status` tinyint(4) NOT NULL default '0',
  `weight` tinyint(4) NOT NULL default '0',
  `region` varchar(64) NOT NULL default '',
  `custom` tinyint(4) NOT NULL default '0',
  `throttle` tinyint(4) NOT NULL default '0',
  `visibility` tinyint(4) NOT NULL default '0',
  `pages` text NOT NULL,
  `title` varchar(64) NOT NULL default '',
  `cache` tinyint(4) NOT NULL default '1',
  PRIMARY KEY  (`bid`),
  UNIQUE KEY `tmd` (`theme`,`module`,`delta`),
  KEY `list` (`theme`,`status`,`region`,`weight`,`module`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Table structure for table `blocks_roles`
--

DROP TABLE IF EXISTS `blocks_roles`;
CREATE TABLE `blocks_roles` (
  `module` varchar(64) NOT NULL,
  `delta` varchar(32) NOT NULL,
  `rid` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`module`,`delta`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `boxes`
--

DROP TABLE IF EXISTS `boxes`;
CREATE TABLE `boxes` (
  `bid` int(10) unsigned NOT NULL auto_increment,
  `body` longtext,
  `info` varchar(128) NOT NULL default '',
  `format` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`bid`),
  UNIQUE KEY `info` (`info`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `bueditor_buttons`
--

DROP TABLE IF EXISTS `bueditor_buttons`;
CREATE TABLE `bueditor_buttons` (
  `bid` int(10) unsigned NOT NULL auto_increment,
  `eid` int(10) unsigned NOT NULL default '0',
  `title` varchar(255) NOT NULL default 'Notitle',
  `content` text NOT NULL,
  `icon` varchar(255) NOT NULL default '',
  `accesskey` varchar(1) NOT NULL default '',
  `weight` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`bid`),
  KEY `eid` (`eid`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Table structure for table `bueditor_editors`
--

DROP TABLE IF EXISTS `bueditor_editors`;
CREATE TABLE `bueditor_editors` (
  `eid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default 'Noname',
  `pages` text NOT NULL,
  `excludes` text NOT NULL,
  `iconpath` varchar(255) NOT NULL default '%BUEDITOR/icons',
  `librarypath` varchar(255) NOT NULL default '%BUEDITOR/library',
  PRIMARY KEY  (`eid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_block`
--

DROP TABLE IF EXISTS `cache_block`;
CREATE TABLE `cache_block` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_filter`
--

DROP TABLE IF EXISTS `cache_filter`;
CREATE TABLE `cache_filter` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_form`
--

DROP TABLE IF EXISTS `cache_form`;
CREATE TABLE `cache_form` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_gravatar`
--

DROP TABLE IF EXISTS `cache_gravatar`;
CREATE TABLE `cache_gravatar` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_menu`
--

DROP TABLE IF EXISTS `cache_menu`;
CREATE TABLE `cache_menu` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_page`
--

DROP TABLE IF EXISTS `cache_page`;
CREATE TABLE `cache_page` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cache_update`
--

DROP TABLE IF EXISTS `cache_update`;
CREATE TABLE `cache_update` (
  `cid` varchar(255) NOT NULL default '',
  `data` longblob,
  `expire` int(11) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `headers` text,
  `serialized` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`cid`),
  KEY `expire` (`expire`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `captcha_points`
--

DROP TABLE IF EXISTS `captcha_points`;
CREATE TABLE `captcha_points` (
  `form_id` varchar(128) NOT NULL,
  `module` varchar(64) default NULL,
  `type` varchar(64) default NULL,
  PRIMARY KEY  (`form_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `captcha_sessions`
--

DROP TABLE IF EXISTS `captcha_sessions`;
CREATE TABLE `captcha_sessions` (
  `csid` int(11) NOT NULL auto_increment,
  `uid` int(11) NOT NULL default '0',
  `sid` varchar(64) NOT NULL default '',
  `ip_address` varchar(128) default NULL,
  `timestamp` int(11) NOT NULL default '0',
  `form_id` varchar(128) NOT NULL,
  `solution` varchar(128) NOT NULL default '',
  `status` int(11) NOT NULL default '0',
  `attempts` int(11) NOT NULL default '0',
  PRIMARY KEY  (`csid`),
  KEY `csid_ip` (`csid`,`ip_address`)
) ENGINE=MyISAM AUTO_INCREMENT=9318 DEFAULT CHARSET=utf8;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `cid` int(11) NOT NULL auto_increment,
  `pid` int(11) NOT NULL default '0',
  `nid` int(11) NOT NULL default '0',
  `uid` int(11) NOT NULL default '0',
  `subject` varchar(64) NOT NULL default '',
  `comment` longtext NOT NULL,
  `hostname` varchar(128) NOT NULL default '',
  `timestamp` int(11) NOT NULL default '0',
  `status` tinyint(3) unsigned NOT NULL default '0',
  `format` smallint(6) NOT NULL default '0',
  `thread` varchar(255) NOT NULL,
  `name` varchar(60) default NULL,
  `mail` varchar(64) default NULL,
  `homepage` varchar(255) default NULL,
  PRIMARY KEY  (`cid`),
  KEY `pid` (`pid`),
  KEY `nid` (`nid`),
  KEY `status` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `fid` int(10) unsigned NOT NULL auto_increment,
  `uid` int(10) unsigned NOT NULL default '0',
  `filename` varchar(255) NOT NULL default '',
  `filepath` varchar(255) NOT NULL default '',
  `filemime` varchar(255) NOT NULL default '',
  `filesize` int(10) unsigned NOT NULL default '0',
  `status` int(11) NOT NULL default '0',
  `timestamp` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`fid`),
  KEY `uid` (`uid`),
  KEY `status` (`status`),
  KEY `timestamp` (`timestamp`)
) ENGINE=MyISAM AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;

--
-- Table structure for table `filter_formats`
--

DROP TABLE IF EXISTS `filter_formats`;
CREATE TABLE `filter_formats` (
  `format` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `roles` varchar(255) NOT NULL default '',
  `cache` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`format`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Table structure for table `filters`
--

DROP TABLE IF EXISTS `filters`;
CREATE TABLE `filters` (
  `fid` int(11) NOT NULL auto_increment,
  `format` int(11) NOT NULL default '0',
  `module` varchar(64) NOT NULL default '',
  `delta` tinyint(4) NOT NULL default '0',
  `weight` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`fid`),
  UNIQUE KEY `fmd` (`format`,`module`,`delta`),
  KEY `list` (`format`,`weight`,`module`,`delta`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Table structure for table `flood`
--

DROP TABLE IF EXISTS `flood`;
CREATE TABLE `flood` (
  `fid` int(11) NOT NULL auto_increment,
  `event` varchar(64) NOT NULL default '',
  `hostname` varchar(128) NOT NULL default '',
  `timestamp` int(11) NOT NULL default '0',
  PRIMARY KEY  (`fid`),
  KEY `allow` (`event`,`hostname`,`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `forum`
--

DROP TABLE IF EXISTS `forum`;
CREATE TABLE `forum` (
  `nid` int(10) unsigned NOT NULL default '0',
  `vid` int(10) unsigned NOT NULL default '0',
  `tid` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`vid`),
  KEY `nid` (`nid`),
  KEY `tid` (`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `uid` int(11) NOT NULL default '0',
  `nid` int(11) NOT NULL default '0',
  `timestamp` int(11) NOT NULL default '0',
  PRIMARY KEY  (`uid`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `i18n_blocks`
--

DROP TABLE IF EXISTS `i18n_blocks`;
CREATE TABLE `i18n_blocks` (
  `ibid` int(10) unsigned NOT NULL auto_increment,
  `module` varchar(64) NOT NULL,
  `delta` varchar(32) NOT NULL default '0',
  `type` int(11) NOT NULL default '0',
  `language` varchar(12) NOT NULL default '',
  PRIMARY KEY  (`ibid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `i18n_strings`
--

DROP TABLE IF EXISTS `i18n_strings`;
CREATE TABLE `i18n_strings` (
  `lid` int(11) NOT NULL default '0',
  `objectid` int(11) NOT NULL default '0',
  `type` varchar(255) NOT NULL default '',
  `property` varchar(255) NOT NULL default 'default',
  PRIMARY KEY  (`lid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `i18n_variable`
--

DROP TABLE IF EXISTS `i18n_variable`;
CREATE TABLE `i18n_variable` (
  `name` varchar(128) NOT NULL default '',
  `language` varchar(12) NOT NULL default '',
  `value` longtext NOT NULL,
  PRIMARY KEY  (`name`,`language`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `nid` int(10) unsigned NOT NULL default '0',
  `fid` int(10) unsigned NOT NULL default '0',
  `image_size` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`nid`,`image_size`),
  KEY `fid` (`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `image_attach`
--

DROP TABLE IF EXISTS `image_attach`;
CREATE TABLE `image_attach` (
  `nid` int(10) unsigned NOT NULL default '0',
  `iid` int(10) unsigned NOT NULL default '0',
  `weight` int(11) NOT NULL default '0',
  PRIMARY KEY  (`nid`,`iid`),
  KEY `iid` (`iid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
CREATE TABLE `languages` (
  `language` varchar(12) NOT NULL default '',
  `name` varchar(64) NOT NULL default '',
  `native` varchar(64) NOT NULL default '',
  `direction` int(11) NOT NULL default '0',
  `enabled` int(11) NOT NULL default '0',
  `plurals` int(11) NOT NULL default '0',
  `formula` varchar(128) NOT NULL default '',
  `domain` varchar(128) NOT NULL default '',
  `prefix` varchar(128) NOT NULL default '',
  `weight` int(11) NOT NULL default '0',
  `javascript` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`language`),
  KEY `list` (`weight`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `locales_source`
--

DROP TABLE IF EXISTS `locales_source`;
CREATE TABLE `locales_source` (
  `lid` int(11) NOT NULL auto_increment,
  `location` varchar(255) NOT NULL default '',
  `textgroup` varchar(255) NOT NULL default 'default',
  `source` blob NOT NULL,
  `version` varchar(20) NOT NULL default 'none',
  PRIMARY KEY  (`lid`),
  KEY `source` (`source`(30)),
  KEY `textgroup_location` (`textgroup`(30),`location`)
) ENGINE=MyISAM AUTO_INCREMENT=4355 DEFAULT CHARSET=utf8;

--
-- Table structure for table `locales_target`
--

DROP TABLE IF EXISTS `locales_target`;
CREATE TABLE `locales_target` (
  `lid` int(11) NOT NULL default '0',
  `translation` blob NOT NULL,
  `language` varchar(12) NOT NULL default '',
  `plid` int(11) NOT NULL default '0',
  `plural` int(11) NOT NULL default '0',
  `status` int(11) NOT NULL default '0',
  PRIMARY KEY  (`language`,`lid`,`plural`),
  KEY `lid` (`lid`),
  KEY `plid` (`plid`),
  KEY `plural` (`plural`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `menu_custom`
--

DROP TABLE IF EXISTS `menu_custom`;
CREATE TABLE `menu_custom` (
  `menu_name` varchar(32) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `description` text,
  PRIMARY KEY  (`menu_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `menu_links`
--

DROP TABLE IF EXISTS `menu_links`;
CREATE TABLE `menu_links` (
  `menu_name` varchar(32) NOT NULL default '',
  `mlid` int(10) unsigned NOT NULL auto_increment,
  `plid` int(10) unsigned NOT NULL default '0',
  `link_path` varchar(255) NOT NULL default '',
  `router_path` varchar(255) NOT NULL default '',
  `link_title` varchar(255) NOT NULL default '',
  `options` text,
  `module` varchar(255) NOT NULL default 'system',
  `hidden` smallint(6) NOT NULL default '0',
  `external` smallint(6) NOT NULL default '0',
  `has_children` smallint(6) NOT NULL default '0',
  `expanded` smallint(6) NOT NULL default '0',
  `weight` int(11) NOT NULL default '0',
  `depth` smallint(6) NOT NULL default '0',
  `customized` smallint(6) NOT NULL default '0',
  `p1` int(10) unsigned NOT NULL default '0',
  `p2` int(10) unsigned NOT NULL default '0',
  `p3` int(10) unsigned NOT NULL default '0',
  `p4` int(10) unsigned NOT NULL default '0',
  `p5` int(10) unsigned NOT NULL default '0',
  `p6` int(10) unsigned NOT NULL default '0',
  `p7` int(10) unsigned NOT NULL default '0',
  `p8` int(10) unsigned NOT NULL default '0',
  `p9` int(10) unsigned NOT NULL default '0',
  `updated` smallint(6) NOT NULL default '0',
  PRIMARY KEY  (`mlid`),
  KEY `path_menu` (`link_path`(128),`menu_name`),
  KEY `menu_plid_expand_child` (`menu_name`,`plid`,`expanded`,`has_children`),
  KEY `menu_parents` (`menu_name`,`p1`,`p2`,`p3`,`p4`,`p5`,`p6`,`p7`,`p8`,`p9`),
  KEY `router_path` (`router_path`(128))
) ENGINE=MyISAM AUTO_INCREMENT=259 DEFAULT CHARSET=utf8;

--
-- Table structure for table `menu_router`
--

DROP TABLE IF EXISTS `menu_router`;
CREATE TABLE `menu_router` (
  `path` varchar(255) NOT NULL default '',
  `load_functions` text NOT NULL,
  `to_arg_functions` text NOT NULL,
  `access_callback` varchar(255) NOT NULL default '',
  `access_arguments` text,
  `page_callback` varchar(255) NOT NULL default '',
  `page_arguments` text,
  `fit` int(11) NOT NULL default '0',
  `number_parts` smallint(6) NOT NULL default '0',
  `tab_parent` varchar(255) NOT NULL default '',
  `tab_root` varchar(255) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `title_callback` varchar(255) NOT NULL default '',
  `title_arguments` varchar(255) NOT NULL default '',
  `type` int(11) NOT NULL default '0',
  `block_callback` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `position` varchar(255) NOT NULL default '',
  `weight` int(11) NOT NULL default '0',
  `file` mediumtext,
  PRIMARY KEY  (`path`),
  KEY `fit` (`fit`),
  KEY `tab_parent` (`tab_parent`),
  KEY `tab_root_weight_title` (`tab_root`(64),`weight`,`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
CREATE TABLE `node` (
  `nid` int(10) unsigned NOT NULL auto_increment,
  `vid` int(10) unsigned NOT NULL default '0',
  `type` varchar(32) NOT NULL default '',
  `language` varchar(12) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `uid` int(11) NOT NULL default '0',
  `status` int(11) NOT NULL default '1',
  `created` int(11) NOT NULL default '0',
  `changed` int(11) NOT NULL default '0',
  `comment` int(11) NOT NULL default '0',
  `promote` int(11) NOT NULL default '0',
  `moderate` int(11) NOT NULL default '0',
  `sticky` int(11) NOT NULL default '0',
  `tnid` int(10) unsigned NOT NULL default '0',
  `translate` int(11) NOT NULL default '0',
  PRIMARY KEY  (`nid`),
  UNIQUE KEY `vid` (`vid`),
  KEY `node_changed` (`changed`),
  KEY `node_created` (`created`),
  KEY `node_moderate` (`moderate`),
  KEY `node_promote_status` (`promote`,`status`),
  KEY `node_status_type` (`status`,`type`,`nid`),
  KEY `node_title_type` (`title`,`type`(4)),
  KEY `node_type` (`type`(4)),
  KEY `uid` (`uid`),
  KEY `tnid` (`tnid`),
  KEY `translate` (`translate`)
) ENGINE=MyISAM AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_access`
--

DROP TABLE IF EXISTS `node_access`;
CREATE TABLE `node_access` (
  `nid` int(10) unsigned NOT NULL default '0',
  `gid` int(10) unsigned NOT NULL default '0',
  `realm` varchar(255) NOT NULL default '',
  `grant_view` tinyint(3) unsigned NOT NULL default '0',
  `grant_update` tinyint(3) unsigned NOT NULL default '0',
  `grant_delete` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`nid`,`gid`,`realm`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_comment_statistics`
--

DROP TABLE IF EXISTS `node_comment_statistics`;
CREATE TABLE `node_comment_statistics` (
  `nid` int(10) unsigned NOT NULL default '0',
  `last_comment_timestamp` int(11) NOT NULL default '0',
  `last_comment_name` varchar(60) default NULL,
  `last_comment_uid` int(11) NOT NULL default '0',
  `comment_count` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`nid`),
  KEY `node_comment_timestamp` (`last_comment_timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_counter`
--

DROP TABLE IF EXISTS `node_counter`;
CREATE TABLE `node_counter` (
  `nid` int(11) NOT NULL default '0',
  `totalcount` bigint(20) unsigned NOT NULL default '0',
  `daycount` mediumint(8) unsigned NOT NULL default '0',
  `timestamp` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_revisions`
--

DROP TABLE IF EXISTS `node_revisions`;
CREATE TABLE `node_revisions` (
  `nid` int(10) unsigned NOT NULL default '0',
  `vid` int(10) unsigned NOT NULL auto_increment,
  `uid` int(11) NOT NULL default '0',
  `title` varchar(255) NOT NULL default '',
  `body` longtext NOT NULL,
  `teaser` longtext NOT NULL,
  `log` longtext NOT NULL,
  `timestamp` int(11) NOT NULL default '0',
  `format` int(11) NOT NULL default '0',
  PRIMARY KEY  (`vid`),
  KEY `nid` (`nid`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=485 DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_type`
--

DROP TABLE IF EXISTS `node_type`;
CREATE TABLE `node_type` (
  `type` varchar(32) NOT NULL,
  `name` varchar(255) NOT NULL default '',
  `module` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `help` mediumtext NOT NULL,
  `has_title` tinyint(3) unsigned NOT NULL,
  `title_label` varchar(255) NOT NULL default '',
  `has_body` tinyint(3) unsigned NOT NULL,
  `body_label` varchar(255) NOT NULL default '',
  `min_word_count` smallint(5) unsigned NOT NULL,
  `custom` tinyint(4) NOT NULL default '0',
  `modified` tinyint(4) NOT NULL default '0',
  `locked` tinyint(4) NOT NULL default '0',
  `orig_type` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `openid_association`
--

DROP TABLE IF EXISTS `openid_association`;
CREATE TABLE `openid_association` (
  `idp_endpoint_uri` varchar(255) default NULL,
  `assoc_handle` varchar(255) NOT NULL,
  `assoc_type` varchar(32) default NULL,
  `session_type` varchar(32) default NULL,
  `mac_key` varchar(255) default NULL,
  `created` int(11) NOT NULL default '0',
  `expires_in` int(11) NOT NULL default '0',
  PRIMARY KEY  (`assoc_handle`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `pid` int(11) NOT NULL auto_increment,
  `rid` int(10) unsigned NOT NULL default '0',
  `perm` longtext,
  `tid` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`pid`),
  KEY `rid` (`rid`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

--
-- Table structure for table `poll`
--

DROP TABLE IF EXISTS `poll`;
CREATE TABLE `poll` (
  `nid` int(10) unsigned NOT NULL default '0',
  `runtime` int(11) NOT NULL default '0',
  `active` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `poll_choices`
--

DROP TABLE IF EXISTS `poll_choices`;
CREATE TABLE `poll_choices` (
  `chid` int(10) unsigned NOT NULL auto_increment,
  `nid` int(10) unsigned NOT NULL default '0',
  `chtext` varchar(128) NOT NULL default '',
  `chvotes` int(11) NOT NULL default '0',
  `chorder` int(11) NOT NULL default '0',
  PRIMARY KEY  (`chid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `poll_votes`
--

DROP TABLE IF EXISTS `poll_votes`;
CREATE TABLE `poll_votes` (
  `nid` int(10) unsigned NOT NULL,
  `uid` int(10) unsigned NOT NULL default '0',
  `chorder` int(11) NOT NULL default '-1',
  `hostname` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`nid`,`uid`,`hostname`),
  KEY `hostname` (`hostname`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `profile_fields`
--

DROP TABLE IF EXISTS `profile_fields`;
CREATE TABLE `profile_fields` (
  `fid` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `name` varchar(128) NOT NULL default '',
  `explanation` text,
  `category` varchar(255) default NULL,
  `page` varchar(255) default NULL,
  `type` varchar(128) default NULL,
  `weight` tinyint(4) NOT NULL default '0',
  `required` tinyint(4) NOT NULL default '0',
  `register` tinyint(4) NOT NULL default '0',
  `visibility` tinyint(4) NOT NULL default '0',
  `autocomplete` tinyint(4) NOT NULL default '0',
  `options` text,
  PRIMARY KEY  (`fid`),
  UNIQUE KEY `name` (`name`),
  KEY `category` (`category`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Table structure for table `profile_values`
--

DROP TABLE IF EXISTS `profile_values`;
CREATE TABLE `profile_values` (
  `fid` int(10) unsigned NOT NULL default '0',
  `uid` int(10) unsigned NOT NULL default '0',
  `value` text,
  PRIMARY KEY  (`uid`,`fid`),
  KEY `fid` (`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `rid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  PRIMARY KEY  (`rid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `uid` int(10) unsigned NOT NULL,
  `sid` varchar(64) NOT NULL default '',
  `hostname` varchar(128) NOT NULL default '',
  `timestamp` int(11) NOT NULL default '0',
  `cache` int(11) NOT NULL default '0',
  `session` longtext,
  PRIMARY KEY  (`sid`),
  KEY `timestamp` (`timestamp`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
CREATE TABLE `system` (
  `filename` varchar(255) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  `type` varchar(255) NOT NULL default '',
  `owner` varchar(255) NOT NULL default '',
  `status` int(11) NOT NULL default '0',
  `throttle` tinyint(4) NOT NULL default '0',
  `bootstrap` int(11) NOT NULL default '0',
  `schema_version` smallint(6) NOT NULL default '-1',
  `weight` int(11) NOT NULL default '0',
  `info` text,
  PRIMARY KEY  (`filename`),
  KEY `modules` (`type`(12),`status`,`weight`,`filename`),
  KEY `bootstrap` (`type`(12),`status`,`bootstrap`,`weight`,`filename`),
  KEY `type_name` (`type`(12),`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `term_data`
--

DROP TABLE IF EXISTS `term_data`;
CREATE TABLE `term_data` (
  `tid` int(10) unsigned NOT NULL auto_increment,
  `vid` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `description` longtext,
  `weight` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`tid`),
  KEY `taxonomy_tree` (`vid`,`weight`,`name`),
  KEY `vid_name` (`vid`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Table structure for table `term_hierarchy`
--

DROP TABLE IF EXISTS `term_hierarchy`;
CREATE TABLE `term_hierarchy` (
  `tid` int(10) unsigned NOT NULL default '0',
  `parent` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`,`parent`),
  KEY `parent` (`parent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `term_node`
--

DROP TABLE IF EXISTS `term_node`;
CREATE TABLE `term_node` (
  `nid` int(10) unsigned NOT NULL default '0',
  `vid` int(10) unsigned NOT NULL default '0',
  `tid` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`tid`,`vid`),
  KEY `vid` (`vid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `term_relation`
--

DROP TABLE IF EXISTS `term_relation`;
CREATE TABLE `term_relation` (
  `trid` int(11) NOT NULL auto_increment,
  `tid1` int(10) unsigned NOT NULL default '0',
  `tid2` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`trid`),
  UNIQUE KEY `tid1_tid2` (`tid1`,`tid2`),
  KEY `tid2` (`tid2`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `term_synonym`
--

DROP TABLE IF EXISTS `term_synonym`;
CREATE TABLE `term_synonym` (
  `tsid` int(11) NOT NULL auto_increment,
  `tid` int(10) unsigned NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`tsid`),
  KEY `tid` (`tid`),
  KEY `name_tid` (`name`,`tid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `translation_overview_priority`
--

DROP TABLE IF EXISTS `translation_overview_priority`;
CREATE TABLE `translation_overview_priority` (
  `tnid` int(10) unsigned NOT NULL,
  `lang_en` tinyint(3) unsigned NOT NULL default '1',
  `lang_fr` tinyint(3) unsigned NOT NULL default '1',
  `lang_de` tinyint(3) unsigned NOT NULL default '1',
  `lang_ptbr` tinyint(3) unsigned NOT NULL default '1',
  `lang_zhhant` tinyint(3) unsigned NOT NULL default '1',
  PRIMARY KEY  (`tnid`),
  KEY `lang_en` (`lang_en`),
  KEY `lang_fr` (`lang_fr`),
  KEY `lang_de` (`lang_de`),
  KEY `lang_ptbr` (`lang_ptbr`),
  KEY `lang_zhhant` (`lang_zhhant`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `twitter`
--

DROP TABLE IF EXISTS `twitter`;
CREATE TABLE `twitter` (
  `twitter_id` decimal(20,0) unsigned NOT NULL default '0',
  `screen_name` varchar(255) NOT NULL default '',
  `created_at` varchar(64) NOT NULL default '',
  `created_time` int(11) NOT NULL,
  `text` varchar(255) default NULL,
  `source` varchar(255) default NULL,
  `in_reply_to_status_id` decimal(20,0) unsigned default NULL,
  `in_reply_to_user_id` decimal(20,0) unsigned default NULL,
  `in_reply_to_screen_name` varchar(255) default NULL,
  `truncated` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`twitter_id`),
  KEY `screen_name` (`screen_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `twitter_account`
--

DROP TABLE IF EXISTS `twitter_account`;
CREATE TABLE `twitter_account` (
  `twitter_uid` decimal(20,0) unsigned NOT NULL default '0',
  `screen_name` varchar(255) default NULL,
  `name` varchar(64) NOT NULL default '',
  `description` varchar(255) default NULL,
  `location` varchar(255) default NULL,
  `followers_count` int(11) NOT NULL default '0',
  `profile_image_url` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `protected` int(10) unsigned NOT NULL default '0',
  `last_refresh` int(11) NOT NULL default '0',
  PRIMARY KEY  (`twitter_uid`),
  KEY `screen_name` (`screen_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `twitter_user`
--

DROP TABLE IF EXISTS `twitter_user`;
CREATE TABLE `twitter_user` (
  `uid` int(11) NOT NULL,
  `screen_name` varchar(255) NOT NULL default '',
  `password` varchar(64) default NULL,
  `import` int(10) unsigned NOT NULL default '1',
  PRIMARY KEY  (`uid`,`screen_name`),
  KEY `screen_name` (`screen_name`),
  KEY `uid` (`uid`),
  KEY `import` (`import`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `upload`
--

DROP TABLE IF EXISTS `upload`;
CREATE TABLE `upload` (
  `fid` int(10) unsigned NOT NULL default '0',
  `nid` int(10) unsigned NOT NULL default '0',
  `vid` int(10) unsigned NOT NULL default '0',
  `description` varchar(255) NOT NULL default '',
  `list` tinyint(3) unsigned NOT NULL default '0',
  `weight` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`vid`,`fid`),
  KEY `fid` (`fid`),
  KEY `nid` (`nid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `url_alias`
--

DROP TABLE IF EXISTS `url_alias`;
CREATE TABLE `url_alias` (
  `pid` int(10) unsigned NOT NULL auto_increment,
  `src` varchar(128) NOT NULL default '',
  `dst` varchar(128) NOT NULL default '',
  `language` varchar(12) NOT NULL default '',
  PRIMARY KEY  (`pid`),
  UNIQUE KEY `dst_language` (`dst`,`language`),
  KEY `src_language` (`src`,`language`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `uid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(60) NOT NULL default '',
  `pass` varchar(32) NOT NULL default '',
  `mail` varchar(64) default '',
  `mode` tinyint(4) NOT NULL default '0',
  `sort` tinyint(4) default '0',
  `threshold` tinyint(4) default '0',
  `theme` varchar(255) NOT NULL default '',
  `signature` varchar(255) NOT NULL default '',
  `signature_format` smallint(6) NOT NULL default '0',
  `created` int(11) NOT NULL default '0',
  `access` int(11) NOT NULL default '0',
  `login` int(11) NOT NULL default '0',
  `status` tinyint(4) NOT NULL default '0',
  `timezone` varchar(8) default NULL,
  `language` varchar(12) NOT NULL default '',
  `picture` varchar(255) NOT NULL default '',
  `init` varchar(64) default '',
  `data` longtext,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `name` (`name`),
  KEY `access` (`access`),
  KEY `created` (`created`),
  KEY `mail` (`mail`)
) ENGINE=MyISAM AUTO_INCREMENT=611 DEFAULT CHARSET=utf8;

--
-- Table structure for table `users_roles`
--

DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE `users_roles` (
  `uid` int(10) unsigned NOT NULL default '0',
  `rid` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`uid`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `variable`
--

DROP TABLE IF EXISTS `variable`;
CREATE TABLE `variable` (
  `name` varchar(128) NOT NULL default '',
  `value` longtext NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `vocabulary`
--

DROP TABLE IF EXISTS `vocabulary`;
CREATE TABLE `vocabulary` (
  `vid` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `description` longtext,
  `help` varchar(255) NOT NULL default '',
  `relations` tinyint(3) unsigned NOT NULL default '0',
  `hierarchy` tinyint(3) unsigned NOT NULL default '0',
  `multiple` tinyint(3) unsigned NOT NULL default '0',
  `required` tinyint(3) unsigned NOT NULL default '0',
  `tags` tinyint(3) unsigned NOT NULL default '0',
  `module` varchar(255) NOT NULL default '',
  `weight` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`vid`),
  KEY `list` (`weight`,`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Table structure for table `vocabulary_node_types`
--

DROP TABLE IF EXISTS `vocabulary_node_types`;
CREATE TABLE `vocabulary_node_types` (
  `vid` int(10) unsigned NOT NULL default '0',
  `type` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`type`,`vid`),
  KEY `vid` (`vid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `watchdog`
--

DROP TABLE IF EXISTS `watchdog`;
CREATE TABLE `watchdog` (
  `wid` int(11) NOT NULL auto_increment,
  `uid` int(11) NOT NULL default '0',
  `type` varchar(16) NOT NULL default '',
  `message` longtext NOT NULL,
  `variables` longtext NOT NULL,
  `severity` tinyint(3) unsigned NOT NULL default '0',
  `link` varchar(255) NOT NULL default '',
  `location` text NOT NULL,
  `referer` text,
  `hostname` varchar(128) NOT NULL default '',
  `timestamp` int(11) NOT NULL default '0',
  PRIMARY KEY  (`wid`),
  KEY `type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=10149 DEFAULT CHARSET=utf8;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-12-22  8:55:59
