# Copyright (c) 2020-2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set(TBB_LINK_DEF_FILE_FLAG -Wl,-exported_symbols_list,)
set(TBB_DEF_FILE_PREFIX mac${TBB_ARCH})
set(TBB_WARNING_LEVEL -Wall -Wextra $<$<BOOL:${TBB_STRICT}>:-Werror>)
set(TBB_TEST_WARNING_FLAGS -Wshadow -Wcast-qual -Woverloaded-virtual -Wnon-virtual-dtor)
set(TBB_WARNING_SUPPRESS -Wno-parentheses -Wno-non-virtual-dtor -Wno-dangling-else)
# For correct ucontext.h structures layout
set(TBB_COMMON_COMPILE_FLAGS -D_XOPEN_SOURCE)

# Depfile options (e.g. -MD) are inserted automatically in some cases.
# Don't add -MMD to avoid conflicts in such cases.
if (NOT CMAKE_GENERATOR MATCHES "Ninja" AND NOT CMAKE_CXX_DEPENDS_USE_COMPILER)
    set(TBB_MMD_FLAG -MMD)
endif()

# Ignore -Werror set through add_compile_options() or added to CMAKE_CXX_FLAGS if TBB_STRICT is disabled.
if (NOT TBB_STRICT AND COMMAND tbb_remove_compile_flag)
    tbb_remove_compile_flag(-Werror)
endif()

if (NOT "${CMAKE_OSX_ARCHITECTURES}" MATCHES "^arm64$" AND CMAKE_SYSTEM_PROCESSOR STREQUAL x86_64)
    set(TBB_COMMON_COMPILE_FLAGS ${TBB_COMMON_COMPILE_FLAGS} -mrtm)
endif()

# TBB malloc settings
set(TBBMALLOC_LIB_COMPILE_FLAGS -fno-rtti -fno-exceptions)

