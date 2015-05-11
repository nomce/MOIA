
import java.io.*;
import java.net.Socket;

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
		if (args.length != 4){
			System.out.println("arguments: serverName clientPort name IAPort ");
			System.exit(1);
		}
		System.out.println(args[0]+args[1]+args[2]+args[3]);
		Socket s;
		Coup coup;
		int portClient = Integer.parseInt(args[1]);
		int portIA = Integer.parseInt(args[3]);

		final Process p;
		try {
			p = Runtime.getRuntime().exec("../c/client " + args[0] + " " + portClient + " " + args[2] + " " + portIA);

			new Thread(new Runnable() {
				public void run() {
					BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
					String line = null;

					try {
						while ((line = input.readLine()) != null) {
							System.out.println(line);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}).start();
		} catch (IOException e) {
			e.printStackTrace();
		}

		try {
			s = new Socket("localhost",portIA);
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
			
			int i = 0;
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
				i++;
			}while(i<25);

			dos.close();
			dis.close();
			os.close();
			is.close();
			s.close();
		} catch(IOException e) { }
    }
}
