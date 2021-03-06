#   Storm.rb
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

module Storm
  extend FFI::Library
  ffi_lib SCRIPT_DIR + "/Storm.dll"
  ffi_convention :stdcall

  attach_function :open_archive, "266", [:string, :uint, :uint, :pointer], :uint # (LPCSTR lpFileName, DWORD dwPriority, DWORD dwFlags, HANDLE *hMPQ)
  attach_function :close_archive, "252", [:pointer], :uint, {:convention => :fastcall}
  # SRegLoadString(char *keyname, char *valuename, int a3, char *buffer, size_t buffersize)
  # SRegLoadValue(char *keyname, char *valuename, int a3, int* value)
  attach_function :reg_load_string, "422", [:string, :string, :uint, :buffer_out, :uint], :uint
  attach_function :reg_load_value, "423", [:string, :string, :uint, :buffer_out], :uint
end
