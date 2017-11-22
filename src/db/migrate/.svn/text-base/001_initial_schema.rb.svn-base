class InitialSchema < ActiveRecord::Migration
  
  def self.up
    
    create_table "channel_accesses" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "channel_categories" do |t|
      t.column "name", :string, :limit => 60, :default => "", :null => false
    end

    create_table "channel_favorites" do |t|
      t.column "channel_id", :integer, :default => 0, :null => false
      t.column "user_id",    :integer, :default => 0, :null => false
    end

    create_table "channel_flags" do |t|
      t.column "created_at", :datetime,                 :null => false
      t.column "user_id",    :integer,  :default => 0,  :null => false
      t.column "channel_id", :integer,  :default => 0,  :null => false
      t.column "reason",     :string,   :default => "", :null => false
    end

    create_table "channel_member_roles" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "channel_members" do |t|
      t.column "channel_id",             :integer,               :default => 0,     :null => false
      t.column "user_id",                :integer,               :default => 0,     :null => false
      t.column "channel_member_role_id", :integer,  :limit => 4, :default => 0,     :null => false
      t.column "currently_in",           :boolean,               :default => false, :null => false
      t.column "last_seen",              :datetime
    end

    create_table "channel_pictures" do |t|
      t.column "channel_id",   :integer, :default => 0, :null => false
      t.column "content_type", :string
      t.column "data",         :binary
    end

    create_table "channel_transcripts" do |t|
      t.column "created_at",       :datetime,                    :null => false
      t.column "channel_id",       :integer,  :default => 0,     :null => false
      t.column "system_generated", :boolean,  :default => false, :null => false
      t.column "user_id",          :integer
      t.column "comment",          :string,   :default => "",    :null => false
    end

    create_table "channels" do |t|
      t.column "created_at",          :datetime,                                :null => false
      t.column "name",                :string,   :limit => 20,  :default => "", :null => false
      t.column "topic",               :string,   :limit => 100, :default => "", :null => false
      t.column "description",         :string,                  :default => "", :null => false
      t.column "channel_access_id",   :integer,  :limit => 4,   :default => 0,  :null => false
      t.column "channel_category_id", :integer,  :limit => 4,   :default => 0,  :null => false
      t.column "parent_id",           :integer
      t.column "parent_status_id",    :integer,  :limit => 4
      t.column "status_id",           :integer,  :limit => 4,   :default => 0,  :null => false
    end

    create_table "event_listener_types" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "event_listeners" do |t|
      t.column "created_at",             :datetime,                             :null => false
      t.column "event_listener_type_id", :integer,  :limit => 4, :default => 0, :null => false
      t.column "channel_id",             :integer
      t.column "private_message_id",     :integer
      t.column "sending_user_id",        :integer
      t.column "receiving_user_id",      :integer
      t.column "status_id",              :integer,  :limit => 4, :default => 0, :null => false
    end

    create_table "private_message_transcripts" do |t|
      t.column "created_at",         :datetime,                    :null => false
      t.column "private_message_id", :integer,  :default => 0,     :null => false
      t.column "system_generated",   :boolean,  :default => false, :null => false
      t.column "user_id",            :integer
      t.column "comment",            :string,   :default => "",    :null => false
    end

    create_table "private_messages" do |t|
      t.column "requester_id", :integer,              :default => 0, :null => false
      t.column "requestee_id", :integer,              :default => 0, :null => false
      t.column "status_id",    :integer, :limit => 4, :default => 0, :null => false
    end

    create_table "sessions" do |t|
      t.column "session_id", :string
      t.column "data",       :text
      t.column "updated_at", :datetime
    end

    create_table "statuses" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "user_flags" do |t|
      t.column "created_at",        :datetime,                 :null => false
      t.column "sending_user_id",   :integer,  :default => 0,  :null => false
      t.column "receiving_user_id", :integer,  :default => 0,  :null => false
      t.column "reason",            :string,   :default => "", :null => false
    end

    create_table "user_pictures" do |t|
      t.column "user_id",      :integer, :default => 0, :null => false
      t.column "content_type", :string
      t.column "data",         :binary
    end

    create_table "user_private_message_accesses" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "user_profile_accesses" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "user_types" do |t|
      t.column "name", :string, :limit => 20, :default => "", :null => false
    end

    create_table "users" do |t|
      t.column "created_at",                     :datetime,                                  :null => false
      t.column "name",                           :string,   :limit => 20, :default => "",    :null => false
      t.column "user_type_id",                   :integer,  :limit => 4,  :default => 0,     :null => false
      t.column "email",                          :string,   :limit => 60, :default => "",    :null => false
      t.column "birthday",                       :datetime,                                  :null => false
      t.column "hashed_password",                :string,   :limit => 40, :default => "",    :null => false
      t.column "user_profile_access_id",         :integer,  :limit => 4,  :default => 0,     :null => false
      t.column "user_private_message_access_id", :integer,  :limit => 4,  :default => 0,     :null => false
      t.column "currently_on",                   :boolean,                :default => false, :null => false
      t.column "last_seen",                      :datetime,                                  :null => false
      t.column "first_name",                     :string,   :limit => 20
      t.column "last_name",                      :string,   :limit => 20
      t.column "zipcode",                        :string,   :limit => 10
      t.column "status_id",                      :integer,  :limit => 4,  :default => 2,     :null => false
    end

  end

  def self.down
    
    drop_table :channel_accesses
    drop_table :channel_categories
    drop_table :channel_favorites
    drop_table :channel_flags
    drop_table :channel_member_roles
    drop_table :channel_members
    drop_table :channel_pictures
    drop_table :channel_transcripts
    drop_table :channels
    drop_table :event_listener_types
    drop_table :event_listeners
    drop_table :private_message_transcripts
    drop_table :private_messages
    drop_table :sessions
    drop_table :statuses
    drop_table :user_flags
    drop_table :user_pictures
    drop_table :user_private_message_accesses
    drop_table :user_profile_accesses
    drop_table :user_types
    drop_table :users
    
  end

end
