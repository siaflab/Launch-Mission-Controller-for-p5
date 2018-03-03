import netP5.*;
import oscP5.*;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

Calendar cal;
Date dateTo = null;
Date dateFrom = null;

PImage img;

    
OscP5 oscP5;
NetAddress myRemoteLocation;

String script = "Start monitoring the time event.";
int voiceIndex;
int voiceSpeed;

// Maximum number of matrices for CSV
int MAX_LINE = 512;
int MAX_CUE = 7;

// Line data storage
String[] datalines;

// Data array (Starting from Row 0 Column 0)
String[][] data = new String[MAX_LINE][MAX_CUE];

int m_cnt;

String remainingtime, lounchtime;

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

void setup() {
  size(600, 600);
  img = loadImage("img.png");
  
   cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Tokyo"));
   DateFormat df = new SimpleDateFormat("YYYY/MM/dd HH:mm:ss　Z");
   df.setTimeZone(cal.getTimeZone());
   String timestamp = df.format(cal.getTime());
   println(timestamp);

   println("YEAR: " + cal.get(Calendar.YEAR));
   println("MONTH: " + cal.get(Calendar.MONTH));
   println("DATE: " + cal.get(Calendar.DATE));
   println("HOUR: " + cal.get(Calendar.HOUR));
   println("MINUTE: " + cal.get(Calendar.MINUTE));
   println("SECOND: " + cal.get(Calendar.SECOND));
   println("MILLISECOND: " + cal.get(Calendar.MILLISECOND));


  // Read CSV file
  datalines = loadStrings("countdown.csv");

  // if the file can be opened
  if(datalines != null) {
  for(int i = 0; i < datalines.length; i ++){
    // Check whether it is a blank
    if(datalines[i].length() != 0) {
      // Read one line and store it as a comma delimited
      String[] values = datalines[i].split("," , -1);
      // Read all of columns
      for(int j = 0; j < MAX_CUE; j ++) {
        if(values[j] != null && values[j].length() != 0) {
          data[i][j] = values[j];
            // For console
            print(data[i][j] + "\t");
        }
      }
      // For console
      print("\n");
    }
  }
  print(datalines.length + "row data");

  /* start oscP5, listening for incoming messages at port 4558 */
  oscP5 = new OscP5(this,4556);
  /* send messages port*/
  myRemoteLocation = new NetAddress("localhost",4557);
  delay(500);
  
  OscMessage message = new OscMessage("/save-and-run-buffer");
  /* add some strings to the osc message */
  message.add("0");
  message.add("0");
  //  message.add("play 60"+"\n");//, rate: 0.4, slow: 4
  //message.add("load  \"/Users/kei/petal/petal.rb\"" + "\n" + "\n" + "cps(1)" + "\n" + "d1 \'tick(1,2,3)\', n: \"irand 8\", speed: \'-0.2 0.5\'");
  message.add("load  \"/Users/kei/petal/petal.rb\"" + "\n" + "\n" + "cps(1)" + "\n" + "d1 \'tick\', amp: \'rand 0.4 1\' ,speed: \'1 -0.2\'" + "\n" + "use_synth :hollow" + "\n" + "with_fx :reverb, mix: 0.9 do" + "\n" + "    live_loop :note1 do" + "\n" + "    play choose([:D6,:E6]), attack: 6, release: 6" + "\n" + "    sleep 8" + "\n" + "  end" + "\n" + "    live_loop :note2 do" + "\n" + "    play choose([:Fs6,:G6]), attack: 4, release: 5" + "\n" + "    sleep 10" + "\n" + "  end" + "\n" + "  " + "\n" + "  live_loop :note3 do" + "\n" + "    play choose([:A6, :Cs7]), attack: 5, release: 5" + "\n" + "    sleep 11" + "\n" + "  end" + "\n" + "  " + "\n" + "end");
  message.add("0");
  /* send the message */
  oscP5.send(message, myRemoteLocation);
  
  delay(500);
  
  voiceSpeed = 160;
  TextToSpeech.say(script, TextToSpeech.voices[8], voiceSpeed);

 }

}

