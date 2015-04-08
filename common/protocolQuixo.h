/*******************************************************
 *
 * Programme : protocolQuixo.h
 *
 * Synopsis : entete du protocole d'acces a l'arbitre
 *            pour Quixo
 *
 * Ecrit par : VF
 * Date :  09 / 03 / 15
 * 
/*******************************************************/

#ifndef _protocolQuixo_h
#define _protocolQuixo_h

/* Taille des chaines */
#define TAIL_CHAIN 30

/* Identificateurs des requetes */
typedef enum { PARTIE, COUP } TypIdRequest;

/* Types d'erreur */
typedef enum { ERR_OK,      /* Validation de la requete */
	       ERR_PARTIE,  /* Erreur sur la demande de partie */
	       ERR_COUP,    /* Erreur sur le coup joue */
	       ERR_TYP      /* Erreur sur le type de requete */
} TypErreur;

/* 
 * Structures demande de partie
 */
typedef struct{

  TypIdRequest idRequest;      /* Identificateur de la requete */
  char nomJoueur[TAIL_CHAIN];  /* Nom du joueur */

} TypPartieReq;

typedef enum {  ROND, CROIX, VIDE } TypCube;

typedef struct {

  TypErreur  err;               /* Code d'erreur */
  TypCube    signe;             /* Signe du cube */
  char nomAdvers[TAIL_CHAIN];   /* Nom du joueur */

} TypPartieRep;


/* 
 * Definition d'une position de case
 */
typedef int TypCase;

/* 
 * Definition d'un deplacement de cube
 */
typedef struct {

  TypCase  caseDepCube;  /* Position de depart du cube */
  TypCase  caseArrCube;  /* Position d'arrivee du cube */

} TypDeplCube;


/* 
 * Structures coup du joueur 
 */

/* Propriete des coups */
typedef enum { DEPL_CUBE, GAGNANT, NULLE, PERDU } TypCoup;

typedef struct {

  TypIdRequest idRequest;     /* Identificateur de la requete */
  TypCube      signeCube;     /* Signe du cube */
  TypCoup      propCoup;      /* Type de coup */
  TypDeplCube  deplCube;      /* Deplacement du cube */

} TypCoupReq;

/* Validite du coup */
typedef enum { VALID, TIMEOUT, TRICHE } TypValCoup;

/* Reponse a un coup */
typedef struct {

  TypErreur err;                  /* Code d'erreur */
  TypValCoup validCoup;           /* Validite du coup */

} TypCoupRep;

#endif

