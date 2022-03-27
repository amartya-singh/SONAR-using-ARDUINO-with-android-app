//**The RADAR details**//


import controlP5.*; // header file inclusion

ControlP5 cp5; //define object for lib.

Chart myChart; //define object for chart 


//**Fuction to update Radar Details**//
void radar() {
   background(200);
   myChart.setColorBackground(color(255-info,25,25));
   myChart.setColorForeground(color(25));
   myChart.push("incoming", info);
}
//__End of function__//