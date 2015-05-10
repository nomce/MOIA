
import java.net.ServerSocket;
import java.net.Socket;
import java.io.InputStream;
import java.io.DataInputStream;
import java.io.OutputStream;
import java.io.DataOutputStream;
import java.io.IOException;

public class ServerIA {

	public static Coup formerCoup(){
		Coup temp = new Coup();

		temp.setValid((short) 0);

		System.out.println("Enter Depart: ");
		temp.setDepart((short) Keyboard.readInt());

		System.out.println("Enter Arrivee: ");
		temp.setArrivee((short) Keyboard.readInt());

		return temp;
	}

    public static void main(String [] args) {
		if (args.length != 1){
			System.out.println("argument - port");
			System.exit(1);
		}
		ServerSocket srv ;
		Coup coup;
		int port = Integer.parseInt(args[0]) ;

		try {
			srv = new ServerSocket(port) ;
			Socket s = srv.accept();
			System.out.println("Connecte!");
			InputStream is = s.getInputStream();
			OutputStream os = s.getOutputStream();
			DataInputStream dis = new DataInputStream(is);
			DataOutputStream dos = new DataOutputStream(os);

			short recu = dis.readShort();
			if(recu == 0){
				System.out.println("J'ai recu: ROND");
				//do IA
				coup = formerCoup();
				System.out.println("Valid: " + coup.getValid() + ", Dep: "+ coup.getDepart() + ", Arr: " + coup.getArrivee());
				dos.writeShort(coup.getValid());
				dos.flush();
				dos.writeShort(coup.getDepart());
				dos.flush();
				dos.writeShort(coup.getArrivee());
				dos.flush();
			}

			do{
				//coup
				recu = dis.readShort(); //depart
				System.out.println("---Adv---");
				System.out.print("Dep: " + recu);
				recu = dis.readShort(); //arrivee
				System.out.print(", Arr: " + recu + "\n");

				//do IA
				coup = formerCoup();
				System.out.println("Valid: " + coup.getValid() + ", Dep: "+ coup.getDepart() + ", Arr: " + coup.getArrivee());
				dos.writeShort(coup.getValid());
				dos.flush();
				dos.writeShort(coup.getDepart());
				dos.flush();
				dos.writeShort(coup.getArrivee());
				dos.flush();
			}while(recu == 0);

			dos.close();
			dis.close();
			os.close();
			is.close();
			s.close();
			srv.close();
		} catch(IOException e) { }
    }
}
