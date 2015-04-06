import processing.serial.*;
import controlP5.*;
import java.util.Arrays;
import java.io.BufferedWriter;
import java.io.FileWriter;

ControlP5 cp5;
PFont f;

DropdownList dlSerialPorts;
StringList serialLog;
Serial port; 

JSONObject config;

float x=0, y=0, z=0;

String lastCmd = "";

StringList sendBuffer = new StringList();

boolean cts = true;

void saveConfig() {
  // save connection string
  saveJSONObject(config, "config.json");
}

void stop() {
  saveConfig(); 
  Disconnect(0);

  super.stop();
}


void setup() {
  size(700, 400, P3D);
  f = createFont("Arial", 11, true); 

  try {
    config = loadJSONObject("config.json");
  } 
  catch(Exception e) {
  }

  cp5 = new ControlP5(this);

  // Configure Serial Ports Dropdown
  // -------------------------------
  dlSerialPorts = cp5.addDropdownList("dlSerialPorts")
    .setPosition(5, 25)
      .setWidth(200)
        ;
  dlSerialPorts.captionLabel().set("Choose a Serial Port");
  customize(dlSerialPorts);
  // Get list of ports
  dlSerialPorts.addItems(Serial.list());

  if (config != null) {
    int i = Arrays.asList(Serial.list()).indexOf(config.getString("port"));  
    dlSerialPorts.setValue(i);
  }

  // Connect button
  cp5.addButton("Connect")
    .setPosition(220, 5)
      .setSize(50, 20)
        ;

  // Disconnect button
  cp5.addButton("Disconnect")
    .setPosition(280, 5)
      .setSize(50, 20)
        ;


  // home
  cp5.addButton("Home")
    .setPosition(340, 5)
      .setSize(50, 20)
        ;


  // Send
  cp5.addButton("SendCommand")
    .setPosition(400, 5)
      .setSize(50, 20)
        ;
        
        
  // Store
  cp5.addButton("Store")
    .setPosition(460, 5)
      .setSize(50, 20)
        ;
        
        
   // PlayBack
  cp5.addButton("PlayBack")
    .setPosition(520, 5)
      .setSize(50, 20)
        ;
        
  // Z
  cp5.addSlider("Z")
    .setValue(0.0)
      .setRange(0.0, 300.0)
        .setPosition(220, 170)
          .setSize(200, 20)
            ; 

  cp5.addTextfield("LastCommand")
    .setPosition(220, 200)
      .setSize(400, 20)
        .setFont(createFont("arial", 11))
          .setAutoClear(false)
            ;

  cp5.addTextfield("NewCommand")
    .setPosition(220, 250)
      .setSize(400, 20)
        .setFont(createFont("arial", 11))
          .setAutoClear(false)
            ;
            
  // Arm button
  cp5.addButton("ArmLaser")
    .setPosition(220, 40)
      .setSize(50, 20)
        ;
  
  // Disarm button
  cp5.addButton("DisarmLaser")
    .setPosition(280, 40)
      .setSize(50, 20)
        ;
        
  // Test fire button
  cp5.addButton("TestFire")
    .setPosition(340, 40)
      .setSize(50, 20)
        ;


  // Configure serialLog
  serialLog = new StringList();
  serialLog.append("Log");
  serialLog.append("---");
}

public void Connect(int theValue) {
  if (dlSerialPorts.getValue() >= 0) {
    String c = Serial.list()[int(dlSerialPorts.getValue())];
    port = new Serial(this, c, 57600);
    port.bufferUntil(10);  // line feed

    config.setString("port", c);
    saveConfig();
  }
}

public void Disconnect(int theValue) {
  if (port != null) {
    port.dispose();
    port = null;
    
    sendBuffer.clear();
  }
}

public void SendCMD(String c) {
  if (port != null) {
    serialLog.append(c);
    cts = false; // reset by receiving an ok
    println("sending: "+c);
    port.write(c); 
    lastCmd = c;
    cp5.get(Textfield.class, "LastCommand").setText(c);
  }
}

public void QueueCMD(String c) {
   sendBuffer.append(c); 
}

public void Home(int v) {
  QueueCMD("G28\r\n");
}


public void Z(float v) {
  z = v;
}

public void SendCommand(int v) {
  //QueueCMD("G1 X"+x+" Y"+y+" Z"+z+" F1500\r\n");
  QueueCMD(cp5.get(Textfield.class, "NewCommand").getText() + "\r\n");
}

public void Store(int v) {
   appendTextToFile("playback.gcode",lastCmd);
}

public void PlayBack(int v) {
  String lines[] = loadStrings("playback.gcode");
  sendBuffer.clear();
  for (int i = 0 ; i < lines.length; i++) {
     if (lines[i] != "") {
        QueueCMD(lines[i] + "\r\n");
     }
  }
}

public void ArmLaser(int v) {
  QueueCMD("M669\r\n");
}

public void DisarmLaser(int v) {
  QueueCMD("M670\r\n");
}

public void TestFire(int v) {
  QueueCMD("M671 S50 P100\r\n");
}

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(20);
  ddl.captionLabel().style().marginTop = 3;
  ddl.captionLabel().style().marginLeft = 3;
  ddl.valueLabel().style().marginTop = 3;
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void serialEvent(Serial p) { 
  String s = p.readString(); 
  if (s.substring(0,2).equals("ok")) cts = true;
  println("Received: "+s + ", cts: "+cts);
  serialLog.append(s);
  while (serialLog.size () > 20) serialLog.remove(0);
}


void keyPressed() {
  if (key=='1') {
  }
}


void draw() {
  background(128);
  textFont(f, 11);

  // Draw serialLog
  fill(0);
  for (int i=0; i<serialLog.size (); i++) {
    String s = serialLog.get(i);
    text(s, 10, 40 + i*15);
  }
  
  // send stuff
  if (sendBuffer.size() > 0 && cts) {
    String c = sendBuffer.get(0);
    sendBuffer.remove(0);
    SendCMD(c);
  }
}


/**
 * Appends text to the end of a text file located in the data directory, 
 * creates the file if it does not exist.
 * Can be used for big files with lots of rows, 
 * existing lines will not be rewritten
 */
void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.print(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}
