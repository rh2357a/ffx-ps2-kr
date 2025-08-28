ifeq ($(DEBUG), 1)
BUILD_TARGET := debug
else
BUILD_TARGET := release
endif

APP_NAME     := $(notdir $(CURDIR))
APP_FILENAME := $(APP_NAME).exe

SOURCE_DIR := src
BUILD_DIR  := build

BUILD_TARGET_DIR := $(BUILD_DIR)/$(BUILD_TARGET)
BUILD_OBJ_DIR    := $(BUILD_TARGET_DIR)/obj
TARGET           := $(BUILD_TARGET_DIR)/bin/$(APP_FILENAME)

################################################################################

CXX     := x86_64-w64-mingw32-g++

################################################################################

CXXFLAGS := -std=c++20 -fpermissive \
            -MMD -MP \
            -Wall -Wextra \
            -Wno-comment \
            -Wno-unused-parameter \
            -Wno-unused-variable \
            -Wno-unused-function

CXXDEFINES  := -DUNICODE -D_UNICODE
CXXINCLUDES := 

LDFLAGS := -static -static-libgcc -static-libstdc++ -lmsvcrt

ifeq ($(DEBUG), 1)
CXXFLAGS   += -g -O0
CXXDEFINES += -DDEBUG
else
CXXFLAGS   += -O3 -flto -ffunction-sections -fdata-sections
CXXDEFINES += -DRELEASE
LDFLAGS    += -s -Wl,--gc-sections
endif

################################################################################

SOURCES := $(shell find $(SOURCE_DIR) -type f -name "*.cpp")
OBJECTS := $(SOURCES:%.cpp=$(BUILD_OBJ_DIR)/%.o)
DEPS    := $(OBJECTS:.o=.d)

################################################################################

.PHONY: all clean $(DEPS)

all: $(TARGET)

$(TARGET): $(OBJECTS) $(DEPS)
	@mkdir -p $(BUILD_TARGET_DIR)
	@mkdir -p $(shell dirname $@)
	$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)

$(BUILD_OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(BUILD_TARGET_DIR)
	@mkdir -p $(shell dirname $@)
	$(CXX) $(CXXFLAGS) $(CXXDEFINES) $(CXXINCLUDES) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

-include $(DEPS)
