DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
  id					int				not null	auto_increment,
  created_at			datetime		not null,
  name					varchar(20)		not null,
  topic					varchar(100)	not null,
  description			varchar(255)	not null,
  channel_access_id		tinyint			not null,
  channel_category_id	tinyint			not null,
  parent_id				int				null,
  parent_status_id		tinyint			null,
  status_id				tinyint			not null,
  PRIMARY KEY (id),
  INDEX created_at_and_status (created_at, status_id),
  UNIQUE (name),
  INDEX channel_category_and_status (channel_category_id, status_id),
  INDEX parent_and_parent_status_and_status (parent_id, parent_status_id, status_id)
);
INSERT INTO channels (name, topic, description, channel_access_id, channel_category_id, status_id) VALUES ("lobby", "Welcome to the netwirc lobby!", "This channel serves to demonstrate a basic channel. Please browse the channels created by our users or create your own... free!", 1, 6, 2);

DROP TABLE IF EXISTS channel_accesses;
CREATE TABLE channel_accesses (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO channel_accesses (name) VALUES ("Public");
INSERT INTO channel_accesses (name) VALUES ("Moderated");
INSERT INTO channel_accesses (name) VALUES ("Invite Only");

DROP TABLE IF EXISTS channel_categories;
CREATE TABLE channel_categories (
  id				int				not null	auto_increment,
  name				varchar(60)		not null,
  PRIMARY KEY (id)
);
INSERT INTO channel_categories (name) VALUES ("Arts & Entertainment");
INSERT INTO channel_categories (name) VALUES ("Business & Finance");
INSERT INTO channel_categories (name) VALUES ("Education & Schools");
INSERT INTO channel_categories (name) VALUES ("Family & Home");
INSERT INTO channel_categories (name) VALUES ("Health & Wellness");
INSERT INTO channel_categories (name) VALUES ("Personal & Social");
INSERT INTO channel_categories (name) VALUES ("Politics & Society");
INSERT INTO channel_categories (name) VALUES ("Religion & Beliefs");
INSERT INTO channel_categories (name) VALUES ("Science & Technology");
INSERT INTO channel_categories (name) VALUES ("Sports & Recreation");

DROP TABLE IF EXISTS channel_favorites;
CREATE TABLE channel_favorites (
  id				int				not null	auto_increment,
  channel_id		int				not null,
  user_id			int				not null,
  PRIMARY KEY (id),
  INDEX (channel_id),
  INDEX (user_id),
  INDEX channel_and_user (channel_id, user_id)
);

DROP TABLE IF EXISTS channel_flags;
CREATE TABLE channel_flags (
  id				int				not null	auto_increment,
  created_at		datetime		not null,
  user_id			int				not null,
  channel_id		int				not null,
  reason			varchar(255)	not null,
  PRIMARY KEY (id),
  INDEX created_at_and_channel (created_at, channel_id),
  INDEX (channel_id)
);

/*
DROP TABLE IF EXISTS channel_friendships;
CREATE TABLE channel_friendships (
  id				int				not null	auto_increment,
  requester_id		int				not null,
  requestee_id		int				not null,
  status_id			tinyint				not null,
  PRIMARY KEY (id),
  INDEX requester_with_status (requester_id, status_id),
  INDEX requestee_with_status (requestee_id, status_id)
);
*/

DROP TABLE IF EXISTS channel_members;
CREATE TABLE channel_members (
  id						int				not null	auto_increment,
  channel_id 				int				not null,
  user_id					int				not null,
  channel_member_role_id	tinyint			not null,
  currently_in				boolean			not null,
  last_seen					datetime		null,
  PRIMARY KEY (id),
  INDEX (channel_id),
  INDEX channel_and_user (channel_id, user_id),
  INDEX channel_and_currently_in (channel_id, currently_in),
  INDEX channel_and_channel_member_role (channel_id, channel_member_role_id),
  INDEX channel_and_currently_in_and_channel_member_role (channel_id, currently_in, channel_member_role_id),
  INDEX user_and_currently_in (user_id, currently_in),
  INDEX channel_member_role_and_currently_in (channel_member_role_id, currently_in),
  INDEX (currently_in),
  INDEX user_and_last_seen (user_id, last_seen)
);

DROP TABLE IF EXISTS channel_member_roles;
CREATE TABLE channel_member_roles (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO channel_member_roles (name) VALUES ("Banned");
INSERT INTO channel_member_roles (name) VALUES ("Basic");
INSERT INTO channel_member_roles (name) VALUES ("Invited");
INSERT INTO channel_member_roles (name) VALUES ("Op");
INSERT INTO channel_member_roles (name) VALUES ("Founder");
INSERT INTO channel_member_roles (name) VALUES ("Admin");

/*
DROP TABLE IF EXISTS channel_mergers;
CREATE TABLE channel_mergers (
  id				int				not null	auto_increment,
  requester_id		int				not null,
  requestee_id		int				not null,
  status_id			tinyint				not null,
  PRIMARY KEY (id),
  INDEX requester_with_status (requester_id, status_id),
  INDEX requestee_with_status (requestee_id, status_id)
);
*/

DROP TABLE IF EXISTS channel_pictures;
CREATE TABLE channel_pictures (
  id					int					not null	auto_increment,
  channel_id			int					not null,
  content_type			varchar(255)		null,
  data					longblob			null,
  PRIMARY KEY (id),
  UNIQUE (channel_id)
);

DROP TABLE IF EXISTS channel_transcripts;
CREATE TABLE channel_transcripts (
  id					int				not null	auto_increment,
  created_at			datetime		not null,
  channel_id			int				not null,
  system_generated		boolean			not null,
  user_id				int				null,
  comment				varchar(255)	not null,
  PRIMARY KEY (id),
  INDEX (created_at),
  INDEX created_at_and_channel (created_at, channel_id),
  INDEX (channel_id)
);

DROP TABLE IF EXISTS event_listeners;
CREATE TABLE event_listeners (
  id						int				not null	auto_increment,
  created_at				datetime		not null,
  event_listener_type_id	tinyint			not null,
  channel_id				int				null,
  private_message_id		int				null,
  sending_user_id			int				null,
  receiving_user_id			int				null,
  status_id					tinyint			not null,  
  PRIMARY KEY (id),
  INDEX receiving_user_and_status (receiving_user_id, status_id)
);

DROP TABLE IF EXISTS event_listener_types;
CREATE TABLE event_listener_types (
  id			int				not null	auto_increment,
  name			varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO event_listener_types (name) VALUES ("Private Message");
INSERT INTO event_listener_types (name) VALUES ("Kick");
INSERT INTO event_listener_types (name) VALUES ("Flagged Out");

DROP TABLE IF EXISTS private_messages;
CREATE TABLE private_messages (
 id						int				not null	auto_increment,
 requester_id			int				not null,
 requestee_id			int				not null,
 status_id				tinyint			not null,
 PRIMARY KEY (id),
 INDEX requester_and_status (requester_id, status_id),
 INDEX requestee_and_status (requestee_id, status_id),
 INDEX requester_and_requestee (requester_id, requestee_id)
);

DROP TABLE IF EXISTS private_message_transcripts;
CREATE TABLE private_message_transcripts (
  id					int				not null	auto_increment,
  created_at			datetime		not null,
  private_message_id	int				not null,
  system_generated		boolean			not null,
  user_id				int				null,
  comment				varchar(255)	not null,
  PRIMARY KEY (id),
  INDEX (created_at),
  INDEX created_at_and_private_message (created_at, private_message_id),
  INDEX (private_message_id)
);

/*
DROP TABLE IF EXISTS meetings;
CREATE TABLE meetings (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  name				text			not null,
  title				text			null,
  description		text			null,
  channel_id		int				not null,
  event_date		date			not null,
  begin_time		time			not null,
  end_time			time			not null,
  frequency_id		int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS meeting_attendees;
CREATE TABLE meeting_attendees (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  meeting_id		int				not null,
  user_id			int				not null,
  required			boolean			not null,
  attended			boolean			null,
  status_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS meeting_frequencies;
CREATE TABLE meeting_frequencies (
  id				int				not null	auto_increment,
  name				text			not null,
  PRIMARY KEY (id)
);
INSERT INTO meeting_frequencies (name) VALUES ("once");
INSERT INTO meeting_frequencies (name) VALUES ("daily");
INSERT INTO meeting_frequencies (name) VALUES ("weekly");
INSERT INTO meeting_frequencies (name) VALUES ("monthly");

DROP TABLE IF EXISTS meeting_transcripts;
CREATE TABLE meeting_transcripts (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  meeting_id		int				not null,
  user_id			int				not null,
  comment			text			null,
  PRIMARY KEY (id)
);
*/

DROP TABLE IF EXISTS statuses;
CREATE TABLE statuses (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO statuses (name) VALUES ("Pending");
INSERT INTO statuses (name) VALUES ("Confirmed");
INSERT INTO statuses (name) VALUES ("Rejected");
INSERT INTO statuses (name) VALUES ("Suspended");
INSERT INTO statuses (name) VALUES ("Deleted");

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id								int				not null auto_increment,
  created_at						datetime		not null,
  name								varchar(20)		not null,
  user_type_id						tinyint			not null,
  email 							varchar(60)	 	not null,
  birthday							datetime		not null,
  hashed_password					char(40)		not null,
  user_profile_access_id			tinyint			not null,
  user_private_message_access_id	tinyint			not null,
  currently_on						boolean			not null,
  last_seen							datetime		not null,
  first_name 						varchar(20)		null,
  last_name							varchar(20)		null,
  zipcode							varchar(10)		null,
  status_id							tinyint			not null,
  PRIMARY KEY (id),
  UNIQUE (name),
  UNIQUE (email),
  INDEX (user_type_id),
  INDEX (currently_on),
  INDEX user_type_and_currently_on (user_type_id, currently_on),
  INDEX currently_on_and_last_seen (currently_on, last_seen)
);

DROP TABLE IF EXISTS user_types;
CREATE TABLE user_types (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO user_types (name) VALUES ("Guest");
INSERT INTO user_types (name) VALUES ("Registered User");
INSERT INTO user_types (name) VALUES ("System Admin"); 

DROP TABLE IF EXISTS user_profile_accesses;
CREATE TABLE user_profile_accesses (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO user_profile_accesses (name) VALUES ("Public");
INSERT INTO user_profile_accesses (name) VALUES ("Private");

DROP TABLE IF EXISTS user_private_message_accesses;
CREATE TABLE user_private_message_accesses (
  id				int				not null	auto_increment,
  name				varchar(20)		not null,
  PRIMARY KEY (id)
);
INSERT INTO user_private_message_accesses (name) VALUES ("On");
INSERT INTO user_private_message_accesses (name) VALUES ("Off");

DROP TABLE IF EXISTS user_flags;
CREATE TABLE user_flags (
  id					int				not null	auto_increment,
  created_at			datetime		not null,
  sending_user_id		int				not null,
  receiving_user_id		int				not null,
  reason				varchar(255)	not null,
  PRIMARY KEY (id),
  INDEX created_at_and_receiving_user (created_at, receiving_user_id),
  INDEX (receiving_user_id)
);

DROP TABLE IF EXISTS user_pictures;
CREATE TABLE user_pictures (
  id					int					not null	auto_increment,
  user_id				int					not null,
  content_type			varchar(255)		null,
  data					longblob			null,
  thumbnail				longblob			null,
  PRIMARY KEY (id),
  UNIQUE (user_id)
);