void draw() {

  background(0);
  image(img, 10, 10);
   // set the voice based on mouse y
  voiceIndex = round(map(mouseY, 0, height, 0, TextToSpeech.voices.length - 1));
 
  //set the vooice speed based on mouse X
  voiceSpeed = 120;
  
   cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Tokyo"));
   DateFormat df = new SimpleDateFormat("YYYY/MM/dd HH:mm:ss");
   df.setTimeZone(cal.getTimeZone());
   String timestamp = df.format(cal.getTime());
   println(timestamp);
   //nf(cal.get(Calendar.YEAR),4) + nf(int(data[m_cnt][0]),4)+
  DateFormat ddf = new SimpleDateFormat("MMddHHmmss");
  ddf.setTimeZone(cal.getTimeZone());
  String now = ddf.format(cal.getTime());
  //String now =  nf(cal.get(Calendar.MONTH)+1,2) + nf(cal.get(Calendar.DATE),2) + nf(cal.get(Calendar.HOUR),2) + nf(cal.get(Calendar.MINUTE),2) + nf(cal.get(Calendar.SECOND),2); //年 2010,2011,...
  String missiontime = nf(int(data[m_cnt][0]),4)+"/"+nf(int(data[m_cnt][1]),2)+"/"+nf(int(data[m_cnt][2]),2)+" "+nf(int(data[m_cnt][3]),2)+":"+nf(int(data[m_cnt][4]),2)+":"+nf(int(data[m_cnt][5]),2);
  String mission = nf(int(data[m_cnt][1]),2)+nf(int(data[m_cnt][2]),2)+nf(int(data[m_cnt][3]),2)+nf(int(data[m_cnt][4]),2)+nf(int(data[m_cnt][5]),2);
  //println( "missiontime: " + missiontime );  
  int now_i = Integer.valueOf(now);
  int missiontime_i = Integer.valueOf(mission);
  println( "onw        : " + now_i );  
  println( "missiontime: " + missiontime_i ); 
  
  if(now_i == missiontime_i){
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage message = new OscMessage("/save-and-run-buffer");
    /* add some strings to the osc message */
    message.add("0");
    message.add("0");
    message.add("play 60,amp:2"+"\n");
    message.add("0");
    /* send the message */
    oscP5.send(message, myRemoteLocation);
    
    delay(100);
    script = data[m_cnt][6];
    TextToSpeech.say(script, TextToSpeech.voices[8], voiceSpeed);
    m_cnt++;
  }
  
  if(m_cnt==datalines.length-1){
    OscMessage myMessage = new OscMessage("/stop-all-jobs");
    oscP5.send(myMessage, myRemoteLocation); 
  }
 
  fill(255);
  text("Click to hear " + TextToSpeech.voices[voiceIndex] + "\nsay \"" + script + "\"\nat speed " + mouseX, 10, 280);
 
  fill(128);
  text("Mouse X sets voice speed.\nMouse Y sets voice.", 10, 325);
  
    // help text
  fill(255);
  
  text("now                ：" + timestamp, 10, 180);
  text("next event      ：" + missiontime, 10, 200);
  text("task                ：" + m_cnt + " /" + data[m_cnt][6], 10, 220);

    // Create a date
    try {
        cal = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        df.setTimeZone(cal.getTimeZone());
        dateTo = df.parse(nf(int(data[m_cnt][0]),4)+"/"+nf(int(data[m_cnt][1]),2)+"/"+nf(int(data[m_cnt][2]),2)+" "+nf(int(data[m_cnt][3]),2)+":"+nf(int(data[m_cnt][4]),2)+":"+nf(int(data[m_cnt][5]),2));      
        dateFrom = df.parse(timestamp);
    } catch (ParseException e) {
        e.printStackTrace();
    }
  
    //// Converts a date to a long value
    //long dateTimeTo = dateTo.getTime();
    //long dateTimeFrom = dateFrom.getTime();
    //long one_date_time = 2646*1000000;
    //long diffDays = (dateTimeTo - dateTimeFrom);
    ////DateFormat df = new SimpleDateFormat("YYYY/MM/dd HH:mm:ss");
    //text(df.format(diffDays), 10, 160);


    long millis1 = cal.getTimeInMillis();
    //System.out.println("millis1 + "msec elapsed");

    Calendar cal2 = Calendar.getInstance();

    cal2.clear();
    cal2.set(int(data[m_cnt][0]), int(data[m_cnt][1]), int(data[m_cnt][2]), int(data[m_cnt][3]), int(data[m_cnt][4]), int(data[m_cnt][5]));
    long millis2 = cal2.getTimeInMillis();
    //System.out.println(millis2 + "msec elapsed");

    long diff = millis2 - millis1;
    //System.out.println("The time difference is" + diff  + "msec");

    diff = diff / 1000;    /* 秒以下切捨て */
    diff++;
    long se = diff % 60;
    diff = diff / 60;

    long mi = diff % 60;
    diff = diff / 60;

    long ho = diff % 24;
    diff = diff / 24;
    long day = (diff / 365);
    diff = diff / 365;
    long mon = (diff  % 12);
    diff = diff / 12;
    long ya = diff;
    

    //println(nf(int(ya),4) + "/" + nf(int(mon),2) + "/" + nf(int(day),2) + " " + nf(int(ho),2) + ":" + nf(int(mi),2) + ":" + nf(int(se),2));
    text("remaining time:"+nf(int(ya),4) + "/" + nf(int(mon),2) + "/" + nf(int(day),2) + " " + nf(int(ho),2) + ":" + nf(int(mi),2) + ":" + nf(int(se),2), 10, 240);
  
    Calendar cal3 = Calendar.getInstance();

    cal3.clear();
    cal3.set(int(data[datalines.length-1][0]), int(data[datalines.length-1][1]), int(data[datalines.length-1][2]), int(data[datalines.length-1][3]), int(data[datalines.length-1][4]), int(data[datalines.length-1][5]));
    long millis3 = cal3.getTimeInMillis();
    //System.out.println("millis3 + "msec elapsed");

    long diff2 = millis3 - millis1;
    //System.out.println("The time difference is" + diff2  + "msec");

    diff2 = diff2 / 1000;    /* 秒以下切捨て */
    diff2++;
    long se2 = diff2 % 60;
    diff2 = diff2 / 60;

    long mi2 = diff2 % 60;
    diff2 = diff2 / 60;

    long ho2 = diff2 % 24;
    diff2 = diff2 / 24;
    long day2 = (diff2 / 365);
    diff2 = diff2 / 365;
    long mon2 = (diff2  % 12);
    diff2 = diff2 / 12;
    long ya2 = diff2;
    
    text("launch time      :"+nf(int(ya2),4) + "/" + nf(int(mon2),2) + "/" + nf(int(day2),2) + " " + nf(int(ho2),2) + ":" + nf(int(mi2),2) + ":" + nf(int(se2),2), 10, 160);

}

