cmake_minimum_required(VERSION 3.16)

# Project configuration
set(QGC_APP_NAME "BDA-Lab" CACHE STRING "Application name")
set(QGC_APP_VERSION "1.0.0" CACHE STRING "Application version") 
set(QGC_APP_DESCRIPTION "BDA Lab Ground Control Station" CACHE STRING "Application description")
set(QGC_ORG_DOMAIN "saiprasad-tech.github.io" CACHE STRING "Organization domain")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configuration types" FORCE)
endif()

project(${QGC_APP_NAME}
    VERSION ${QGC_APP_VERSION}
    DESCRIPTION ${QGC_APP_DESCRIPTION}
    HOMEPAGE_URL "https://${QGC_ORG_DOMAIN}"
    LANGUAGES C CXX
)

# CMake configuration
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt6 components
find_package(Qt6 6.5 REQUIRED COMPONENTS
    Core
    Quick
    QuickControls2
    Widgets
)

qt_standard_project_setup()

# Create executable
qt_add_executable(${CMAKE_PROJECT_NAME}
    src/main.cpp
)

# Create QML module
qt_add_qml_module(${CMAKE_PROJECT_NAME}
    URI ${CMAKE_PROJECT_NAME}
    VERSION 1.0
    QML_FILES
        qml/main.qml
        qml/theme/Theme.qml
    RESOURCES
        resources/fonts/dummy.txt
)

# Set target properties
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.saiprasadtech.${CMAKE_PROJECT_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Link Qt libraries
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE 
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
)

# Install rules
install(TARGETS ${CMAKE_PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)