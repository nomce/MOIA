//
// Prgm: socket de base en java, serveur
//
// auteur : LP
//
// date : 7/03/06
//

import java.net.ServerSocket;
import java.net.Socket;
import java.io.InputStream;
import java.io.IOException;

public class ServeurBase {    
    public static void main(String [] args) {
	if (args.length != 1){
	    System.out.println("argument - port");
	    System.exit(1);
	}
	ServerSocket srv ;
	int port = Integer.parseInt(args[0]) ;
	
	try {
	    srv = new ServerSocket(port) ;
	    Socket s = srv.accept() ;
	    InputStream is = s.getInputStream();
	    
	    byte[] tablo = new byte[4];
	    int recu = is.read(tablo);
	    System.out.println("J'ai recu: " + recu + "-"+ tablo[2]);
	    
	    is.close();
	    s.close();
	    srv.close();
	} catch(IOException e) { }
    }
}