void mousePressed() {
  // say something
  TextToSpeech.say(script, TextToSpeech.voices[voiceIndex], voiceSpeed);
}

// the text to speech class
import java.io.IOException;
 
static class TextToSpeech extends Object {
 
  // Store the voices, makes for nice auto-complete in Eclipse
 
  // male voices
  static final String ALEX = "Alex";
  static final String BRUCE = "Bruce";
  static final String FRED = "Fred";
  static final String JUNIOR = "Junior";
  static final String RALPH = "Ralph";
 
  // female voices
  static final String AGNES = "Agnes";
  static final String KATHY = "Kathy";
  static final String PRINCESS = "Princess";
  static final String VICKI = "Vicki";  //●
  static final String VICTORIA = "Victoria";
 
  // novelty voices
  static final String ALBERT = "Albert";
  static final String BAD_NEWS = "Bad News";
  static final String BAHH = "Bahh";
  static final String BELLS = "Bells";
  static final String BOING = "Boing";
  static final String BUBBLES = "Bubbles";
  static final String CELLOS = "Cellos";
  static final String DERANGED = "Deranged";
  static final String GOOD_NEWS = "Good News";
  static final String HYSTERICAL = "Hysterical";
  static final String PIPE_ORGAN = "Pipe Organ";
  static final String TRINOIDS = "Trinoids";
  static final String WHISPER = "Whisper";
  static final String ZARVOX = "Zarvox";
 
  // throw them in an array so we can iterate over them / pick at random
  static String[] voices = {
    ALEX, BRUCE, FRED, JUNIOR, RALPH, AGNES, KATHY,
    PRINCESS, VICKI, VICTORIA, ALBERT, BAD_NEWS, BAHH,
    BELLS, BOING, BUBBLES, CELLOS, DERANGED, GOOD_NEWS,
    HYSTERICAL, PIPE_ORGAN, TRINOIDS, WHISPER, ZARVOX
  };
 
  // this sends the "say" command to the terminal with the appropriate args
  static void say(String script, String voice, int speed) {
    try {
      Runtime.getRuntime().exec(new String[] {"say", "-v", voice, "[[rate " + speed + "]]" + script});
    }
    catch (IOException e) {
      System.err.println("IOException");
    }
  }
 
  // Overload the say method so we can call it with fewer arguments and basic defaults
  static void say(String script) {
    // 200 seems like a resonable default speed
    say(script, ALEX, 200);
  }
 
}
