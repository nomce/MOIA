add_executable (SCS clientTCP.c)
target_link_libraries (SCS LINK_PUBLIC protocol)
target_link_libraries (SCS LINK_PUBLIC protocolQ)
