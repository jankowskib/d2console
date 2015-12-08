#   Fog.rb
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
