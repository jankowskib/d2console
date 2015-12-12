#   d2consts.rb
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

SCRIPT_DIR = File.dirname(__FILE__)

# Just to be pretty
D2TRUE = 1
D2FALSE = 0
NULLPTR = nil

# Video modes
VideoMode = {
  :gdi => 1,
  :software => 2,
  :ddraw => 3,
  :glide => 4,
  :opengl => 5, # UNUSED
  :d3d => 6,
  :rave => 7 # UNUSED
}

GameRes = {
  :res_640x480 => 0,
  :res_800x600 => 2
}

GameMode = {
  :none => 0x0,
  :client => 0x1,
  :server => 0x2,
  :multiplayer => 0x3,
  :launcher => 0x4,
  :expand => 0x5
}
