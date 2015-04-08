/*
 **********************************************************
 *
 *  Programme : validation.h
 *
 *  ecrit par : FB / VF
 *
 *  resume : entete pour la validation des coups
 *
 *  date :      12 / 03 / 15
 *  modifie : 
 ***********************************************************
 */

#ifndef _validation_h
#define _validation_h

/* Validation d'un coup on doit passer :
 * le numero du joueur 1 pour A et 2 pour B
 * le type de coup (TypPropCoup)
  resultat : type bool */
bool validationCoup( int joueur, TypCoupReq coup);

#endif 
