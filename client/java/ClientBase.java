//
// Prgm: socket de base en java, client
//
// auteur : LP
//
// date : 7/03/06
//

import java.net.Socket;
import java.net.UnknownHostException;
import java.io.OutputStream;
import java.io.IOException;

public class ClientBase {
    public static void main(String [] args) {
	if (args.length != 2){
	    System.out.println("arguments - host port");
	    System.exit(1);
	}
	Socket s ;
	// References de la socket
	String hote = args[0] ;
	int port = Integer.parseInt(args[1]);
	
	try {
	    s = new Socket(hote, port) ;
	    OutputStream os = s.getOutputStream();
	    byte[] tablo = new byte[4];
	    tablo[0]=(byte)'a';
	    tablo[1]=(byte)'b';
	    tablo[2]=(byte)'c';
	    tablo[3]=(byte)'d';
	    
	    os.write(tablo);
	    
	    os.close();
	    s.close();
	} catch (UnknownHostException e) { 
	    System.out.println("Unknown host" + e);
	} catch (IOException e) {
	    System.out.println("IO exception" + e);
	}
    } 
}
