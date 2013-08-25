//Dynamic Traffic Signal Controller
#include <SPI.h>
#include <Ethernet.h>

byte ip[] = {192, 168, 0, 199};   
byte gateway[] = {192, 168, 0, 1}; 
byte subnet[] = {255, 255, 255, 0 }; 
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
EthernetServer server = EthernetServer(80); //port 80

int  sigCount = 4;
int goTime[5] = {
  30,30,30,30};
int pauseTime = 5;
int sig[5][3] = {
  A3,A2,A1,
  9,8,7,
  6,5,4,
  3,2,A4 };

int buz = A0;
int PREEMPT = -1;
int preemptTime[5] = {0,0,0,0,0};
int curGreen = -1;

////////////////////////////////////////////////////////


void setup()
{  
  int i,j;
  for(i=0;i<sigCount;i++)
    for(j=0;j<3;j++)
      pinMode(sig[i][j], OUTPUT);
  pinMode(buz,OUTPUT);
  Ethernet.begin(mac, ip, gateway, subnet); 
  server.begin();
  Serial.begin(9600);
}

void loop()
{
  int i;
  for(i=0;i<sigCount;i++)
  {
    statePause(i);
    stateGo(i);
  }
}

//defines signal statuses when 'k' th  road is green
void stateGo(int k)
{    
  if(preemptTime[k] > goTime[k])
  {
    preemptTime[k] = 0;
    return;
  }
  //buzzer is off
  analogWrite(buz,0); 
  //all lights are turned off for a fraction of a second.
  int i,j;
  for(i=0;i<sigCount;i++)
    for(j=0;j<3;j++)
      digitalWrite(sig[i][j],LOW);

  //all roads except the 'k'th road is red.
  for(i=0;i<sigCount;i++)
    if(i!=k)
      digitalWrite(sig[i][0],HIGH);

  //kth road is green.
  curGreen = k;
  digitalWrite(sig[k][2],HIGH);
  
  for(i=0;i < goTime[k]- 6; i++)
  {
    PREEMPT = checkForClient();
    if(PREEMPT!= -1 && PREEMPT != k)
    {
      PREEMPT = -1;
      statePause(k);
      preemptTime[k] = i;
      stateGo(k);
      return;
    }
    if(preemptTime[k]>0)
    {
      preemptTime[k]--;
      continue;
    }
    delay(1000);
  }
 for(i=0;i<6;i++)
 {
      digitalWrite(sig[k][2],LOW);
      delay(500);
      digitalWrite(sig[k][2],HIGH);
      delay(500);
 } 
}


void statePause(int k)
{ 
  if(preemptTime[k] > goTime[k])
  {
    return;
  }
  int i,j;
  int p = curGreen;

  //turn off all lights for a fraction of a second.
  for(i=0;i< sigCount;i++)
    for(j=0;j<3;j++)
      digitalWrite(sig[i][j],LOW);

  //all red lights except p (i.e k-1) are red.
  for(i=0;i< sigCount;i++)
    if(i!=p)
      digitalWrite(sig[i][0], HIGH);

  //also  p and k roads have yellow
  digitalWrite(sig[p][1],HIGH);
  digitalWrite(sig[k][1],HIGH);

  curGreen = -1;

  //for pTime seconds switch off and switch on buzzer.
  for(i=0;i<(2*pauseTime);i++)
  {
    analogWrite(buz,255);
    delay(250);
    analogWrite(buz,0);
    delay(250);
  }
}


int checkForClient()
{

  EthernetClient client = server.available();
  boolean reading = false;
  
  if (client) 
  {
    reading = false;
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    boolean sentHeader = false;
    while (client.connected()) 
    {
      if (client.available()) 
      {

        if(!sentHeader)
        {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();
          sentHeader = true;
        }

        char c = client.read();

        if(reading && c == ' ') reading = false;
        if(c == '?') reading = true; //found the ?, begin reading the info

        if(reading)
        {
          switch(c)
          {
          case 'E': 
            c=client.read();
            c = c-48;

            if(c<0 || c>sigCount)
              return -1;
            client.println("Preempting Signal ");
            client.print((int)c);
            client.print("<br>");
            client.stop();
            statePreempt((int)c);
            return (int)c; 
            break;
          case 'T':  
            return -1;
          }
        }
      }
      else
      {
        break;
      }
    }
    client.stop();
  }
  return -1;
}

void statePreempt(int k)
{
  int i;
  if(curGreen != k)
  {
    int j;
    int p = curGreen;

    //turn off all lights for a fraction of a second.
    for(i=0;i< sigCount;i++)
      for(j=0;j<3;j++)
        digitalWrite(sig[i][j],LOW);

    //all red lights except p (i.e k-1) are red.
    for(i=0;i< sigCount;i++)
      if(i!=p)
        digitalWrite(sig[i][0], HIGH);

    //also  p and k roads have yellow
    digitalWrite(sig[p][1],HIGH);
    digitalWrite(sig[k][1],HIGH);

    curGreen = -1;

    //for pTime seconds switch off and switch on buzzer.
    for(i=0;i<(2*pauseTime);i++)
    {
      analogWrite(buz,255);
      delay(250);
      analogWrite(buz,0);
      delay(250);
    }
    digitalWrite(sig[p][1],LOW);
    digitalWrite(sig[p][0],HIGH);
    digitalWrite(sig[k][1],LOW);
    digitalWrite(sig[k][0],LOW);
  }
  
  curGreen = k;
  int flag = 0;
  while(flag == 0)
  {
    preemptTime[k]++;
    digitalWrite(sig[k][2],HIGH);
    analogWrite(buz,255);
    delay(400);
    analogWrite(buz,0);
    delay(200);
    analogWrite(buz,255);
    delay(200);
    analogWrite(buz,0);
    delay(200);
    flag = checkForPreemptReturn();
  }
  return;
}

int checkForPreemptReturn()
{
  boolean reading = false;
  EthernetClient client = server.available();
  if (client) 
  {
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    boolean sentHeader = false;
    while (client.connected()) 
    {
      if (client.available()) 
      {

        if(!sentHeader)
        {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();
          sentHeader = true;
        }

        char c = client.read();

        if(reading && c == ' ') reading = false;
        if(c == '?') reading = true; //found the ?, begin reading the info

        if(reading)
        {
          switch(c)
          {
          case 'E': 
            c=client.read();
            c = c-48;

            if(((int)c) != 5)
              return 0;
            client.println("Returning to Normal Mode");
            client.print("<br>");
            client.stop();
            return 1; 
            break;
          }
        }
      }
      else
      {
        break;
      }
    }
    client.stop();
  }
    return 0;
}

