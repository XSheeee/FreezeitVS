cmake_minimum_required(VERSION 3.14...3.22)

# ---- Project ----

project(
  FreezeitVS
  VERSION 1.4
  LANGUAGES CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

# ---- FreezeitVS subproject ----
add_subdirectory(FreezeitVS)

# ---- Magisk module ----
ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/update.json
    COMMAND ${CMAKE_COMMAND} 
      -DOUTPUT_FILE=${CMAKE_CURRENT_BINARY_DIR}/update.json 
      -DINPUT_FILE=${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/magisk/module.prop 
      -P ${CMAKE_CURRENT_SOURCE_DIR}/version.cmake
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/magisk/module.prop
)

file(GLOB_RECURSE module_files
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/magisk/*
)

# check if apk file exists in magisk directory.
foreach(file ${module_files})
  if(file MATCHES ".*\\.apk$")
    set(has_apk 1)
    break()
  else()
    set(has_apk 0)
  endif()
endforeach()
if(has_apk EQUAL 0)
  message(WARNING "No .apk file found in FreezeitVS/magisk! Do you forget adding the apk file?")
endif()

list(APPEND module_files
  $<TARGET_FILE:${PROJECT_NAME}>
  ${CMAKE_CURRENT_SOURCE_DIR}/README.md
  ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/changelog.md
  ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/changelogFull.txt
  ${CMAKE_CURRENT_BINARY_DIR}/update.json
)

set(release_dir ${CMAKE_CURRENT_BINARY_DIR}/release)

set(output_files 
  ${release_dir}/module.zip
  ${release_dir}/README.md
  ${release_dir}/changelog.md
  ${release_dir}/changelogFull.txt
  ${release_dir}/update.json
)

add_custom_command(
  OUTPUT ${output_files}

  # remove old release directory
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${release_dir}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${release_dir}/magisk/
  # copy files to release magisk directory
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/magisk/ ${release_dir}/magisk/
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${PROJECT_NAME}> ${release_dir}/magisk/freezeit
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/changelog.md ${release_dir}/magisk/
  # compress magisk module
  COMMAND ${CMAKE_COMMAND} -E chdir ${release_dir}/magisk/ ${CMAKE_COMMAND} -E tar cf ${release_dir}/module.zip --format=zip -- .
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${release_dir}/magisk/
  # copy other files to release directory
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/README.md ${release_dir}/
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/changelog.md ${release_dir}/
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/FreezeitVS/changelogFull.txt ${release_dir}/
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/update.json ${release_dir}/
  DEPENDS ${module_files}
  COMMENT "Creating Magisk module"
)

add_custom_target(
  magisk_module ALL
  DEPENDS ${release_dir}/module.zip
)