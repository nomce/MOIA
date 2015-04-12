# Create a library called "Hello" which includes the source file "hello.cxx".
# The extension is already found. Any number of sources could be listed here.
add_library (protocolQ protocolQuixo.h)


set_target_properties(protocolQ PROPERTIES LINKER_LANGUAGE C)

# Make sure the compiler can find include files for our Hello library
# when other libraries or executables link to Hello
#target_include_directories (SCS PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(TCP)
