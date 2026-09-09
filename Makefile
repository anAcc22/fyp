CXX = g++
CXXFLAGS = -std=c++23 -O2 -Wall -Wextra -g -MMD -MP

SOURCES = $(wildcard src/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
DEPENDENCIES = $(OBJECTS:.o=.d)

main: $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJECTS)

clean:
	rm -f $(OBJECTS) $(DEPENDENCIES) main

.PHONY: clean

-include $(DEPENDENCIES)
