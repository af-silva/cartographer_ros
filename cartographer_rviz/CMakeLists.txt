# Copyright 2016 The Cartographer Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 2.8.3)

project(cartographer_rviz)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=corei7 -std=c++0x") 
set(PACKAGE_DEPENDENCIES cartographer_ros_msgs eigen_conversions roscpp rviz)

find_package(Cartographer REQUIRED)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CARTOGRAPHER_CMAKE_DIR}/modules)

find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS system iostreams)
find_package(catkin REQUIRED COMPONENTS ${PACKAGE_DEPENDENCIES})

include_directories(
  ${EIGEN3_INCLUDE_DIR}
  ${CARTOGRAPHER_INCLUDE_DIR}
  ${PCL_INCLUDE_DIRS} 
  ${OGRE_INCLUDE_DIRS}
  ${catkin_INCLUDE_DIRS}
)

catkin_package(
  CATKIN_DEPENDS
    message_runtime
    ${PACKAGE_DEPENDENCIES}
  INCLUDE_DIRS src
)

set(CMAKE_AUTOMOC ON)
if(rviz_QT_VERSION VERSION_LESS "5")
  message(STATUS "Using Qt4 based on the rviz_QT_VERSION: ${rviz_QT_VERSION}")
  find_package(Qt4 ${rviz_QT_VERSION} EXACT REQUIRED QtCore QtGui)
  include_directories(${Qt4_INCLUDE_DIRS})
  include(${QT_USE_FILE})
else()
  message(STATUS "Using Qt5 based on the rviz_QT_VERSION: ${rviz_QT_VERSION}")
  find_package(Qt5 ${rviz_QT_VERSION} EXACT REQUIRED Core Widgets)
  find_package(Qt5Widgets REQUIRED)
  set(QT_LIBRARIES Qt5::Widgets)
  include_directories(${Qt5Widgets_INCLUDE_DIRS})
  include_directories(${Qt5_INCLUDE_DIRS})
endif()
add_definitions(-DQT_NO_KEYWORDS)

## Create an empty file for the shared library we require for RViz.
set(FILES
  src/drawable_submap.cc
  src/drawable_submap.h
  src/submaps_display.cc
  src/submaps_display.h
)

add_library(cartographer_rviz_submaps_visualization ${FILES})
target_link_libraries(cartographer_rviz_submaps_visualization
  ${QT_LIBRARIES}
  ${catkin_LIBRARIES}
  ${EIGEN3_LIBRARIES}
  ${CARTOGRAPHER_LIBRARIES}
  ${OGRE_LIBRARIES}
  ${BOOST_LIBRARIES}
  ${PCL_LIBRARIES}
)

install(TARGETS cartographer_rviz_submaps_visualization
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(FILES rviz_plugin_description.xml
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(DIRECTORY ogre_media
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
