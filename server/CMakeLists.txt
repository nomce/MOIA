add_executable (server serverTCP.c validation.o)


target_link_libraries (server LINK_PUBLIC protocol)
target_link_libraries (server LINK_PUBLIC protocolQ)
