#   D2Lang.rb
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

module D2Lang
  extend FFI::Library
  ffi_lib "D2Lang.dll"
  ffi_convention :fastcall

  attach_function :free, "10000", [], :void # ()
  attach_function :get_used_language, "10001", [], :uint # ()
end
