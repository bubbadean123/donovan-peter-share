import java.io.*;
class DebugStuff {
	public static void main(String[] args) {
		try {
			int data;
			int bytesAvaliable; 
			FileInputStream in;
			in = new FileInputStream("test.txt");
			bytesAvaliable=in.available();
			while (bytesAvaliable != 0) {
				data=in.read();
				System.out.print(data);
				bytesAvaliable=in.available();
			}
		} catch (FileNotFoundException e) {
			
		} catch (IOException e) {
			
		}
	}
}