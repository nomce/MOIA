#include "../common/TCP/fonctionsTCP.h"
#include "../common/protocolQuixo.h"
#include <errno.h>
#include <sys/ioctl.h>
#include <stdbool.h>
#include <bits/time.h>
#include <time.h>
#include "validation.h"

#define TAIL_BUF 250


int main(int argc, char** argv) {

	int  sockConx,        /* descripteur socket connexion */
			sockTransP1,  /* descripteur socket transmission player 1 */
			sockTransP2,  /* descripteur socket transmission player 1 */
			port,         /* numero de port */
			sizeAddr,     /* taille de l'adresse d'une socket */
			on = 0,
			tour = 1;
	ssize_t err;	      /* code d'erreur */
  
  	char buffer[TAIL_BUF]; /* buffer de reception */
  
  	struct sockaddr_in nomTransmis;	/* adresse socket de transmission */
	clock_t start, end;
	double cpu_time_used;
  
  
  	/*
 	 * verification des arguments
  	 */
  	if (argc != 2) {
   		printf ("usage : server no_port\n");
   		return -1;
  	}
  
  	port  = atoi(argv[1]);
  	sizeAddr = sizeof(struct sockaddr_in);
  	
  	sockConx = socketServeur(port);
  	
  	/*
   	* attente de connexion
   	*/
  	sockTransP1 = accept(sockConx,
		     (struct sockaddr *)&nomTransmis, 
		     (socklen_t *)&sizeAddr);
  	if (sockTransP1 < 0) {
   		perror("serveurTCP:  erreur sur accept");
    		return -5;
  	}
	err = ioctl(sockTransP1,FIONBIO,&on);
	if (err < 0){
		shutdown(sockTransP1, 2); close(sockTransP1);
		close(sockConx);
		return 0;
	}

	sockTransP2 = accept(sockConx,
						 (struct sockaddr *)&nomTransmis,
						 (socklen_t *)&sizeAddr);
	if (sockTransP2 < 0) {
		perror("serveurTCP:  erreur sur accept");
		return -5;
	}
	err = ioctl(sockTransP2,FIONBIO,&on);
	if (err < 0){
		shutdown(sockTransP1, 2); close(sockTransP1);
		shutdown(sockTransP2, 2); close(sockTransP2);
		close(sockConx);
		return 0;
	}

	/*
   	 * attente de joueurs
   	 */

	TypPartieReq* joueur1;
	TypPartieReq* joueur2;

	TypPartieRep reponse;

	while (!joueur1->nomJoueur || !joueur2->nomJoueur) {
		if (!joueur1->nomJoueur) {
			err = recv(sockTransP1, &joueur1, sizeof(TypPartieReq), 0);
			if (err > 0) {
				int i;
				for (i = 0; i < strlen(joueur1->nomJoueur); i++) {
					reponse.nomAdvers[i] = joueur1->nomJoueur[i];
				}
				reponse.signe = ROND;
				reponse.err = ERR_OK;
				err = send(sockTransP1, &reponse, sizeof(TypCoupRep), 0);
				if (err <= 0) {
					perror("server : erreur sur le recv joueur1");
					shutdown(sockTransP1, 2);
					close(sockTransP1);
					shutdown(sockTransP2, 2);
					close(sockTransP2);
					close(sockConx);
					return -1;
				}
			} else {
				if (err < 0 && errno == EWOULDBLOCK) {
					//printf(" Serveur : pas de message sur la socket\n ");
				} else {
					perror("serveurNB : erreur dans la reception 1");
					shutdown(sockTransP1, 2);
					close(sockTransP1);
					shutdown(sockTransP2, 2);
					close(sockTransP2);
					close(sockConx);
					return -1;
				}
			}
		}if (!joueur2->nomJoueur){
			err = recv(sockTransP2, &joueur2, sizeof(TypPartieReq), 0);
			if (err > 0){
				int i;
				for (i = 0; i < strlen(joueur2->nomJoueur);i++){
					reponse.nomAdvers[i] = joueur2->nomJoueur[i];
				}
				reponse.signe = CROIX;
				reponse.err = ERR_OK;
				err = send(sockTransP2, &reponse, sizeof(TypCoupRep), 0);
				if (err <= 0) {
					perror("server : erreur sur le recv joueur1");
					shutdown(sockTransP1, 2); close(sockTransP1);
					shutdown(sockTransP2, 2); close(sockTransP2);
					close(sockConx);
					return -1;
				}
			}else{
				if (err < 0 && errno == EWOULDBLOCK) {
					//printf(" Serveur : pas de message sur la socket\n ");
				}else{
					perror("serveurNB : erreur dans la reception 1");
					shutdown(sockTransP1, 2); close(sockTransP1);
					shutdown(sockTransP2, 2); close(sockTransP2);
					close(sockConx);
					return -1;
				}
			}
		}
	}

	printf("Connecte\n");

	TypCoupReq reponseCoup;
	TypCoupRep sendCoup;

	TypCube tabQuixo[5][5];
	int i,j;
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			tabQuixo[i][j] = VIDE;
		}
	}

	int x,y;
  	while(i < 50) {
		start = clock();
		if (tour){
			err = recv(sockTransP1, &reponseCoup, sizeof(TypCoupReq), 0);
			if (err > 0){
				//valider la deplacement, et valider la case de depart
				x = reponseCoup.deplCube.caseDepCube % 5;
				y = reponseCoup.deplCube.caseDepCube / 5;
				printf("Dep = %d, X = %d, Y = %d\n", reponseCoup.deplCube.caseDepCube, x, y);
				if (!validationCoup(0, reponseCoup) || tabQuixo[y][x] == CROIX) {
					sendCoup.validCoup = TRICHE;
					sendCoup.err = ERR_COUP;
					err = send(sockTransP1, &sendCoup, sizeof(TypCoupRep), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					break;
				}

				//verifier le temps passe
				end = clock();
				cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
				if (cpu_time_used >= 6) {
					sendCoup.validCoup = TIMEOUT;
					sendCoup.err = ERR_COUP;
					err = send(sockTransP1, &sendCoup, sizeof(TypCoupRep), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					break;
				}

				// le coup est valid, on continue
				sendCoup.validCoup = VALID;
				sendCoup.err = ERR_OK;
				err = send(sockTransP1, &sendCoup, sizeof(TypCoupRep), 0);
				if (err <= 0) {
					perror("server : erreur sur le recv joueur1");
					shutdown(sockTransP1, 2);
					close(sockTransP1);
					shutdown(sockTransP2, 2);
					close(sockTransP2);
					close(sockConx);
					return -1;
				}
				err = send(sockTransP2, &reponseCoup, sizeof(TypCoupReq), 0);
				if (err <= 0) {
					perror("server : erreur sur le recv joueur1");
					shutdown(sockTransP1, 2);
					close(sockTransP1);
					shutdown(sockTransP2, 2);
					close(sockTransP2);
					close(sockConx);
					return -1;
				}
				tour == 0;
			}else {
				if (err < 0 && errno == EWOULDBLOCK) {
					//printf(" Serveur : pas de message sur la socket\n ");
				} else {
					perror("serveurNB : erreur dans la reception 1");
					shutdown(sockTransP1, 2);
					close(sockTransP1);
					shutdown(sockTransP2, 2);
					close(sockTransP2);
					close(sockConx);
					return -1;
				}
			}
		}else{
			err = recv(sockTransP2, &reponseCoup, sizeof(TypCoupReq), 0);
			if (err > 0){
					//valider la deplacement, et valider la case de depart
					x = reponseCoup.deplCube.caseDepCube % 5;
					y = reponseCoup.deplCube.caseDepCube / 5;
					if (!validationCoup(0, reponseCoup) || tabQuixo[y][x] == ROND) {
						sendCoup.validCoup = TRICHE;
						sendCoup.err = ERR_COUP;
						err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
						if (err <= 0) {
							perror("server : erreur sur le recv joueur1");
							shutdown(sockTransP1, 2);
							close(sockTransP1);
							shutdown(sockTransP2, 2);
							close(sockTransP2);
							close(sockConx);
							return -1;
						}
						err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
						if (err <= 0) {
							perror("server : erreur sur le recv joueur1");
							shutdown(sockTransP1, 2);
							close(sockTransP1);
							shutdown(sockTransP2, 2);
							close(sockTransP2);
							close(sockConx);
							return -1;
						}
						break;
					}

					//verifier le temps passe
					end = clock();
					cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
					if (cpu_time_used >= 6) {
						sendCoup.validCoup = TIMEOUT;
						sendCoup.err = ERR_COUP;
						err = send(sockTransP1, &sendCoup, sizeof(TypCoupRep), 0);
						if (err <= 0) {
							perror("server : erreur sur le recv joueur1");
							shutdown(sockTransP1, 2);
							close(sockTransP1);
							shutdown(sockTransP2, 2);
							close(sockTransP2);
							close(sockConx);
							return -1;
						}
						err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
						if (err <= 0) {
							perror("server : erreur sur le recv joueur1");
							shutdown(sockTransP1, 2);
							close(sockTransP1);
							shutdown(sockTransP2, 2);
							close(sockTransP2);
							close(sockConx);
							return -1;
						}
						break;
					}

					// le coup est valid, on continue
					sendCoup.validCoup = VALID;
					sendCoup.err = ERR_OK;
					err = send(sockTransP2, &sendCoup, sizeof(TypCoupRep), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					err = send(sockTransP1, &reponseCoup, sizeof(TypCoupReq), 0);
					if (err <= 0) {
						perror("server : erreur sur le recv joueur1");
						shutdown(sockTransP1, 2);
						close(sockTransP1);
						shutdown(sockTransP2, 2);
						close(sockTransP2);
						close(sockConx);
						return -1;
					}
					tour == 1;
			}else{
				if (err < 0 && errno == EWOULDBLOCK) {
					//printf(" Serveur : pas de message sur la socket\n ");
				}else{
					perror("serveurNB : erreur dans la reception 1");
					shutdown(sockTransP1, 2); close(sockTransP1);
					shutdown(sockTransP2, 2); close(sockTransP2);
					close(sockConx);
					return -1;
				}
			}
		}

		i++;
	}
  
  	/* 
  	 * arret de la connexion et fermeture
   	*/
	shutdown(sockTransP1, 2); close(sockTransP1);
	shutdown(sockTransP2, 2); close(sockTransP2);
	close(sockConx);
  	return 0;
}
