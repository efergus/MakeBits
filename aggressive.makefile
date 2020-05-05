#top down build - topmost directory is required by all things

#lib info
#	(can be user-controlled)
this = aggressive.makefile
lib_dir := lib
obj_dir := obj

#automatic info
directories = $(sort $(dir $(filter ./%/, $(wildcard ./*/))))
lib_q := $(filter-out ./$(obj_dir)/ ./$(lib_dir)/, $(directories))
lib_name := $(shell printf '%s' "$${PWD\#\#*/}")
lib_file := $(lib_dir)/lib$(lib_name).a #the archive file to create
lib_flags := -L$(lib_dir) $(patsubst $(lib_dir)/lib%.a, -l%, $(wildcard $(lib_dir)/lib*.a)) $(patsubst $(lib_dir)/lib%.so, -l%, $(wildcard $(lib_dir)/lib*.so))
objs := $(patsubst %.cpp, $(obj_dir)/%.o, $(wildcard *.cpp))
decs := $(wildcard ./*.h) $(wildcard ./*.hpp) #header files (declarations)
ifeq (,$(objs))
lib_file := 
lib_name := 
endif

#all child libs, and this lib, if they exist
$(lib_name): $(lib_q) $(lib_file)
.PHONY: $(lib_name)

#child libs
$(lib_q): $(lib_file)
	cp $(this) ./$@
	@make -C ./$@ -f $(this) lib_dir=../$(lib_dir) lib_deps="$(lib_name) $(lib_deps)" inc_dirs="$(patsubst %, ../%, $(inc_dirs)) ../" flags=$(flags)
.PHONY: $(lib_q)
#this lib
$(lib_file): $(objs)
	@rm -f $@
	@mkdir -p $(lib_dir)
	ar -rcs $@ $(objs)
#this lib's obj files
$(obj_dir)/%.o: %.cpp $(decs) $(patsubst %, $(lib_dir)/lib%.$(lib_ext), $(lib_deps))
	@mkdir -p $(obj_dir)
	@echo compile $< $(patsubst %, -l%, $(lib_deps))
	@$(CXX) -c -o $@ $< $(CXXFLAGS) -L$(lib_dir) $(patsubst %, -l%, $(lib_deps)) $(patsubst %, -I%, $(inc_dirs)) $(flags) -I.
#for compiling main c/cpp files
%: %.cpp $(deps)
	$(CXX) -o $@ $< $(CXXFLAGS) $(lib_flags) $(patsubst %, -I%, $(inc_dirs)) $(flags) -I.
%: %.c $(deps)
	$(CXX) -o $@ $< $(CXXFLAGS) $(lib_flags) $(patsubst %, -I%, $(inc_dirs)) $(flags) -I.