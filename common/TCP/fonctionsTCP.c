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

 /* inclusions standards */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <errno.h>
#include <unistd.h>

/* inclusions socket */
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#include "fonctionsTCP.h"

int socketServeur(ushort nbPort){
	int  sockConx,          /* descripteur socket connexion */
	sizeAddr,        	/* taille de l'adresse d'une socket */
	err;	        	/* code d'erreur */
  
	struct sockaddr_in nomConnecte;	/* adresse de la sochet connectee*/

	sizeAddr = sizeof(struct sockaddr_in);
	  
	/* 
	 * creation de la socket, protocole TCP 
	 */
	sockConx = socket(AF_INET, SOCK_STREAM, 0);
	if (sockConx < 0) {
		perror("serveurTCP: erreur de socket\n");
		return -2;
	}
	  
	/* 
	 * initialisation de l'adresse de la socket 
	 */
	nomConnecte.sin_family = AF_INET;
	nomConnecte.sin_port = htons(nbPort); // conversion en format réseau (big endian)
	nomConnecte.sin_addr.s_addr = INADDR_ANY; 
	// INADDR_ANY : 0.0.0.0 (IPv4) donc htonl inutile ici, car pas d'effet
	bzero(nomConnecte.sin_zero, 8);
	  
	/* 
	 * attribution de l'adresse a la socket
	 */
	err = bind(sockConx, (struct sockaddr *)&nomConnecte, sizeAddr);
	if (err < 0) {
		perror("serveurTCP: erreur sur le bind");
		close(sockConx);
		return -3;
	}
	  
	/* 
	 * utilisation en socket de controle, puis attente de demandes de 
	 * connexion.
	 */
	err = listen(sockConx, 1);
	if (err < 0) {
		perror("serveurTCP: erreur dans listen");
		return -4;
	}

	return sockConx;
}

int socketClient(char* nomMachine, ushort nbPort){
	int sock,                /* descripteur de la socket locale */
	    err;                 /* code d'erreur */
  	struct hostent*    host; /* description de la machine serveur */
  	struct sockaddr_in nom;  /* adresse de la sochet du serveur */

  	int size_addr_in = sizeof(struct sockaddr_in);

	/* 
	 * creation d'une socket, domaine AF_INET, protocole TCP 
	 */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock < 0) {
		perror("client : erreur sur la creation de socket");
		return -1;
	}
	  
	/* 
	 * initialisation de l'adresse de la socket 
	*/
	nom.sin_family = AF_INET;
	bzero(nom.sin_zero, 8);
	nom.sin_port = htons(nbPort);
	
	/* recherche de l'adresse de la machine */
	host = gethostbyname (nomMachine);
	if (host == NULL) {   
		printf("client : erreur gethostbyname %d\n", errno);
		return -2;
	}
	  
	/* recopie de l'adresse IP */
	nom.sin_addr.s_addr = ((struct in_addr *) (host->h_addr_list[0]))->s_addr;
						     
	/* 
	 * connection au serveur 
	 */
	err = connect(sock, (struct sockaddr *)&nom, size_addr_in);
	if (err < 0) {
		perror("client : erreur a la connection de socket\n");
		return -3;
	}

	return sock;
}
