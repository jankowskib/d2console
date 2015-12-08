#   D2Win.rb
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

module D2Win
  extend FFI::Library
  ffi_lib "D2Win.dll"
  ffi_convention :stdcall

  # EXFUNCPTR(D2WIN, LoadMPQs, BOOL, __stdcall, (void), -10174)
	# EXFUNCPTR(D2WIN, LoadExpansionMPQs, BOOL, __stdcall, (int*, int*, BOOL, BnetData*), -10072)
	# EXFUNCPTR(D2WIN, InitGFX, BOOL, __stdcall, (HINSTANCE hInstance, int nDriver, BOOL bWindowed, BOOL bGFXCompress), -10071) // Not used?
	# EXFUNCPTR(D2WIN, CreateWindow, BOOL, __stdcall, (BOOL bWindowed, int nMode), -10129)
	# EXFUNCPTR(D2WIN, DeinitGFX, BOOL, __stdcall, (void), -10132)
	# EXFUNCPTR(D2WIN, UnloadMPQs, void, __stdcall, (void), -10079)

  attach_function :init_gfx, "10071", [:pointer, :uint, :uint, :uint], :uint # (HINSTANCE hInstance, int nDriver, BOOL bWindowed, BOOL bGFXCompress)
  attach_function :load_media_mpqs, "10072", [:pointer, :pointer, :uint, :pointer], :uint, {:convention => :fastcall}
  attach_function :unload_mpqs, "10079", [], :void
  attach_function :create_window, "10129", [:uint, :uint], :uint # (BOOL bWindowed, int ResoulutionMode),
  attach_function :deinit_gfx, "10132", [], :uint
  attach_function :load_mpqs, "10174", [], :uint
end
