#!/bin/zsh

build() {
    echo "Building the application..."
    xcrun -sdk macosx metal -c add.metal -o add.air
    xcrun -sdk macosx metallib add.air -o add.metallib
    xxd -i add.metallib > add_metallib.h
    clang -c -o main.o main.m
    clang -c -o MetalAdder.o MetalAdder.m
    clang -o main -framework Foundation -framework metal -framework CoreGraphics -framework MetalKit main.o MetalAdder.o
}

run() {
    echo "Running main..."
    ./main
}

clean() {
    echo "cleaning..."
    rm add.air add.metallib add_metallib.h main.o MetalAdder.o main
    echo "cleaning finished"
}

# Check for command-line arguments
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [build|run|clean]"
    exit 1
fi

# Execute the specified command
case "$1" in
    "run")
        run
        ;;
    "clean")
        clean
        ;;
    "build")
        build
        ;;
    *)
        echo "Unknown command: $1"
        echo "Usage: $0 [build|run|clean]"
        exit 1
        ;;
esac
