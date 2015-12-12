#!/usr/bin/env ruby
#   d2console.rb
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
require 'win32/registry'
require 'colorize'
require 'require_all'
require 'thread'

require_relative 'd2consts'
require_relative 'd2structs'

# Setup external functions
require_relative 'bindings/Storm' # preload our hacked storm 1st
Dir.chdir "D:\\Gry\\Diablo II (1.13d org)\\"
require_relative SCRIPT_DIR + '/bindings/Fog'
require_relative SCRIPT_DIR + '/bindings/D2Sound'
require_relative SCRIPT_DIR + '/bindings/D2Lang'
require_relative SCRIPT_DIR + '/bindings/D2Gfx'
require_relative SCRIPT_DIR + '/bindings/D2Win'
require_relative SCRIPT_DIR + '/bindings/Windows'

$client_data = ClientData.new
$hinstance = Windows.get_module_handle(NULLPTR)
DIRECT = D2FALSE

TrueCallback = Proc.new { D2TRUE }
ErrorCallback = FFI::Function.new(:void, []) do
  raise D2Critical, "An critical error occured!"
end

class D2Error < StandardError
end

class D2Critical < StandardError
end

# Basic setup for the game, the event stuff is not necessary at all
# I left it just in case
def setup_game
  Fog.set_log_prefix("D2")
  Fog.set_error_handler("Diablo II", ErrorCallback, "v1.13d", D2TRUE)
  event = Windows.open_event(2, D2TRUE, "DIABLO_II_OK")
  if event
    Windows.set_event(event)
    Windows.close_handle(event)
  end
  $client_data[:mpq_callback] = TrueCallback # just return a true
  $client_data[:window_mode] = D2TRUE # temporary force to window module
end

# returns a query interface for requested game mode
# @param mode one of GAME_MODE
# @return Interface function table [result of QueryInteface(ClientData*)]
# @raise D2Critical if mode is unknown
def get_game_mode_fn(mode)
  case mode
  when GameMode[:launcher]
     require_relative SCRIPT_DIR + '/bindings/D2Launch'
     return D2Launch.query_interface
  when GameMode[:client]
     require_relative SCRIPT_DIR + '/bindings/D2Client'
     return D2Client.query_interface
  when GameMode[:multiplayer]
    require_relative SCRIPT_DIR + '/bindings/D2Multi'
    return D2Multi.query_interface
  else
    raise D2Critical, "Unknown game mode: " << mode
  end
end


# Loads MPQs, and start DLL's QueryInterface() functions
def main_thread
  Fog.set_file_options(DIRECT, D2FALSE)
  Fog.set_async_data(D2TRUE)
  Fog.init
  begin
    puts "Loading MPQs..."
    raise D2Error, "Failed to load key MPQs!" unless D2Win.load_mpqs
    raise D2Error, "Failed to load additional MPQs!" unless D2Win.
      load_media_mpqs(NULLPTR, NULLPTR, 0, $client_data)
    $client_data[:expansion] = Fog.is_expansion ? D2TRUE : D2FALSE
    puts "Initing GFX..."
    raise D2Error, "Failed to init gfx system" unless D2Win.
      init_gfx($hinstance, VideoMode[:gdi], D2TRUE, D2TRUE)
    puts "Creating a window..."
    begin
      raise D2Error, "Failed to create a window" unless D2Win.
      create_window($client_data[:window_mode], GameRes[:res_640x480])
      if $client_data[:no_sound] == 0
        puts "Initing sound system..."
        D2Sound.init($client_data[:expansion], D2FALSE)
      end
      game_mode = GameMode[:launcher]
      loop do
        puts "Entering the game mode: #{GameMode.key(game_mode)}"
        query_interface = get_game_mode_fn(game_mode)
        game_mode = query_interface[:launch].call($client_data)
        break if game_mode == GameMode[:none]
      end
      if $client_data[:no_sound] == 0
        puts "Shutting down the sound system..."
        D2Sound.shutdown
      end
      puts "Shutting down the GFX..."
      D2Win.deinit_gfx
      D2Gfx.release
      puts "Unloading the MPQs..."
      D2Win.unload_mpqs

    rescue D2Error => e
      puts "GFX deinit"
      D2Gfx.release
      raise e
    end
  rescue D2Error => e
    puts "MPQ deinit"
    D2Win.unload_mpqs
    raise e
  end
end

begin
  setup_game
  main_thread

  # return to previous directory
  Dir.chdir SCRIPT_DIR
end
