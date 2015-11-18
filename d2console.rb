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

require_relative 'd2consts.rb'
require_relative 'd2structs.rb'

Dir.chdir "D:\\Gry\\Diablo II (1.13d org)\\"

module Windows
  extend FFI::Library
  ffi_lib 'kernel32'

  attach_function :load_library, "LoadLibraryA", [:string], :ulong
  attach_function :get_proc_address, "GetProcAddress", [:ulong, :string], :pointer
  attach_function :free_library, "FreeLibrary", [:pointer], :uint32
  attach_function :open_event, "OpenEventA", [:uint, :uint32, :string], :pointer
  attach_function :set_event, "SetEvent", [:pointer], :uint32
  attach_function :close_handle, "CloseHandle", [:pointer], :uint32
  attach_function :get_module_handle, "GetModuleHandleA", [:string], :pointer
end

module Fog
  extend FFI::Library
  ffi_lib "Fog.dll"
  ffi_convention :fastcall

  # EXFUNCPTR(FOG, SetErrorHandler, void, __fastcall, (const char* szApp, void* fnCallback, const char* szVersion, BOOL bAddInfo), -10019)
  # EXFUNCPTR(FOG, SetLogPrefix, void, __fastcall, (const char* szPrefix), -10021)
  # EXFUNCPTR(FOG, SetFileOptions, void, __fastcall, (BOOL bDirect, BOOL bQuickSeek), -10101)
  # EXFUNCPTR(FOG, SetAsyncData, void, __fastcall, (BOOL bState), -10089)
  # EXFUNCPTR(FOG, InitUnk_10218, void, __fastcall, (void), -10218)
  # EXFUNCPTR(FOG, CleanupAsyncData, BOOL, __fastcall, (void), -10090)
  # EXFUNCPTR(FOG, CleanupPools, void, __cdecl, (D2PoolManager *pPoolManager), -10143)
  # EXFUNCPTR(FOG, IsErrorState, BOOL, __fastcall, (void), -10039)
  # EXFUNCPTR(FOG, ErrorRescue, void, __fastcall, (void), -10040)
  # EXFUNCPTR(FOG, SetServerParams, void, __stdcall, (void * pParams), -10185)

  callback :error_handler_cb, [], :void

  attach_function :set_error_handler, "10019", [:string, :error_handler_cb, :string, :uint], :void # void (const char* szApp, void* fnCallback, const char* szVersion, BOOL bAddInfo)
  attach_function :set_log_prefix, "10021", [:string], :void # void (const char* szPrefix)
  attach_function :is_error_state, "10039", [], :uint # BOOL ()
  attach_function :error_rescue, "10040", [], :void # void ()
  attach_function :set_async_data, "10089", [:uint], :void # void (BOOL bState)
  attach_function :free_async_data, "10090", [], :uint # BOOL ()
  attach_function :set_file_options, "10101", [:uint, :uint], :void # void (BOOL bDirect, BOOL bQuickSeek)
  attach_function :free_pools, "10143", [:pointer], :void, {:convention => :stdcall} # void (D2PoolManager*)
  attach_function :set_server_params, "10185", [:pointer], :void, {:convention => :stdcall} # void (void* pParams)
  attach_function :init, "10218", [], :void # void ()
  attach_function :is_expansion, "10227", [], :bool
end

module Storm
  extend FFI::Library
  ffi_lib "Storm.dll"
  ffi_convention :stdcall
  # DLL_KEYWORD BOOL __stdcall SFileOpenArchive(LPCSTR lpFileName, DWORD dwPriority, DWORD dwFlags, HANDLE *hMPQ); // @266
  # DLL_KEYWORD BOOL __fastcall SFileCloseArchive(HANDLE hMPQ);  // @252

  attach_function :open_archive, "266", [:string, :uint, :uint, :pointer], :uint # (LPCSTR lpFileName, DWORD dwPriority, DWORD dwFlags, HANDLE *hMPQ)
  attach_function :close_archive, "252", [:pointer], :uint, {:convention => :fastcall}
end

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

$client_data = ClientData.new
$hinstance = Windows.get_module_handle(NULLPTR)
DIRECT = D2FALSE

TrueCallback = Proc.new { D2TRUE }

class D2Error < StandardError
end

class D2Critical < StandardError
end

def setup_game
  Fog.set_log_prefix("D2")
  Fog.set_error_handler("Diablo II", NULLPTR, "v1.13d", D2TRUE)
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
  rescue D2Error => e
    D2Win.unload_mpqs
    raise D2Critical, e
  end
  $client_data[:expansion] = Fog.is_expansion ? D2TRUE : D2FALSE

  puts "Initing GFX..."
  raise D2Critical, "Failed to init gfx system" unless D2Win.
    init_gfx($hinstance, VIDEO_MODE_GDI, D2TRUE, D2TRUE)
  puts "Creating a window..."
  raise D2Critical, "Failed to create a window" unless D2Win.
    create_window($client_data[:window_mode], RESOLUTION_640_480)
end

begin
setup_game
launch_game

end
