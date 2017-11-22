DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
  id					int				not null	auto_increment,
  created_at			datetime		null,
  updated_at			datetime		null,
  name					text			null,
  title					text			null,
  description			text			null,
  private				int			not null,
  invite_only			int			not null,
  moderated				int			not null,
  allow_guests			int			not null,
  temporary				int			not null,
  channel_category_id	int				null,
  status_id				int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_categories;
CREATE TABLE channel_categories (
  id				int				not null	auto_increment,
  name				text			not null,
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
  created_at		datetime		null,
  updated_at		datetime		null,
  channel_id		int				not null,
  user_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_flags;
CREATE TABLE channel_flags (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  user_id			int				not null,
  channel_id		int				null,
  reason			text			null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_friendships;
CREATE TABLE channel_friendships (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  requester_id		int				not null,
  requestee_id		int				not null,
  status_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_members;
CREATE TABLE channel_members (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  channel_id 		int				not null,
  user_id			int				not null,
  founder			int			not null,
  op				int			not null,
  voiced			int			not null,
  banned			int			not null,
  invited			int			not null,
  currently_in		int			not null,
  last_seen			datetime		null,
  last_comment		datetime		null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_mergers;
CREATE TABLE channel_mergers (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  requester_id		int				not null,
  requestee_id		int				not null,
  status_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_pictures;
CREATE TABLE channel_pictures (
  id					int				not null	auto_increment,
  created_at			datetime		null,
  updated_at			datetime		null,
  name					text			null,
  description			text			null,
  content_type			text			null,
  data					blob			null,
  channel_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_relationships;
CREATE TABLE channel_relationships (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  parent_id			int				not null,
  child_id			int				not null,
  status_id			int				not null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS channel_transcripts;
CREATE TABLE channel_transcripts (
  id				int				not null	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  channel_id		int				not null,
  user_id			int				not null,
  comment			text			null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS event_listeners;
CREATE TABLE event_listeners (
  id					int				not null	auto_increment,
  created_at			datetime		null,
  updated_at			datetime		null,
  first_channel_id		int				null,
  second_channel_id		int				null,
  first_user_id			int				null,
  second_user_id		int				null,
  status_id				int				not null,  
  PRIMARY KEY (id)
);


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
  required			int			not null,
  attended			int			null,
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

DROP TABLE IF EXISTS statuses;
CREATE TABLE statuses (
  id				int				not null	auto_increment,
  name				text			not null,
  PRIMARY KEY (id)
);
INSERT INTO statuses (name) VALUES ("pending");
INSERT INTO statuses (name) VALUES ("confirmed");
INSERT INTO statuses (name) VALUES ("rejected");
INSERT INTO statuses (name) VALUES ("deleted");

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id				int				not null 	auto_increment,
  created_at		datetime		null,
  updated_at		datetime		null,
  name				varchar(20)		not null,
  guest				int			not null,
  email 			text		 	null,
  hashed_password	char(40)		null,
  first_name 		text			null,
  last_name			text			null,
  birthday			datetime		null,
  zipcode			varchar(10)		null,
  blurb				text			null,
  last_seen			datetime		null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS user_flags;
CREATE TABLE user_flags (
  id						int				not null	auto_increment,
  created_at				datetime		null,
  updated_at				datetime		null,
  user_id					int				not null,
  recipient_user_id			int				null,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS user_pictures;
CREATE TABLE user_pictures (
  id					int				not null	auto_increment,
  created_at			datetime		null,
  updated_at			datetime		null,
  name					text			null,
  description			text			null,
  content_type			text			null,
  data					blob			null,
  user_id				int				not null,
  PRIMARY KEY (id)
);