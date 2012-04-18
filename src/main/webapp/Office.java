package webapp;


import com.google.code.morphia.annotations.Embedded;

/*
 * Holds data for a single Office
 */
@Embedded
public class Office {
	
	private String _zip, _city, _state, _country, _address1, _address2;
	private double _latitude, _longitude;

	public Office() {
	}
	
	public String getZip() { return _zip; }
	protected void setZip(String zip) { _zip = zip == null ? zip : zip.trim(); }
	
	public String getCity() { return _city; }
	protected void setCity(String city) { _city = city == null ? city : city.trim(); }
	
	public String getState() { return _state; }
	protected void setState(String state) { _state = state == null ? state : state.trim(); }
	
	public String getCountry() { return _country; }
	protected void setCountry(String country) { _country = country == null ? country : country.trim(); }
	
	public double getLatitude() {return _latitude;}
	public void setLatitude(double latitude) { _latitude = latitude; }
	
	public double getLongitude() {return _longitude;}
	public void setLongitude(double longitude) { _longitude = longitude; }
	
	public String getAddress() { return _address1 + " " + _address2; }
	protected void setAddress1(String address1) { _address1 = address1; }
	protected void setAddress2(String address2) { _address2 = address2; }
}
