
LIBNAME = name

IDIR = .
ODIR = obj

OBJS = $(patsubst %.cpp, $(ODIR)/%.o, $(wildcard *.cpp))
DEPS = $(wildcard $(IDIR)/*.h)

CXX = g++
CXXFLAGS = -I$(IDIR)

$(ODIR)/lib$(LIBNAME).a: $(OBJS)
	ar -rcs $(ODIR)/lib.whacka $?

obj/%.o: %.cpp $(DEPS)
	@mkdir -p $(ODIR)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

try: $(OBJS)
	$(CXX) -o try try.cpp -L$(ODIR) -l$(LIBNAME) (CFLAGS)
