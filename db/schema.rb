# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110408191237) do

  create_table "comments", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "post_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["poster_id"], :name => "index_comments_on_poster_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject"
    t.integer  "c_sender_id"
    t.integer  "c_recipient_id"
    t.integer  "c_recipient2_id"
    t.boolean  "c_sender_del",    :default => false
    t.boolean  "c_recipient_del", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
  end

  add_index "conversations", ["c_recipient2_id"], :name => "index_conversations_on_c_recipient2_id"
  add_index "conversations", ["c_recipient_id"], :name => "index_conversations_on_c_recipient_id"
  add_index "conversations", ["c_sender_id"], :name => "index_conversations_on_c_sender_id"

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["request_id"], :name => "index_friendships_on_request_id"
  add_index "friendships", ["user_id"], :name => "index_friendships_on_user_id"

  create_table "msgs", :force => true do |t|
    t.string   "content"
    t.integer  "conversation_id"
    t.integer  "sender_id"
    t.boolean  "c_sender_read",   :default => false
    t.boolean  "c_recip_read",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "msgs", ["conversation_id"], :name => "index_msgs_on_conversation_id"
  add_index "msgs", ["sender_id"], :name => "index_msgs_on_sender_id"

  create_table "posts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "poster_id"
  end

  add_index "posts", ["poster_id"], :name => "index_posts_on_poster_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "requests", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["recipient_id"], :name => "index_requests_on_recipient_id"
  add_index "requests", ["sender_id"], :name => "index_requests_on_sender_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "salt"
    t.string   "encrypted_password"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
    t.boolean  "admin",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "change_password",    :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_id"], :name => "index_users_on_invitation_id"

end
