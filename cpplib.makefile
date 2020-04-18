
LIBNAME = name
TESTNAME = try

IDIR = .
ODIR = obj

OBJS = $(patsubst %.cpp, $(ODIR)/%.o, $(wildcard *.cpp))
DEPS = $(wildcard $(IDIR)/*.h)

CXX = g++
CXXFLAGS = -I$(IDIR)

$(ODIR)/lib$(LIBNAME).a: $(OBJS)
	ar -rcs $(ODIR)/lib$(LIBNAME).a $?

obj/%.o: %.cpp $(DEPS)
	@mkdir -p $(ODIR)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

$(TESTNAME): $(OBJS)
	$(CXX) -o $(TESTNAME) $(TESTNAME).cpp -L$(ODIR) -l$(LIBNAME) (CXXFLAGS)
