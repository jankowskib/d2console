#   D2Sound.rb
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

module D2Sound
  extend FFI::Library
  ffi_lib "D2Sound.dll"
  ffi_convention :fastcall

  attach_function :init, "10023", [:uint, :uint], :void # (BOOL bExpansion, BOOL bSoundBackground)
  attach_function :shutdown, "10024", [], :void # ()
end
