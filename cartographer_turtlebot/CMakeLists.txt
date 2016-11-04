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

project(cartographer_turtlebot)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=corei7 -std=c++0x") 
set(PACKAGE_DEPENDENCIES
  roscpp
  sensor_msgs
)

find_package(Cartographer REQUIRED)
find_package(catkin REQUIRED COMPONENTS ${PACKAGE_DEPENDENCIES})

catkin_package(CATKIN_DEPENDS message_runtime ${PACKAGE_DEPENDENCIES})

add_executable(cartographer_flat_world_imu_node ${PROJECT_NAME}/flat_world_imu_node_main.cc)
target_link_libraries(cartographer_flat_world_imu_node ${catkin_LIBRARIES} ${CARTOGRAPHER_LIBRARIES})

install(TARGETS cartographer_flat_world_imu_node
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

install(DIRECTORY launch configuration_files
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)


