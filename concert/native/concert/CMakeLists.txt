cmake_minimum_required(VERSION 3.18)
project(concert)

set(CMAKE_CXX_STANDARD 17)
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

if (MSVC)
    set(CMAKE_CXX_FLAGS "/utf-8")
endif ()

add_subdirectory(third_party/otthat_bit7z)
add_subdirectory(third_party/otthat_libsodium)

add_library(${PROJECT_NAME} SHARED)

file(GLOB_RECURSE src CONFIGURE_DEPENDS src/*.cpp include/*.h)
target_sources(${PROJECT_NAME} PRIVATE ${src})
target_include_directories(${PROJECT_NAME} PRIVATE "include")

target_link_libraries(${PROJECT_NAME} PRIVATE bit7z)
target_link_libraries(${PROJECT_NAME} PRIVATE libsodium)

if (TARGET_PLATFORM STREQUAL "android")
    target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/libs/android/${ANDROID_ABI}/lib7z.so")
endif ()

# 如果是windows, 则安装 concert.dll & 7z.dll 到 flutter windows 产出目录
if (TARGET_PLATFORM STREQUAL "windows")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/$<$<CONFIG:DEBUG>:Debug>$<$<CONFIG:RELEASE>:Release>")
    install(FILES "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/concert.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/libs/windows/x86_64/7z.dll" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}" COMPONENT Runtime)
endif ()

if (TARGET_PLATFORM STREQUAL "test")
    file(GLOB_RECURSE test CONFIGURE_DEPENDS test/*.cpp)
    foreach (file ${test})
        get_filename_component(name ${file} NAME)

        add_executable("test-${name}" ${file} ${src})

        target_include_directories("test-${name}" PRIVATE "include")
        target_link_libraries("test-${name}" PRIVATE bit7z)
        target_link_libraries("test-${name}" PRIVATE libsodium)
    endforeach ()
endif ()
