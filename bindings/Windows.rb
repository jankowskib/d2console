#   Windows.rb
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

module Windows
  extend FFI::Library
  ffi_lib 'kernel32'
  ffi_convention :stdcall
  attach_function :load_library, "LoadLibraryA", [:string], :ulong
  attach_function :load_library_ex, "LoadLibraryExA", [:string, :pointer, :uint32], :ulong
  attach_function :disable_thread_library_calls, "DisableThreadLibraryCalls", [:pointer], :ulong
  attach_function :get_proc_address, "GetProcAddress", [:ulong, :string], :pointer
  attach_function :free_library, "FreeLibrary", [:pointer], :uint32
  attach_function :open_event, "OpenEventA", [:uint, :uint32, :string], :pointer
  attach_function :set_event, "SetEvent", [:pointer], :uint32
  attach_function :close_handle, "CloseHandle", [:pointer], :uint32
  attach_function :get_module_handle, "GetModuleHandleA", [:string], :pointer
end
