#include "../../common/TCP/fonctionsTCP.h"
#include "../../common/protocolQuixo.h"

#define TAIL_BUF 50
int main(int argc, char **argv) {

	char buffer[TAIL_BUF];   /* buffer */
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
	
	TypPartieReq initialPartie;
	initialPartie.idRequest = PARTIE;
	initialPartie.nomJoueur = "Houriez-Spaseski";

	/*
	 * envoi de la requete initial
	 */
	//err = send(sock, chaine, strlen(chaine) + 1, 0);
	err = send(sock, initialPartie, sizeof(TypPartieReq), 0);
	if (err <= 0) {
	//if (err != strlen(chaine)+1) {
		perror("client : erreur sur le send");
		shutdown(sock, 2); close(sock);
		exit(3);
	}
	
	/*
	 * reponse de la requete initial
	 */
	err = recv(sock, buffer, TAIL_BUF, 0);
	if (err < 0) {
		perror("client: erreur dans la reception");
		shutdown(sock, 2); close(sock);
		return -7;
	}
	
	printf("%s\n",buffer);
	
  
	/* 
	 * fermeture de la connexion et de la socket 
	 */
	shutdown(sock, 2);
	close(sock);
	
	return 0;

}
