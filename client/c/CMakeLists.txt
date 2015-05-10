add_executable (client clientTCP.c validation.o)
target_link_libraries (client LINK_PUBLIC protocol)
target_link_libraries (client LINK_PUBLIC protocolQ)
