package processing.test.zealotbt;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.Intent; 
import android.os.Bundle; 
import ketai.net.bluetooth.*; 
import ketai.ui.*; 
import ketai.net.*; 
import android.bluetooth.BluetoothAdapter; 
import android.view.KeyEvent; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class zealotbt extends PApplet {









BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();

PImage crcl,start,stop;
KetaiBluetooth bt;
int info,pinfo,sendangle;
String cninfo = "";
float angle;
boolean sw;



//To start BT on start********* 

public void onCreate(Bundle savedInstanceState) {
 super.onCreate(savedInstanceState);
 bt = new KetaiBluetooth(this);
}

public void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//**********

//To select bluetooth device**********
public void onKetaiListSelection(KetaiList klist)
{
 String selection = klist.getSelection();
 bt.connectToDeviceByName(selection);
 //dispose of list for now
 klist = null;
}
//**********

//***** To get data from blue tooth
public void onBluetoothDataEvent(String who, byte[] data)
{
info = (data[0] & 0xFF) ;

}
//***************

//To get connection status
public String getBluetoothInformation()
{
  String btInfo = "Connected to :";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }

  return btInfo;
}
//**********


public void settings()
{
 fullScreen(); 
  
}

public void setup() 
{
  textSize(31);
bt.start(); //start listening for BT connections
 bt.getPairedDeviceNames();
bt.connectToDeviceByName("HC-05");
  crcl = loadImage("crcl.png");
    start = loadImage("start.png");
    stop = loadImage("stop.png");
      cp5 = new ControlP5(this);
  myChart = cp5.addChart("dataflow")
               .setPosition(0, height/4)
               .setSize(width, height/2)
               .setRange(0, 200)
               .setView(Chart.AREA) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5f)
               .setColorCaptionLabel(color(5))
               ;

  myChart.addDataSet("incoming");
  myChart.setData("incoming", new float[100]);
}

public void draw() 
{
  background(255);
  radar();
  textfun();
  buttons();
  if (sw==false)
Servocontrol();




}

public byte[] intToByteArray(int value) {
    return new byte[] {
            (byte)value};
}



public void Servocontrol()
{
  pushMatrix();
  translate(width/2,height/1.2f);
angle = map(mouseX,0,width,0,20);
sendangle = PApplet.parseInt(angle*9);
 rotate(angle*0.1f); 
 imageMode(CENTER);
  image(crcl,0,0,width/3.5f,width/3.5f);
 popMatrix();
    
 if (mousePressed == true && mouseY>height/1.2f )
    {
      
     byte[] send = intToByteArray(sendangle);
  if (send[0]!=112 && send[0]!=115)
  bt.broadcast(send); 
  println(send);
    }
}

public void textfun()
{
  textAlign(CENTER);
    fill(0xff06BCB7);
 text ("Range in Centi-meters" + info,width/2,height-height/1.11f);
text("Swipe here to Control Direction manually",width/2,height);
text ("Current Angle : " + PApplet.parseInt(angle*9),width/2,height-height/1.05f);
cninfo = getBluetoothInformation();
text(cninfo,width/2,height-height/1.08f);
noFill();
}



public void buttons()
{
  imageMode(CENTER);
    image(start,width/2.6f,height/6,width/8,width/8);
    image(stop,width/1.6f,height/6,width/8,width/8);
}

public void mouseReleased()
{
if (mouseX<(width/2.6f+width/8) && mouseY<(height/6+width/8))
{
 sw=true;
  byte[] send = {'p'};
  bt.broadcast(send); 
    println("Odiko");

}
if (mouseX>(width/1.6f-width/8) && mouseY<(height/6+width/8))
{
sw=false;
  byte[] send = {'s'};
  bt.broadcast(send); 
     println("Ninuko");
}
}



ControlP5 cp5;

Chart myChart;



public void radar() {
  background(200);
   myChart.setColorBackground(color(255-info,25,25));
     myChart.setColorForeground(color(25));
  myChart.push("incoming", info);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "zealotbt" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
