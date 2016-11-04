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

project(cartographer_ros)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=corei7 -std=c++0x") 

set(PACKAGE_DEPENDENCIES
  cartographer_ros_msgs
  gflags
  eigen_conversions
  geometry_msgs
  nav_msgs
  pcl_conversions
  roscpp
  rosbag
  sensor_msgs
  tf2
  tf2_eigen
  tf2_ros
  urdf
)

find_package(Cartographer REQUIRED)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CARTOGRAPHER_CMAKE_DIR}/modules)

find_package(catkin REQUIRED COMPONENTS ${PACKAGE_DEPENDENCIES})
find_package(PCL REQUIRED COMPONENTS common io)
find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED COMPONENTS system iostreams)
find_package(LuaGoogle REQUIRED)


include_directories(
  include
  ${EIGEN3_INCLUDE_DIR}
  ${CARTOGRAPHER_INCLUDE_DIR}
  ${LUA_INCLUDE_DIR}
  ${PCL_INCLUDE_DIRS} 
  ${catkin_INCLUDE_DIRS}
)

catkin_package(
  CATKIN_DEPENDS
  message_runtime
  ${PACKAGE_DEPENDENCIES}
)


#COMPILE LIBRARIES AND EXECUTABLES
add_library(assets_writer src/assets_writer.cc)
target_link_libraries(assets_writer 
  map_writer 
  node_options 
  occupancy_grid 
  ${catkin_LIBRARIES} 
  ${CARTOGRAPHER_LIBRARY}
)
add_library(map_writer src/map_writer.cc)
target_link_libraries(map_writer 
  yaml-cpp 
  ${catkin_LIBRARIES}
)
add_library(msg_conversion src/msg_conversion.cc)
target_link_libraries(msg_conversion 
  time_conversion 
  ${catkin_LIBRARIES} 
  ${CARTOGRAPHER_LIBRARIES} 
  ${PCL_LIBRARIES} 
  ${LUA_LIBRARIES}
)
add_library(node_options src/node_options.cc)
target_link_libraries(node_options 
  sensor_bridge 
  ${catkin_LIBRARIES}
)
add_library(occupancy_grid src/occupancy_grid.cc)
target_link_libraries(occupancy_grid 
  node_options 
  time_conversion 
  ${catkin_LIBRARIES}
)
add_library(ros_log_sink src/ros_log_sink.cc)
target_link_libraries(ros_log_sink 
  ${catkin_LIBRARIES}
)
add_library(sensor_bridge src/sensor_bridge.cc)
target_link_libraries(sensor_bridge 
  msg_conversion 
  tf_bridge 
  time_conversion 
  ${catkin_LIBRARIES}
)
add_library(tf_bridge src/tf_bridge.cc)
target_link_libraries(tf_bridge 
  msg_conversion 
  time_conversion 
  ${catkin_LIBRARIES}
)
add_library(time_conversion src/time_conversion.cc)
target_link_libraries(time_conversion 
  ${catkin_LIBRARIES} 
  ${CARTOGRAPHER_LIBRARIES}
)
add_executable(cartographer_assets_writer src/assets_writer_main.cc)
target_link_libraries(cartographer_assets_writer 
  msg_conversion 
  time_conversion 
  ${catkin_LIBRARIES} 
  ${CARTOGRAPHER_LIBRARIES}
)
add_executable(cartographer_node src/node_main.cc)
target_link_libraries(cartographer_node 
  assets_writer 
  msg_conversion 
  node_options 
  occupancy_grid 
  ros_log_sink 
  sensor_bridge 
  tf_bridge 
  time_conversion 
  ${catkin_LIBRARIES} 
  ${CARTOGRAPHER_LIBRARIES} 
  ${EIGEN3_LIBRARIES} 
  gflags
)


# TESTS 
catkin_add_gtest(time_conversion_test src/time_conversion_test.cc)

# INSTALL 
install(DIRECTORY launch urdf configuration_files
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(PROGRAMS scripts/tf_remove_frames.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(TARGETS cartographer_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(TARGETS cartographer_assets_writer
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
