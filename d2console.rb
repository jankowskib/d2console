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

require_relative 'd2consts'
require_relative 'd2structs'

# Setup external functions
require_relative 'bindings/Storm' # preload our hacked storm 1st
Dir.chdir "D:\\Gry\\Diablo II (1.13d org)\\"
require_all SCRIPT_DIR + '/bindings'

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

def launch_game
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
      init_gfx($hinstance, VIDEO_MODE_GDI, D2TRUE, D2TRUE)
    puts "Creating a window..."
    begin
    raise D2Error, "Failed to create a window" unless D2Win.
      create_window($client_data[:window_mode], RESOLUTION_640_480)
    D2Sound.init($client_data[:expansion], D2FALSE)
      query_interface = D2Launch.query_interface
      query_interface[:launch].call($client_data)

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
  launch_game
end
