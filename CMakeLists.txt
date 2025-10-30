cmake_minimum_required(VERSION 2.8)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  if(DEFINED ENV{VITASDK})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VITASDK}/share/vita.toolchain.cmake" CACHE PATH "toolchain file")
  else()
    message(FATAL_ERROR "Please define VITASDK to point to your SDK path!")
  endif()
endif()

project(VitaCast)
include("${VITASDK}/share/vita.cmake" REQUIRED)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu11 -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(VITA_APP_NAME "VitaCast")
set(VITA_TITLEID  "VCAST2000")
set(VITA_VERSION  "02.01")

add_executable(${PROJECT_NAME}.elf
  main_complete.c
)

target_link_libraries(${PROJECT_NAME}.elf
  vita2d
  freetype
  png
  jpeg
  z
  m
  c
  SceDisplay_stub
  SceGxm_stub
  SceSysmodule_stub
  SceCtrl_stub
  SceCommonDialog_stub
  SceAppMgr_stub
  SceAudio_stub
  ScePgf_stub
  SceLibKernel_stub
  curl
  ssl
  crypto
  SceNet_stub
  SceNetCtl_stub
  SceSsl_stub
  SceHttp_stub
)

# Crear VELF desde ELF
add_custom_target(${PROJECT_NAME}.velf ALL
  COMMAND vita-elf-create ${PROJECT_NAME}.elf ${PROJECT_NAME}.velf
  DEPENDS ${PROJECT_NAME}.elf
)

# Crear param.sfo
add_custom_target(param.sfo ALL
  COMMAND vita-mksfoex -s TITLE_ID=${VITA_TITLEID} -s APP_VER=${VITA_VERSION} "${VITA_APP_NAME}" param.sfo
)

# Crear VPK
add_custom_target(${PROJECT_NAME}.vpk ALL
  COMMAND vita-make-fself -s -c ${PROJECT_NAME}.velf eboot.bin
  COMMAND vita-pack-vpk -s param.sfo -b eboot.bin
          --add ${CMAKE_SOURCE_DIR}/sce_sys/icon0.png=sce_sys/icon0.png
          --add ${CMAKE_SOURCE_DIR}/sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png
          --add ${CMAKE_SOURCE_DIR}/sce_sys/livearea/contents/bg0.png=sce_sys/livearea/contents/bg0.png
          --add ${CMAKE_SOURCE_DIR}/sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png
          --add ${CMAKE_SOURCE_DIR}/sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml
          ${PROJECT_NAME}.vpk
  DEPENDS ${PROJECT_NAME}.velf param.sfo
)
