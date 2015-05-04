add_executable (client clientTCP.c)
target_link_libraries (client LINK_PUBLIC protocol)
target_link_libraries (client LINK_PUBLIC protocolQ)
