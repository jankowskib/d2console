#   d2structs.rb
#   Copyright 2015 Bartosz Jankowski
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

require 'ffi'

# size must be 0x3C8
class ClientData < FFI::Struct
  pack 1
  layout  :expansion, :uint32,
          :window_mode, :uint8,
          :fix_aspect_ratio, :uint8,
          :glide_mode, :uint8,
          :opengl_mode, :uint8,
          :rave_mode, :uint8,
          :d3d_mode, :uint8,
          :perspective, :uint8,
          :low_quality, :uint8,
          :gamma, :uint32,
          :vsync, :uint8,
          :frame_rate, :uint32,
          :join_id, :uint16,
          :game_name, [:char, 24],
          :game_ip, [:char, 24],
          :bnet_ip, [:char, 24],
          :mcp_ip, [:char, 24],
          :unk1, :uint32,
          :no_pk, :uint8,
          :open_c, :uint8,
          :amazon, :uint8,
          :paladin, :uint8,
          :sorceress, :uint8,
          :necromancer, :uint8,
          :barbarian, :uint8,
          :unk2, :uint8,
          :unk3, :uint8,
          :invincible, :uint8,
          :account_name, [:char, 48],
          :player_name, [:char, 24],
          :realm_name, [:char, 27],
          :c_temp, :uint16, 0x1E9,
          :char_flags, :uint16,
          :no_monsters, :uint8,
          :monster_class, :uint32,
          :monster_info, :uint8,
          :monster_debug, :uint32,
          :item_rare, :uint8,
          :item_unique, :uint8,
          :act, :uint32, 0x1FB,
          :no_preload, :uint8,
          :direct, :uint8,
          :low_end, :uint8,
          :no_gfx_compress, :uint8,
          :arena, :uint32,
          :mpq_callback, callback([], :bool), 0x20D,
          :txt, :uint8,
          :log, :uint8,
          :msg_log, :uint8,
          :safe_mode, :uint8,
          :no_save, :uint8,
          :seed, :uint32,
          :cheats, :uint8,
          :teen, :uint8,
          :no_sound, :uint8,
          :quests, :uint8,
          :unk4, :uint8,
          :build, :uint8,
          :sound_background, :uint8,
          :bnet_callbacks, :pointer,
          :game_pass, [:char, 24], 0x241,
          :skip_to_bnet, :uint8, 0x359,
          :unk5, :uint16, 0x3C6
end
