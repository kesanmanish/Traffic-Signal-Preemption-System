package com.trafficpreemption;


import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import com.loopj.android.http.*;

public class Login extends Activity {

	EditText uname, pwd;
	int ret;
	ProgressDialog dialog;
	SharedPreferences prefs;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		
		uname = (EditText) findViewById(R.id.etUsername);
		pwd = (EditText) findViewById(R.id.etPwd);
		Button bLogin = (Button) findViewById(R.id.bLogin);
		
		 prefs = PreferenceManager.getDefaultSharedPreferences(getBaseContext());
		String ambno = prefs.getString("Amb no", "KA06EE1284");
		uname.setText(ambno);
		
		bLogin.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View arg0) {
				
				dialog = ProgressDialog.show(Login.this, "", 
	                    "Verifying. Please wait...", true);
			
				Editor editor = prefs.edit();
				editor.putString("Amb no", uname.getText().toString());
				editor.commit();
				
						
				RequestParams params = new RequestParams();
				params.put("username", uname.getText().toString());
				params.put("pass1", pwd.getText().toString());

				AsyncHttpClient client = new AsyncHttpClient();

				client.post("http://ipradeep.in/tps/app/login.php",params,
						new AsyncHttpResponseHandler() {
							@Override
							public void onSuccess(String response) {
								dialog.cancel();
								if (response.charAt(0) == '1') {
									pwd.setText("");									
									Bundle basket = new Bundle();
									basket.putString("ambno", uname.getText().toString());
									Intent i = new Intent("com.trafficpreemption.MENU");
									i.putExtras(basket);
									startActivity(i);									
								}
								else
								{
									Toast.makeText(getApplicationContext(),
											"Invalid Username/Password", Toast.LENGTH_SHORT)
											.show();
								}

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

		
		});

	}
}
