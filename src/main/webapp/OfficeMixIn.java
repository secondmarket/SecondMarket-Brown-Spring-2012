package webapp;



import org.codehaus.jackson.annotate.JsonProperty;

public abstract class OfficeMixIn extends Office {
	@JsonProperty("zip_code") public abstract String getZip();
	@JsonProperty("city") public abstract String getCity();
	@JsonProperty("state_code") public abstract String getState();
	@JsonProperty("country_code") public abstract String getCountry();
	@JsonProperty("latitude") public abstract double getLatitude();
	@JsonProperty("longitude") public abstract double getLongitude();
	
	@JsonProperty("zip_code") protected abstract void setZip(String zip);
	@JsonProperty("city") protected abstract void setCity(String city);
	@JsonProperty("state_code") protected abstract void setState(String state);
	@JsonProperty("country_code") protected abstract void setCountry(String country);
	@JsonProperty("latitude") protected abstract void setLatitude(double latitude);
	@JsonProperty("longitude") protected abstract void setLongitude(double longitude);

}
