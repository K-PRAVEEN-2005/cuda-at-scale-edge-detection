# Makefile for CUDA at Scale — Batch Image Edge Detection

NVCC        := nvcc
TARGET      := bin/edge_detect
SRC         := src/main.cu
INCLUDES    := -Iinclude

# Adjust -arch to match your GPU's compute capability if needed
# (sm_75 = Turing, sm_86 = Ampere, sm_89 = Ada, etc.)
ARCH        := -arch=sm_75

CXXSTD      := -std=c++17
NVCC_FLAGS  := $(CXXSTD) $(ARCH) -O2 $(INCLUDES)
LDFLAGS     := -lstdc++fs

.PHONY: all clean run sample-data

all: $(TARGET)

$(TARGET): $(SRC)
	@mkdir -p bin
	$(NVCC) $(NVCC_FLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

sample-data:
	python3 scripts/generate_sample_data.py

run: $(TARGET)
	./$(TARGET) --input data/input --output data/output --verbose

clean:
	rm -rf bin data/output/*.png
