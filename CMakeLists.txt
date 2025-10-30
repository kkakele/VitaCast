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

set(VITA_APP_NAME "VitaCast")
set(VITA_TITLEID  "VCAST2000")
set(VITA_VERSION  "02.01")

# Versión COMPLETA con vita2d
add_executable(${PROJECT_NAME}
  main_complete.c
)

target_link_libraries(${PROJECT_NAME}
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

# Usar las macros oficiales con UNSAFE
vita_create_self(eboot.bin ${PROJECT_NAME} UNSAFE)
vita_create_vpk(${PROJECT_NAME}.vpk ${VITA_TITLEID} eboot.bin
  VERSION ${VITA_VERSION}
  NAME ${VITA_APP_NAME}
  FILE sce_sys/icon0.png sce_sys/icon0.png
  FILE sce_sys/livearea/contents/bg.png sce_sys/livearea/contents/bg.png
  FILE sce_sys/livearea/contents/bg0.png sce_sys/livearea/contents/bg0.png
  FILE sce_sys/livearea/contents/startup.png sce_sys/livearea/contents/startup.png
  FILE sce_sys/livearea/contents/template.xml sce_sys/livearea/contents/template.xml
)
