class FSTest {
	public static void main(String[] args) {
		boolean write = false;
		byte[] data = new byte[15];
		FS fs = new FS("test.txt",true);
		if (write) {
			data[0]=(byte)80;
			data[1]=(byte)101;
			data[2]=(byte)116;
			data[3]=(byte)101;
			data[4]=(byte)114;
			data[5]=(byte)10;
			data[6]=(byte)77;
			data[7]=(byte)111;
			data[8]=(byte)109;
			data[9]=(byte)10;
			data[10]=(byte)77;
			data[11]=(byte)97;
			data[12]=(byte)109;
			data[13]=(byte)97;
			data[14]=(byte)10;
			fs.write(data);
		} else {
			System.out.println(fs.avaliable());
			data=fs.read(15);
		}
		fs.close();
	}
}