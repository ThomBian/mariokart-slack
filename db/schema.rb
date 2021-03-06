# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_01_165732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "status", default: "draft", null: false
    t.index ["status"], name: "index_games_on_status"
  end

  create_table "games_players", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "player_id"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "elo_diff"
    t.index ["game_id", "player_id"], name: "index_games_players_on_game_id_and_player_id", unique: true
    t.index ["game_id"], name: "index_games_players_on_game_id"
    t.index ["player_id"], name: "index_games_players_on_player_id"
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
    t.index ["username"], name: "index_players_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "games_players_id"
    t.bigint "game_id"
    t.integer "voted_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "correct", default: false
    t.index ["game_id"], name: "index_votes_on_game_id"
    t.index ["games_players_id", "voted_by_id"], name: "index_votes_on_games_players_id_and_voted_by_id", unique: true
    t.index ["games_players_id"], name: "index_votes_on_games_players_id"
  end

end
