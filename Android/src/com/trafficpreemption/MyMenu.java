package com.trafficpreemption;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioGroup;
import android.widget.Toast;

public class MyMenu extends Activity {

	int priority = -1;
	ProgressDialog dialog;
	String amb_no;
	RadioGroup radioGroup;

	@Override
	public void onBackPressed() {
		Toast display = Toast
				.makeText(
						this,
						"Return button has been disabled for security reasons. Please use 'Logout' option.",
						Toast.LENGTH_LONG);
		display.show();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mymenu);

		Button bEmergency = (Button) findViewById(R.id.bEmergency);
		radioGroup = (RadioGroup) findViewById(R.id.rbPriority);

		Bundle gotbasket = getIntent().getExtras();
		amb_no = gotbasket.getString("ambno");

		bEmergency.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View arg0) {
				dialog = ProgressDialog.show(MyMenu.this, "",
						"Requesting. Please wait...", true);
				int ch = radioGroup.getCheckedRadioButtonId();
				switch (ch) {
				case R.id.radioButton1:
					priority = 1;
					break;
				case R.id.radioButton2:
					priority = 2;
					break;
				case R.id.radioButton3:
					priority = 3;
					break;
				case R.id.radioButton4:
					priority = 4;
					break;
				}
				RequestParams params = new RequestParams();
				params.put("ambno", amb_no);
				params.put("priority", ("" + priority));

				AsyncHttpClient client = new AsyncHttpClient();
				client.post("http://ipradeep.in/tps/app/declare.php", params,
						new AsyncHttpResponseHandler() {

							@Override
							public void onSuccess(String arg0) {
								dialog.cancel();
								if (arg0.charAt(0) == '1') {

									Bundle basket = new Bundle();
									basket.putString("ambno", amb_no);
									Intent i = new Intent(
											"com.trafficpreemption.EMERGENCY");
									i.putExtras(basket);
									startActivity(i);

								}

							}

							@Override
							public void onFailure(Throwable arg0, String arg1) {
								// TODO Auto-generated method stub
								super.onFailure(arg0, arg1);
								dialog.cancel();
								Toast.makeText(getApplicationContext(),
										"Could not connect. Check connection",
										Toast.LENGTH_LONG).show();
							}

						});

			}
		});
		Button bLogout = (Button) findViewById(R.id.bLogout);
		bLogout.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				RequestParams params = new RequestParams();
				params.put("ambno", amb_no);

				AsyncHttpClient client = new AsyncHttpClient();
				client.post("http://ipradeep.in/tps/app/logout.php", params,
						new AsyncHttpResponseHandler() {

							@Override
							public void onSuccess(String arg0) {
								if (arg0.charAt(0) == '1') {
									finish();
								}

							}

							@Override
							public void onFailure(Throwable arg0, String arg1) {
								// TODO Auto-generated method stub
								super.onFailure(arg0, arg1);
								dialog.cancel();
								Toast.makeText(getApplicationContext(),
										"Could not connect. Check connection",
										Toast.LENGTH_LONG).show();
							}

						});
			}
		});

	}
}
