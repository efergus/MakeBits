
LIB_NAME := $(shell printf '%s' '$${PWD\#\#*/}')
LIBS_REQUIRED = 
LIB_Q = test
LIB_DIR = lib
OBJ_DIR = obj

LIB_DIR := $(shell pwd)/$(LIB_DIR)
OBJS = $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(wildcard *.cpp))
DECS = $(wildcard $(IDIR)/*.h)
#DIRECTORY = $(sort $(dir $(filter ./%/, $(wildcard ./*/))))

lib: $(LIB_DIR)/lib$(LIB_NAME).a $(LIB_Q)
.PHONY: lib

$(LIB_Q):
	make -C ./$@ LIB_DIR=$(LIB_DIR)
.PHONY: libtile

$(LIB_DIR)/lib$(LIB_NAME).a: $(OBJS)
	rm -f $@
	@mkdir -p $(LIB_DIR)
	ar -rcs $@ $(OBJS)
.PHONY: lib

$(OBJ_DIR)/%.o: %.cpp $(DECS) $(patsubst %, $(LIB_DIR)/lib%.a, $(LIBS_REQUIRED))
	@mkdir -p $(OBJ_DIR)
	$(CXX) -c -o $@ $< $(CXXFLAGS) -L$(LIB_DIR) $(patsubst %, -l%, $(LIBS_REQUIRED))


test_make:
	@echo $(LIB_NAME)
.PHONY: test

FORCE: