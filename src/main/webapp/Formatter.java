package webapp;

import java.text.DecimalFormat;

/**
 * Holds utility formatting functions
 *
 */
public class Formatter {

	static DecimalFormat decimalFormat = new DecimalFormat("#.##");
	
	public static String formatMonetaryValue(double value) {
		// get number of digits
		int numDigits = (int) (Math.log10(value) + 1);
		if (numDigits > 9) {
			value /= 1.0e9;
			return "$" + decimalFormat.format(value) + "B";
		} else if (numDigits > 6) {
			value /= 1.0e6;
			return "$" + decimalFormat.format(value) + "M";
		} else if (numDigits > 3) {
			value /= 1.0e3;
			return "$" + decimalFormat.format(value) + "K";
		} else return "$" + decimalFormat.format(value);
	}
	
}
