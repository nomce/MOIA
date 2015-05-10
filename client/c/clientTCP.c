#include "../../common/TCP/fonctionsTCP.h"
#include "../../common/protocolQuixo.h"
#include "validation.h"

#define TAIL_BUF 50
int main(int argc, char **argv) {

	int sock,                /* descripteur de la socket locale */
		sockJava,
		portJava,
	    port;                /* variables de lecture */
	ssize_t err;             /* code d'erreur */
	char* nomMachine;

	/* verification des arguments */
  	if (argc != 5) {
   		printf("usage : client nom_machine no_port nom_joueur javaPort\n");
		exit(1);
	}

	nomMachine = argv[1];
	port = atoi(argv[2]);

	sock = socketClient(nomMachine,port);
	sockJava = socketClient("localhost",atoi(argv[4]));

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
		perror("client : erreur sur l'envoi");
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

	/*
	 * java send sign
	 */

	uint16_t javaSign = (uint16_t) htons(reponseInitial.signe);

	err = send(sockJava, &javaSign, sizeof(uint16_t), 0);
	if (err < 0) {
		perror("client: erreur sur l'envoi");
		shutdown(sockJava, 2); close(sockJava);
		return -7;
	}

	printf("Sign: %d \n",reponseInitial.signe);

	TypCoupReq coup;
	TypCoupReq coupAdv;
	TypCoupRep validCoup;
	TypCoupRep validCoupAdv;
	int nombreCoup = 0;
	if (reponseInitial.signe == ROND){
		coup.idRequest = COUP;
		coup.signeCube = reponseInitial.signe;
		coup.propCoup = DEPL_CUBE;

		// reception du validite
		err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
		if (err < 0) {
			perror("client: erreur dans le reponse du IA");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}
		javaSign = (uint16_t)  ntohs(javaSign);
		printf("Valid: %d\n",javaSign);

		//test du validite
		if (javaSign == 0){

			//reception du coup (case depart)
			err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
			if (err < 0) {
				perror("client: erreur dans le reponse du IA");
				shutdown(sockJava, 2); close(sockJava);
				return -7;
			}
			javaSign = (uint16_t)  ntohs(javaSign);
			printf("Dep: %d\n",javaSign);

			//test du validite
			if (javaSign > 0 && javaSign < 26){
				//reception du coup (case arrivee)
				coup.deplCube.caseDepCube = javaSign;
				err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
				if (err < 0) {
					perror("client: erreur dans le reponse du IA");
					shutdown(sockJava, 2); close(sockJava);
					return -7;
				}
				javaSign = (uint16_t)  ntohs(javaSign);
				printf("Arr: %d\n",javaSign);

				//test du validite
				if (javaSign > 0 && javaSign < 26){
					coup.deplCube.caseArrCube = javaSign;
				}else{
					perror("client: erreur dans le reponse du IA");
					shutdown(sockJava, 2); close(sockJava);
					return -7;
				}
			}else{
				perror("client: erreur dans le reponse du IA");
				shutdown(sockJava, 2); close(sockJava);
				return -7;
			}
		}else{
			perror("client: erreur dans le reponse du IA");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}

		err = send(sock, &coup, sizeof(TypCoupReq), 0);
		if (err <= 0) {
			perror("client : erreur sur le send");
			shutdown(sock, 2); close(sock);
			exit(3);
		}
		/*
	 	* reponse de la requete initial
	 	*/
		err = recv(sock, &validCoup, sizeof(TypCoupRep), 0);
		if (err < 0) {
			perror("client: erreur dans la reception");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		if (validCoup.err != ERR_OK || validCoup.validCoup != VALID){
			perror("client: erreur dans la validation du coup");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		nombreCoup++;
		printf("%d\n",validCoup.validCoup);

	}

	do{
		printf("NbCoup: %d\n",nombreCoup);
		//reception du validation du coup d'adversaire
		err = recv(sock, &validCoupAdv, sizeof(TypCoupRep), 0);
		if (err < 0) {
			perror("client: erreur dans la reception\n");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		printf("err: %d,  validcoup: %d\n",validCoupAdv.err,validCoupAdv.validCoup);

		if (validCoupAdv.err != ERR_OK || validCoupAdv.validCoup != VALID){
			perror("client: erreur dans la validation du coup\n");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		//reception du coup d'adversaire
		err = recv(sock, &coupAdv, sizeof(TypCoupReq), 0);
		if (err < 0) {
			perror("client: erreur dans la reception\n");
			shutdown(sock, 2); close(sock);
			return -7;
		}

		nombreCoup++;

		//consuler IA
		printf("IADep: %d",coupAdv.deplCube.caseDepCube);
		javaSign = (uint16_t)  htons(coupAdv.deplCube.caseDepCube);
		err = send(sockJava, &javaSign, sizeof(uint16_t), 0);
		if (err < 0) {
			perror("client: erreur sur l'envoi");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}

		printf(" IAArr: %d\n",coupAdv.deplCube.caseArrCube);
		javaSign = (uint16_t)  htons(coupAdv.deplCube.caseArrCube);
		err = send(sockJava, &javaSign, sizeof(uint16_t), 0);
		if (err < 0) {
			perror("client: erreur sur l'envoi");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}

		coup.idRequest = COUP;
		coup.signeCube = reponseInitial.signe;
		printf("Reception IA:\n");
		// reception du validite
		err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
		if (err < 0) {
			perror("client: erreur dans le reponse du IA");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}
		javaSign = (uint16_t)  ntohs(javaSign);
		printf("Val: %d", javaSign);
		//test du validite
		if (javaSign >= 0 && javaSign < 4){

			coup.propCoup = DEPL_CUBE;
			switch(javaSign){
				case 0: coup.propCoup = DEPL_CUBE; break;
				case 1: coup.propCoup = GAGNANT; break;
				case 2: coup.propCoup = NULLE; break;
				case 3: coup.propCoup = PERDU;
			}

			//reception du coup (case depart)
			err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
			if (err < 0) {
				perror("client: erreur dans le reponse du IA");
				shutdown(sockJava, 2); close(sockJava);
				return -7;
			}
			javaSign = (uint16_t)  ntohs(javaSign);
			printf(" Dep: %d", javaSign);

			//test du validite
			if (javaSign > 0 && javaSign < 26){

				//reception du coup (case arrivee)
				coup.deplCube.caseDepCube = javaSign;
				err = recv(sockJava, &javaSign, sizeof(uint16_t), 0);
				if (err < 0) {
					perror("client: erreur dans le reponse du IA");
					shutdown(sockJava, 2); close(sockJava);
					return -7;
				}
				javaSign = (uint16_t)  ntohs(javaSign);
				printf(" Arr: %d\n", javaSign);

				//test du validite
				if (javaSign > 0 && javaSign < 26){
					coup.deplCube.caseArrCube = javaSign;
				}else{
					perror("client: erreur dans le reponse du IA");
					shutdown(sockJava, 2); close(sockJava);
					return -7;
				}
			}else{
				perror("client: erreur dans le reponse du IA");
				shutdown(sockJava, 2); close(sockJava);
				return -7;
			}
		}else{
			perror("client: erreur dans le reponse du IA");
			shutdown(sockJava, 2); close(sockJava);
			return -7;
		}


		coup.idRequest = COUP;
		coup.signeCube = reponseInitial.signe;
		coup.propCoup = DEPL_CUBE;

		err = send(sock, &coup, sizeof(TypCoupReq), 0);
		if (err < 0) {
			perror("client : erreur sur le send\n");
			shutdown(sock, 2); close(sock);
			exit(3);
		}

		//validationCoup(0, coup);

		printf("Test avant, nb %d, coupAdv: %d, coup: %d \n",nombreCoup, validCoupAdv.validCoup, validCoup.validCoup);

	}while(nombreCoup <=25 && validCoupAdv.validCoup == 0);

	printf("Test apres \n");

	/* 
	 * fermeture de la connexion et de la socket 
	 */
	shutdown(sock, 2);
	shutdown(sockJava, 2);
	close(sock);
	close(sockJava);

	return 0;

}
