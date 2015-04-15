/*
 **********************************************************
 *
 *  Bibliotheque : fonctionsTCP.c
 *
 *  resume :    regrouper les fonction de connection TCP serveur/client
 *
 *  date :      21 / 01 / 15
 *
 ***********************************************************
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <unistd.h>

#define ushort unsigned short


int socketServeur(ushort nbPort);

int socketClient(char* nomMachine, ushort nbPort);
