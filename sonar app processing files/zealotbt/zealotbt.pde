/*
Application for DIY- Survillence Device
can be used with Arduino hardware

code by www.circuitdigest.com
coded on 08-04-2017
*/



//**Import the necessary header files**//
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
import android.bluetooth.BluetoothAdapter;
import android.view.KeyEvent;
//__End of imports__//

BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();

PImage crcl,start,stop;
KetaiBluetooth bt;
int info,pinfo,sendangle;
String cninfo = "";
float angle;
boolean sw;



//**To start BT when app is launched**// 
void onCreate(Bundle savedInstanceState) {
 super.onCreate(savedInstanceState);
 bt = new KetaiBluetooth(this);
}
void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//__BT launched__//


//**To select bluetooth device if needed**// (not required for our program
void onKetaiListSelection(KetaiList klist)
{
 String selection = klist.getSelection();
 bt.connectToDeviceByName(selection);
 //dispose of list for now
 klist = null;
}
//__End of selection__//


//** To get data from blue tooth**/
void onBluetoothDataEvent(String who, byte[] data)
{
info = (data[0] & 0xFF) ;

}
//__data received_//


//**To get connection status**//
String getBluetoothInformation()
{
  String btInfo = "Connected to :";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }

  return btInfo;
}
//--connection status received_//


//**Settings for the Android Application**//
void settings()
{
 fullScreen(); //make the app for in full screen 
}
//__Settings completed__//


//**Executes only once**// (similar to arduino)
void setup() 
{
  textSize(31);
  bt.start(); //start listening for BT connections
  bt.getPairedDeviceNames();
  bt.connectToDeviceByName("HC-05"); //Connect to our HC-05 bluetooth module
 
 //**Load the required images from data folder**//
  crcl = loadImage("crcl.png");
  start = loadImage("start.png");
  stop = loadImage("stop.png");
  cp5 = new ControlP5(this);
  //__Images loaded into variables__//
  
  //**Draw the chart**//
  myChart = cp5.addChart("dataflow")
               .setPosition(0, height/4)
               .setSize(width, height/2)
               .setRange(0, 200)
               .setView(Chart.AREA) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(5))
               ;
  myChart.addDataSet("incoming");
  myChart.setData("incoming", new float[100]);
  //**Chart draw complete**//
}


//**Draw function**//
void draw() //The infinite loop
{
  background(255);
  radar();      // always update radar
  textfun();   //always display the text 
  buttons();   //always sense if button are pressed
  if (sw==false)
  Servocontrol();
}
///__End of draw__//


//Function to Convert int to byte//
public byte[] intToByteArray(int value) {
    return new byte[] {
            (byte)value};
}
//__End of function__//


//**Function to control the Servo motor**//
void Servocontrol()
{
  pushMatrix();
  translate(width/2,height/1.2);
  angle = map(mouseX,0,width,0,20);     //load angel if we swipe ear the wheel
  sendangle = int(angle*9);            //Amount of degree to rotate for one pixel increment  
  rotate(angle*0.1);                   //rotate the image for annimation
  imageMode(CENTER);
  image(crcl,0,0,width/3.5,width/3.5);
  popMatrix();
    
 if (mousePressed == true && mouseY>height/1.2 )
    {   
     byte[] send = intToByteArray(sendangle); 
     if (send[0]!=112 && send[0]!=115)
     bt.broadcast(send);  //transmit servo angel to bluetooth
     println(send); //for debugginf
    }
}
//__End of Function__//


//Function Display the text on top of the application**//
void textfun()
{
  textAlign(CENTER);
  fill(#06BCB7);
  text ("Range in Centi-meters" + info,width/2,height-height/1.11);
  text("Swipe here to Control Direction manually",width/2,height);
  text ("Current Angle : " + int(angle*9),width/2,height-height/1.05);
  cninfo = getBluetoothInformation();    //get connection information status
  text(cninfo,width/2,height-height/1.08);
  noFill();
}
//__End of function__//


//**Function to display buttons**//
void buttons()
{
  imageMode(CENTER);
  image(start,width/2.6,height/6,width/8,width/8);
  image(stop,width/1.6,height/6,width/8,width/8);
}
//__End of function__//


//**Function to sence buttons and drags**//
void mouseReleased()
{
if (mouseX<(width/2.6+width/8) && mouseY<(height/6+width/8))
{
  sw=true;
  byte[] send = {'p'}; //send p if play button is present 
  bt.broadcast(send);  
  println("Play");

}
if (mouseX>(width/1.6-width/8) && mouseY<(height/6+width/8))
{
  sw=false;
  byte[] send = {'s'};  //send s if stop button is pressed 
  bt.broadcast(send); 
  println("Stop");
}
}
//**End of function__//