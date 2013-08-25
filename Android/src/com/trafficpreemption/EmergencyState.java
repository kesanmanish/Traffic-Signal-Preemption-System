package com.trafficpreemption;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;



public class EmergencyState extends Activity {
	
	String amb_no;
	ProgressDialog dialog;
	Thread periodic;
	Double lat, lon, bear, speed;
	boolean process = true;

	public void showToast(final String toast)
	{
	    runOnUiThread(new Runnable() {
	        public void run()
	        {
	            Toast.makeText(EmergencyState.this, toast, Toast.LENGTH_SHORT).show();
	        }
	    });
	}
	@Override
	public void onBackPressed() {
		Toast display = Toast
				.makeText(
						this,
						"Return button has been disabled for security reasons. Please use 'Terminate Emergency' option",
						Toast.LENGTH_LONG);
		display.show();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.emergencystate);

		Bundle gotbasket = getIntent().getExtras();
		amb_no = gotbasket.getString("ambno");

		Button bStopEmergency = (Button) findViewById(R.id.bStopEmergency);
		bStopEmergency.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				dialog = ProgressDialog.show(EmergencyState.this, "",
						"Terminating. Please wait...", true);

				RequestParams params = new RequestParams();
				params.put("ambno", amb_no);

				AsyncHttpClient client = new AsyncHttpClient();
				client.post("http://ipradeep.in/tps/app/terminate.php", params,
						new AsyncHttpResponseHandler() {

							@Override
							public void onSuccess(String arg0) {
								dialog.cancel();

								if (arg0.charAt(0) == '1') {
									finish();
								}

							}

							@Override
							public void onFailure(Throwable arg0, String arg1) {
								// TODO Auto-generated method stub
								super.onFailure(arg0, arg1);
								dialog.cancel();
								process = false;
								Toast.makeText(getApplicationContext(),
										"Could not connect. Check connection",
										Toast.LENGTH_LONG).show();

								// REMOVE NEXT LINE ONCE PHP IS WORKING
								finish();
							}

						});
			}
		});

		LocationManager locManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		LocationListener locListener = new MyLocationListener();

		locManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1, 0,
				locListener);

		periodic = new Thread() {
			public void run() {
				try {
					while (process) {
						sleep(5000);
						
						RequestParams params = new RequestParams();
						params.put("ambno", amb_no);
						params.put("latitude", (lat+""));
						params.put("longitude", (lon+""));
						params.put("bearing", (bear+ ""));
						params.put("speed", (speed + ""));
						
						AsyncHttpClient client = new AsyncHttpClient();
						
						client.post("http://ipradeep.in/tps/app/update.php",params,new AsyncHttpResponseHandler(){

							@Override
							public void onSuccess(String arg0) {
								
								
							}

							@Override
							public void onFailure(Throwable arg0, String arg1) {
								// TODO Auto-generated method stub
								super.onFailure(arg0, arg1);
								dialog.cancel();
								Toast.makeText(getApplicationContext(),
										"Could not connect. Check connection", Toast.LENGTH_LONG)
										.show();
							}

							
							
						});
						
						
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
					
					finish();
				}
			}
		};

		periodic.start();
	}

	public class MyLocationListener implements LocationListener {
		TextView tv1 = (TextView) findViewById(R.id.TextView02);
		TextView tv2 = (TextView) findViewById(R.id.textView2);
		TextView tv3 = (TextView) findViewById(R.id.tvBearing);
		TextView tv4 = (TextView) findViewById(R.id.tvSpeed);

		@Override
		public void onLocationChanged(Location loc) {

			lat = loc.getLatitude();
			lon = loc.getLongitude();
			
			bear = (double) loc.getBearing();
			speed = 3.6 * (double)loc.getSpeed();
			
			String Text1 = "" + lat;
			String Text2 = "" + lon;
			String Text3 = "" + bear;
			String Text4 = "" + speed;

			// Display location
			tv1.setText(Text1);
			tv2.setText(Text2);
			tv3.setText(Text3);
			tv4.setText(Text4);
		}

		@Override
		public void onProviderDisabled(String provider) {
			Toast.makeText(getApplicationContext(), "Gps Disabled",
					Toast.LENGTH_SHORT).show();
		}

		@Override
		public void onProviderEnabled(String provider) {
			Toast.makeText(getApplicationContext(), "Gps Enabled",
					Toast.LENGTH_SHORT).show();
		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {

		}
	}
}
