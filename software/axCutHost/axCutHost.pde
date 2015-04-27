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
String lastCmdRaw = "";
int lastLineNo = 0;
int resendCount = 0;

StringList sendBuffer = new StringList();

boolean cts = true;
boolean resend = false;

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
        
   // Abort
  cp5.addButton("Abort")
    .setPosition(580, 5)
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
            
  cp5.addTextfield("ResendErrors")
    .setPosition(220, 290)
      .setSize(40, 20)
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
    port = new Serial(this, c, 115200);
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
    serialLog.append(c + "\r\n");
    appendTextToFile("serial.log",c + "\r\n");
    cts = false; // reset by receiving an ok
    println("sending: "+c + "\r\n");
    port.write(c + "\r\n"); 
    lastCmd = c;
    cp5.get(Textfield.class, "LastCommand").setText(c);
  }
}

public void QueueCMD(String c) {
   sendBuffer.append(c); 
}

public void Home(int v) {
  QueueCMD("G28 XY");
  QueueCMD("G28 Z");
}


public void Z(float v) {
  z = v;
}

public void SendCommand(int v) {
  QueueCMD(cp5.get(Textfield.class, "NewCommand").getText());
}

public void NewCommand(String s) {
  QueueCMD(cp5.get(Textfield.class, "NewCommand").getText());
}

public void Store(int v) {
   appendTextToFile("playback.gcode",lastCmd);
}

public String AddCRCXOR(int line, String c) {
  String cmd = "N"+line +c;
  
  int cs = 0;
  for(int i = 0; i < cmd.length(); i++)
    cs = cs ^ cmd.charAt(i);
  cs &= 0xff;  // Defensive programming...
  
  return cmd + "*"+cs;
}

int CRC8(String s) {
  int crc = 0x00;
  int len = s.length();
  int i = 0;
  while (len-- > 0) {
    int extract = 0xFF & (int) s.charAt(i);
    i++;
    for (int tempI = 8; tempI > 0; tempI--) {
      int sum = (crc ^ extract) & 0x01;
      crc >>= 1;
      if (sum > 0) {
        crc ^= 0x8C;
      }
      extract >>= 1;
    }
  }
  return crc;
}


static int auchCRCHi[] = {
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0,
0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01,
0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0,
0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01,
0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81,
0x40
} ;
  
static int auchCRCLo[] = {
0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4,
0x04, 0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09,
0x08, 0xC8, 0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD,
0x1D, 0x1C, 0xDC, 0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3,
0x11, 0xD1, 0xD0, 0x10, 0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7,
0x37, 0xF5, 0x35, 0x34, 0xF4, 0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A,
0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38, 0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE,
0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C, 0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26,
0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0, 0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2,
0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4, 0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F,
0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68, 0x78, 0xB8, 0xB9, 0x79, 0xBB,
0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C, 0xB4, 0x74, 0x75, 0xB5,
0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0, 0x50, 0x90, 0x91,
0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54, 0x9C, 0x5C,
0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98, 0x88,
0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80,
0x40
} ;

int CRC16 (String puchMsg )
{
  int usDataLen = puchMsg.length();
  int uchCRCHi = 0xff;
  int uchCRCLo = 0xff;
  int uIndex;
  int i= 0;
  while(usDataLen-- > 0)
  {
    uIndex = uchCRCLo ^ puchMsg.charAt(i);
    i++;
    uchCRCLo = uchCRCHi ^ auchCRCHi[uIndex];
    uchCRCHi = auchCRCLo[uIndex]; 
  }
  return (uchCRCHi << 8 | uchCRCLo) & 0xFFFF;
}

public String AddCRC(int line, String c) {
  String cmd = "N"+line +c;
  
  int cs = CRC16(cmd);
  
  return cmd + "*"+cs;
}

public void PlayBack(int v) {
  String lines[] = loadStrings("playback.gcode");
  sendBuffer.clear();
  for (int i = 0 ; i < lines.length; i++) {
     if (lines[i] != "") {
        QueueCMD(lines[i]);
     }
  }
}

public void Abort(int v) {
  // Empty buffer
  sendBuffer.clear();
}

public void ArmLaser(int v) {
  QueueCMD("M669");
}

public void DisarmLaser(int v) {
  QueueCMD("M670");
}

public void TestFire(int v) {
  QueueCMD("M671 S50 P100");
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
  // check for resend
  if (s.length() > 6 && s.substring(0,6).equals("Resend")) {
     // cheat and set lastLineNo to line requested!
     try {
       String s2 = s.substring(8, s.length()-1);
       lastLineNo = Integer.parseInt(s2);
     } catch (Exception e) {
       println("exception!");
       appendTextToFile("serial.log", "exception!\r\n");
     }
     resend = true;
  }
  
  if (s.length() > 1 && s.substring(0,2).equals("ok")) cts = true;
  serialLog.append(s);
  //appendTextToFile("serial.log",s);
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
  
  // resend stuff?
  if (resend) {
    serialLog.append("Resending: "+lastLineNo + " = "+ lastCmdRaw);
    appendTextToFile("serial.log","Resending: "+lastLineNo + " = "+ lastCmdRaw + "\r\n");
    SendCMD(AddCRC(lastLineNo, lastCmdRaw));
    resend = false;
    resendCount += 1;
    cp5.get(Textfield.class, "ResendErrors").setText(Integer.toString(resendCount));
  } else if (sendBuffer.size() > 0 && cts) {
    String c = sendBuffer.get(0);
    sendBuffer.remove(0);
    lastLineNo += 1;
    lastCmdRaw = c;
    SendCMD(AddCRC(lastLineNo, c));
  }
  
  // draw serial log size
  String s2 = str(sendBuffer.size());
  text(s2, 420, 300);
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
