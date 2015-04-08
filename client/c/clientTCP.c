#include "fonctionsTCP.h"

#define TAIL_BUF 50
int main(int argc, char **argv) {

	char chaine[TAIL_BUF];   /* buffer */
	int sock,                /* descripteur de la socket locale */
	    port,                /* variables de lecture */
	    err;                 /* code d'erreur */
	char* nomMachine;
	
	/* verification des arguments */
  	if (argc != 3) {
   		printf("usage : client nom_machine no_port\n");
		exit(1);
	}
  
	nomMachine = argv[1];
	port = atoi(argv[2]);
	
	sock = socketClient(nomMachine,port);
	
	printf("client : donner une chaine : ");
	scanf("%s", chaine);
	printf("client : envoi de - %s - \n", chaine);

	int i; 
	for(i=0 ; i<1000 ; i++) {
    
		/*
		 * envoi de la chaine
		 */
		//err = send(sock, chaine, strlen(chaine) + 1, 0);
		err = send(sock, chaine, TAIL_BUF, 0);
		if (err <= 0) {
		//if (err != strlen(chaine)+1) {
			perror("client : erreur sur le send");
			shutdown(sock, 2); close(sock);
			exit(3);
		}
		printf("client : envoi %d realise\n", i);
	}
  
	/* 
	 * fermeture de la connexion et de la socket 
	 */
	shutdown(sock, 2);
	close(sock);
	
	return 0;

}
