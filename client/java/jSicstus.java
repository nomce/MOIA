/****************************************************************************************
*
*      SIMULATION DU FONCTIONNEMENT DE SICSTUS PROLOG EN UTILISANT JAVA & JASPER
*      -------------------------------------------------------------------------
*
*    A compiler et à exécuter en spécifiant le classpath de Jasper.
*
*      - sur Linux : /applis/sicstus-3.11.2/lib/sicstus-3.11.2/bin/jasper.jar
 *      	/usr/local/sicstus4.3.1/lib/sicstus4.3.1/bin/jasper.jar
*
*          + executer la commande : export LD_LIBRARY_PATH=/applis/sicstus-3.11.2/lib/
*                à chaque session.
*     
*      - sous Windows : y:\...
*
***************************************************************************************/

// importation des classes utiles à Jasper
import se.sics.jasper.*;

// pour les lectures au clavier
import java.io.*;

// pour utiliser les HashMap
import java.util.*;


public class jSicstus {


    public static void main(String[] args) {

    	String saisie = new String("");
    	SICStus sp = null;

	try {
	
	    // Creation d'un object SICStus
	    sp = new SICStus();
	
	    // Chargement d'un fichier prolog .pl
	    sp.load("QuixoIA.pro");
	
	}
	// exception déclanchée par SICStus lors de la création de l'objet sp
	catch (SPException e) {
	    System.err.println("Exception SICStus Prolog : " + e);
	    e.printStackTrace();
	    System.exit(-2);
	}

	// lecture au clavier d'une requète Prolog
	System.out.print("| ?- ");
	saisie = "minimax([v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v], o, 2, Pos, Dir).";

	// boucle pour saisir les informations
	while (! saisie.equals("halt.")) {
	   
	    // HashMap utilisé pour stocker les solutions
	    HashMap results = new HashMap();
	   
	    try {
	
			// Creation d'une requete (Query) Sicstus
			//  - en fonction de la saisie de l'utilisateur
			//  - instanciera results avec les résultats de la requète
			Query qu = sp.openQuery(saisie,results);
	
			// parcours des solutions
			boolean moreSols = qu.nextSolution();
			
			// on ne boucle que si la liste des instanciations de variables est non vide
			boolean continuer = !(results.isEmpty());
	
			while (moreSols && continuer) {
			
			    // chaque solution est sockée dans un HashMap
			    // sous la forme : VariableProlog -> Valeur
			    System.out.println(results + " ? ");
			   
			    // demande à l'utilisateur de continuer ...
			    
			    moreSols = qu.nextSolution();
			    
			    saisie = "";
			    /*if (saisie.equals(";")) {
					// solution suivante --> results contient la nouvelle solution
					moreSols = qu.nextSolution();
			    }
			    else {
			    	continuer = false;
			    }*/
			}
	
			if (moreSols) {
			    // soit :
			    //  - il y a encore des solutions et (continuer == false)
			    //  - le prédicat a réussi mais (results.isEmpty() == true)
			    System.out.println("yes");
			}
			else {
			    // soit :
			    //    - on est à la fin des solutions
			    //    - il n'y a pas de solutions (le while n'a pas été exécuté)
			    System.out.println("no");
			}
	
			// fermeture de la requète
			System.err.println("Fermeture requete");
			qu.close();
	
	    }
	    catch (SPException e) {
	    	System.err.println("Exception prolog\n" + e);
		    System.out.print("| ?- ");
		    // lecture au clavier
		    saisie = saisieClavier();
	    	
	    }
	    // autres exceptions levées par l'utilisation du Query.nextSolution()
	    catch (Exception e) {
	    	System.err.println("Other exception : " + e);
	    }
	   
	    //System.out.print("| ?- ");
	    // lecture au clavier
	    //saisie = saisieClavier();
	}
	System.out.println("End of jSicstus");
	System.out.println("Bye bye");
}


    public static String saisieClavier() {

    	// declaration du buffer clavier
    	BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

		try {
		    return buff.readLine();
		}
		catch (IOException e) {
		    System.err.println("IOException " + e);
		    e.printStackTrace();
		    System.exit(-1);
		}
		return ("halt.");
    }
}