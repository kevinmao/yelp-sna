CXX = g++

CXXFLAGS := -O3 -pthread -std=c++0x -march=native -mtune=native -funroll-loops -Wall -I/usr/include -L/usr/lib64 -lboost_thread-mt -lboost_system-mt -lboost_program_options-mt -fopenmp -Wl,-rpath,/home/y/lib64 

SHVER = 1

# run `make clean all' if you change the following flags.

# comment the following flag if you do not want to use SSE
DFLAG = -DUSESSE

# uncomment the following flags if you want to use AVX
#DFLAG = -DUSEAVX
#CXXFLAGS += -mavx

# uncomment the following flags if you do not want to use OpenMP
DFLAG += -DUSEOMP
CXXFLAGS += -fopenmp

all: mf-train mf-predict

lib: 
	$(CXX) -shared -Wl,-soname,libmf.so.$(SHVER) -o libmf.so.$(SHVER) mf.o 

mf-train: mf-train.cpp mf.o
	$(CXX) $(CXXFLAGS) $(DFLAG) -o $@ $^

mf-predict: mf-predict.cpp mf.o
	$(CXX) $(CXXFLAGS) $(DFLAG) -o $@ $^

mf.o: mf.cpp mf.h
	$(CXX) $(CXXFLAGS) $(DFLAG) -c -fPIC -o $@ $<

clean:
	rm -f mf-train mf-predict mf.o libmf.so.$(SHVER)
