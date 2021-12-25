# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_23_143313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "name"
    t.string "emoji"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "status", default: "draft", null: false
    t.bigint "season_id"
    t.index ["season_id"], name: "index_games_on_season_id"
    t.index ["status"], name: "index_games_on_status"
  end

  create_table "games_players", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "player_id"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "elo_diff"
    t.float "odd"
    t.index ["game_id", "player_id"], name: "index_games_players_on_game_id_and_player_id", unique: true
    t.index ["game_id"], name: "index_games_players_on_game_id"
    t.index ["player_id"], name: "index_games_players_on_player_id"
  end

  create_table "money_options", force: :cascade do |t|
    t.text "title"
    t.integer "value"
    t.float "price"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.text "username", null: false
    t.integer "elo", default: 1000
    t.integer "highest_elo"
    t.integer "lowest_elo"
    t.text "small_avatar_url"
    t.datetime "small_avatar_url_last_set_at"
    t.text "display_name"
    t.datetime "display_name_last_set_at"
    t.boolean "active", default: true
    t.float "money", default: 50.0
    t.text "medium_avatar_url"
    t.datetime "medium_avatar_url_last_set_at"
    t.datetime "last_free_money_added_at"
    t.bigint "user_id"
    t.text "real_name"
    t.index ["user_id"], name: "index_players_on_user_id"
    t.index ["username"], name: "index_players_on_username", unique: true
  end

  create_table "players_achievements", force: :cascade do |t|
    t.bigint "achievement_id"
    t.bigint "player_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "season_id"
    t.index ["achievement_id"], name: "index_players_achievements_on_achievement_id"
    t.index ["player_id"], name: "index_players_achievements_on_player_id"
    t.index ["season_id"], name: "index_players_achievements_on_season_id"
  end

  create_table "players_money_options", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "money_option_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["money_option_id"], name: "index_players_money_options_on_money_option_id"
    t.index ["player_id"], name: "index_players_money_options_on_player_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.boolean "is_current", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "games_players_id"
    t.bigint "game_id"
    t.integer "voted_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "correct", default: false
    t.float "bet"
    t.index ["game_id"], name: "index_votes_on_game_id"
    t.index ["games_players_id", "voted_by_id"], name: "index_votes_on_games_players_id_and_voted_by_id", unique: true
    t.index ["games_players_id"], name: "index_votes_on_games_players_id"
  end

end
