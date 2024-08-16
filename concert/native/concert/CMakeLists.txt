cmake_minimum_required(VERSION 3.18)
project(concert)

set(CMAKE_CXX_STANDARD 17)
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}" CACHE STRING "INSTALL_BUNDLE_LIB_DIR")

# 当前构建架构
if (TARGET_PLATFORM STREQUAL "windows")
    option(IS_WINDOWS "IS_WINDOWS" ON)
elseif (TARGET_PLATFORM STREQUAL "android")
    option(IS_ANDROID "IS_ANDROID" ON)
elseif (TARGET_PLATFORM STREQUAL "test")
    option(IS_TEST "IS_TEST" ON)
else ()
    message(FATAL_ERROR "Unknown Platform")
endif ()

# 将源字符集和执行字符集设置为 UTF-8
if (MSVC)
    set(CMAKE_CXX_FLAGS "/utf-8")
endif ()

# 添加子项目
add_subdirectory(third_party/otthat_bit7z)
add_subdirectory(third_party/otthat_libsodium)
add_subdirectory(third_party/otthat_7zip)

add_library(${PROJECT_NAME} SHARED)

file(GLOB_RECURSE src CONFIGURE_DEPENDS src/*.cpp include/*.h)
target_sources(${PROJECT_NAME} PRIVATE ${src})
target_include_directories(${PROJECT_NAME} PRIVATE "include")

target_link_libraries(${PROJECT_NAME} PRIVATE bit7z libsodium)
if (IS_ANDROID)
    target_link_libraries(${PROJECT_NAME} PRIVATE 7zip)
endif ()

if (IS_WINDOWS)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:DEBUG>:Debug>$<$<CONFIG:RELEASE>:Release>")
    install(FILES "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/concert.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}")
endif ()

if (IS_TEST)
    file(GLOB_RECURSE test CONFIGURE_DEPENDS test/*.cpp)
    foreach (file ${test})
        get_filename_component(name ${file} NAME)

        add_executable("test-${name}" ${file} ${src})

        target_include_directories("test-${name}" PRIVATE "include")
        target_link_libraries("test-${name}" PRIVATE bit7z)
        target_link_libraries("test-${name}" PRIVATE libsodium)
    endforeach ()
endif ()
