#include "../../common/TCP/fonctionsTCP.h"
#include "../../common/protocolQuixo.h"

#define TAIL_BUF 50
int main(int argc, char **argv) {

	int sock,                /* descripteur de la socket locale */
	    port;                /* variables de lecture */
	ssize_t err;             /* code d'erreur */
	char* nomMachine;

	/* verification des arguments */
  	if (argc != 4) {
   		printf("usage : client nom_machine no_port nom_joueur\n");
		exit(1);
	}

	nomMachine = argv[1];
	port = atoi(argv[2]);

	sock = socketClient(nomMachine,port);

	TypPartieReq initialPartie;
	initialPartie.idRequest = PARTIE;
	int i;
	for (i = 0; i < strlen(argv[3]);i++){
		initialPartie.nomJoueur[i] = argv[3][i];
	}

	/*
	 * envoi de la requete initial
	 */
	err = send(sock, &initialPartie, sizeof(TypPartieReq), 0);
	if (err <= 0) {
		perror("client : erreur sur le send");
		shutdown(sock, 2); close(sock);
		exit(3);
	}
	TypPartieRep reponseInitial;
	/*
	 * reponse de la requete initial
	 */
	err = recv(sock, &reponseInitial, sizeof(TypPartieRep), 0);
	if (err < 0) {
		perror("client: erreur dans la reception");
		shutdown(sock, 2); close(sock);
		return -7;
	}

	printf("%d \n",reponseInitial.signe);
	TypCoupReq coup;
	TypCoupReq coupAdv;
	TypCoupRep validationCoup;
	TypCoupRep validationCoupAdv;
	int nombreCoup = 0;
	if (reponseInitial.signe == ROND){
		//consuler IA
		coup.idRequest = COUP;
		coup.signeCube = reponseInitial.signe;
		coup.propCoup = DEPL_CUBE;
		coup.deplCube.caseDepCube = 1;
		coup.deplCube.caseArrCube = 5;

		err = send(sock, &coup, sizeof(TypCoupReq), 0);
		if (err <= 0) {
			perror("client : erreur sur le send");
			shutdown(sock, 2); close(sock);
			exit(3);
		}
		/*
	 	* reponse de la requete initial
	 	*/
		err = recv(sock, &validationCoup, sizeof(TypCoupRep), 0);
		if (err < 0) {
			perror("client: erreur dans la reception");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		if (validationCoup.err != ERR_OK || validationCoup.validCoup != VALID){
			perror("client: erreur dans la validation du coup");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		nombreCoup++;
		printf("%d\n",validationCoup.validCoup);

	}

	do{

		err = recv(sock, &validationCoupAdv, sizeof(TypCoupRep), 0);
		if (err < 0) {
			perror("client: erreur dans la reception");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		if (validationCoupAdv.err != ERR_OK || validationCoupAdv.validCoup != VALID){
			perror("client: erreur dans la validation du coup");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		err = recv(sock, &coupAdv, sizeof(TypCoupReq), 0);
		if (err < 0) {
			perror("client: erreur dans la reception");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		nombreCoup++;

		//consuler IA
		coup.idRequest = COUP;
		coup.signeCube = reponseInitial.signe;
		coup.propCoup = DEPL_CUBE;
		coup.deplCube.caseDepCube = 1;
		coup.deplCube.caseArrCube = 5;

		err = send(sock, &coup, sizeof(TypCoupReq), 0);
		if (err <= 0) {
			perror("client : erreur sur le send");
			shutdown(sock, 2); close(sock);
			exit(3);
		}

	}while(nombreCoup <=50 && validationCoupAdv.validCoup == 0 && validationCoup.validCoup == 0);

	/* 
	 * fermeture de la connexion et de la socket 
	 */
	shutdown(sock, 2);
	close(sock);

	return 0;

}
