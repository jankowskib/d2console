#   D2Multi.rb
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

module D2Multi
  extend FFI::Library
  ffi_lib "D2Multi.dll"
  ffi_convention :fastcall
  callback :launch_cb, [:pointer], :uint32

  class Interface < FFI::Struct
    layout :launch, :launch_cb
  end

  attach_function :query_interface, "QueryInterface", [], D2Multi::Interface.by_ref # ()
end
