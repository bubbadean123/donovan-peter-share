import java.util.Scanner;
public class Input {
	static Scanner scanner = new Scanner(System.in);
	public static String getstring() {
		String string = scanner.next();
		return string;
	}
	public static int getint() {
		int integer = scanner.nextInt();
		return integer;
	}
}