import java.io.*;
public class FS {
	FileOutputStream out;
	FileInputStream in;
    public FS(String file, boolean append) {
		try {
			out = new FileOutputStream(file,append);
			in = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			
		}
	}
	
	public void write(byte[] data)  {
		try {
			out.write(data);
		} catch (IOException e) {
			
		}
	}
	
	public int avaliable() {
		try {
			return in.available();
		} catch (IOException e) {
			return 0;
		}
	}
	
	public byte[] read(int amount) 	{
		byte[] data = new byte[amount];
		try {
			in.read(data);
		} catch (IOException e) {
			return new byte[1];
		}
		return data;
	}
	
	public void close() {
		try {
			in.close();
		} catch (IOException e) {
			
		}
	}
}