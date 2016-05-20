package processing.test.ink;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.File; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ink extends PApplet {

//E' una features o e' un bug? //<>// //<>//

Square[][] s;
Button[] b, b2;
public boolean con = false, imhere = true;
boolean rel = false, kel = false, scambio = false, delay = true;
int size, rx, ry, cSQ = color(0), cSQ1;
int nMosse = 0, nQuad = 0, Col, nCol, f1, f2, f3;
PImage[] rec = new PImage[2];
static String scene = "Menu";
static boolean end = false, animazione = true, singleplayer =true, player1 = true, local = true;
String parola[], grid[], colors[], fill[], diff[], mosse[][][], salva[], record[];
static int lol = 0; //Uso in button
//Variabili di riavvio
public void settings() {
  orientation(PORTRAIT);
  fullScreen(P2D);
  //size(int(displayHeight*0.5625), displayHeight-50);
}

public void setup() {
  rec[0] = loadImage("0.png");
  rec[1] = loadImage("1.png");
  String x;
  int jj = RI(3);
  if (jj == 0) x = "eng";
  else if (jj == 1) x ="mat";
  else x = "ita";
  parola = loadStrings(x+".txt");
  grid = loadStrings("griglia.txt");
  colors = loadStrings("colors.txt");
  fill = loadStrings("fill.txt");
  diff = loadStrings("diff.txt");
  File f = new File(dataPath("savedata.txt"));
  if (f.exists())
    record = loadStrings(dataPath("savedata.txt"));
  else {
    record = loadStrings("vuoto.txt");
    salvataggio();
  }
  mosse = new String[colors.length][diff.length][grid.length];
  for (int i = 0; i < mosse.length; i++) 
    for (int j =0; j < diff.length; j++) {
      mosse[i][j] = loadStrings(3+i+"-"+j+"col.txt");
    }
  noStroke();
  textAlign(CENTER);
  imageMode(CENTER);
  //frameRate(10);
}

public void draw() {
  //animazione = frameRate >= 40;
  cont = false;
  if (scene.equals("Menu")) {
    menu();
  } else if (scene.equals("Menu-b")) {
    reset(false);
    scene = "Menu";
  } else if (scene.equals("Play-b") && singleplayer) {
    gioco_1();
    pause();
  } else if (scene.equals("R-Play") && singleplayer) {
    gioco_1();
  } else if (scene.equals("R-Play") && !singleplayer) {
    gioco_2();
  } else if (scene.equals(parola[0])) {
    setPlay();
  } else if (scene.equals(parola[2])) {
    score();
  } else if (scene.equals(parola[1])) {
    background(230);
    String[] z = split(parola[15], "\n");
    for (int i = 0; i < z.length; i++)  text(z[i], 180, 30+(i*30), 35);
    if (rel) scene = "Menu";
  } else if (scene.equals(parola[3])) {
    background(230);
    text("Serk (obviously)", 180, 320, 40);
    if (rel) scene = "Menu";
  }
  rel = kel = false;
  if (!cont) nk = 0;
}

public void salvataggio() {
  String salvo = dataPath("savedata.txt");
  File f = new File(salvo);
  if (f.exists())
    f.delete();
  saveStrings(salvo, record);
}

/*
  public void onBackPressed(){
 if(Ink.scene.equals("R-Play")){
 Ink.scene = "Play-b"; 
 } else if(Ink.scene.equals("Play-b")){
 Ink.scene = "R-Play";
 } else {
 Ink.scene = "Menu"; 
 }
 }
 */

public void mouseReleased() {
  rel = true;
  if (scene.equals(parola[0])) {
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 60*height/640 && mouseY <= 140*height/640 && n >= 1) n--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 60*height/640 && mouseY <= 140*height/640 && n < grid.length-1) n++;
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 150*height/640 && mouseY <= 230*height/640 && l >= 1) l--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 150*height/640 && mouseY <= 230*height/640 && l < diff.length-1) l++;
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 240*height/640 && mouseY <= 320*height/640 && k >= 1) k--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 240*height/640 && mouseY <= 320*height/640 && k < colors.length-1) k++;
    if (mouseY >= 320*height/640 && mouseY <= 400*height/640) singleplayer = !singleplayer;
    if (mouseY < 60*height/640 && mouseY > 0) scene = "Menu";
    if (rel && mouseY >= 450*height/640) {
      scene = "R-Play"; 
      creazioneGriglia(singleplayer);
    }
  } else if ( scene.equals(parola[2])) {
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 80*height/640 && mouseY <= 160*height/640 && gr >= 1) gr--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 80*height/640 && mouseY <= 160*height/640 && gr < colors.length-1) gr++;
  }
}

public void mousePressed() {
  rel = false;
  scambio = false;
}

public void keyPressed() {
  kel = true;
}

public void keyReleased() {
  kel = false;
}
public void menu() {
  background(0);
  for (int i = 0; i < 3; i++) ellipse(70+(i*110), 35, 60, 60, colore(i+4));
  for (int i = 0; i < 4; i++) text(parola[i], 180, 125+(125*i), 30, colore(i), i);
}
int n=0, k=0, l=0; //Indici di array (n = griglia) (k = colori) (l = difficolta')
public void setPlay() {
  background(0);
  text("Menu", 180, 40, 30, colore(6), 6);
  text("<  "+parola[5]+""+grid[n]+"  >", 180, 100, 30, colore(0), 0);
  //text(parola[4]+"\n"+diff[l], 180, 150, 25, colore(2), 2);
  //text("<  "+parola[4]+(l+1)+"  >", 180, 190, 25, colore(4), 4);
  text("<  "+parola[6]+""+colors[k]+"  >", 180, 280, 30, colore(1), 1);
  text(parola[0], 180, 525, 55, colore(2), 2); //Play
  if (singleplayer) text("<  Singleplayer  >", 180, 370, 30, colore(3), 3);
  else text("<  Multiplayer  >", 180, 370, 30, colore(3), 3);
  if (!singleplayer) {
    if (n < 4) n = 4;
    if (k < 2) k = 2;
  }
  //192.000 processori 86 core 17megawat
}

public void creazioneGriglia(boolean uno) {
  String x[] = split(grid[n], "x");
  s = new Square[PApplet.parseInt(x[0])][PApplet.parseInt(x[1])];
  b = new Button[PApplet.parseInt(colors[k])];
  b2 = new Button[PApplet.parseInt(colors[k])]; //UOVA DI PASQUA PER TUTTI
  size = PApplet.parseInt(mosse[k][2][n]); //HAHAHAHAH FANCULO SCIENZA
  float d = 340/s.length;
  float dd;
  if (s.length == s[0].length) dd = d;
  else dd = 500/s[0].length;
  if (uno) { //Single player
    for (int i =0; i< s.length; i++)
      for (int j = 0; j < s[0].length; j++) 
        s[i][j] = new Square(i, j, 10+(d*i), 120+(dd*j), false, d);
    s[0][0].controller(true, 0);
    for (int i = 0; i < b.length; i++)
      b[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), colore(i), i);
  } else { //Multi player
    for (int i = 0; i < b.length; i++)
      b[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), 580, colore(i), i, 0);
    for (int i = 0; i < b2.length; i++)
      b2[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), 15, colore(i), i, 1);
    for (int i =0; i< s.length; i++)
      for (int j = 0; j < s[0].length; j++) 
        s[i][j] = new Square(i, j, 10+(d*i), 120+(dd*j), false, d);
    s[0][0].controller(true, 1);
    s[s.length-1][s[0].length-1].controller(true, 0);
    separa();
  }
  Col = nCol = cSQ = s[rx][ry].c;
  nMosse = nQuad = 0;
}

public void gioco_1() {
  boolean flag = true;
  background(0);
  //noStroke();
  if (!end && animazione) {
    if (!con || nMosse > 0)
      cambiaColore(Col);
    if (imhere) {
      cSQ = color(f1, f2, f3);
      if (f1 > 0) f1-=17;
      if ( f2 >0) f2-=17;
      if (f3 >0) f3-=17;
      if (cSQ == color(0)) { 
        con = false;
        imhere = false;
      }
    }
  }
  for (int j = 0; j < s[0].length; j++)
    for (int i = 0; i < s.length; i++) {
      if (!s[i][j].controller())
        flag = false;
      else {
        s[i][j].c = cSQ;
      }
      s[i][j].view();
    }
  for (int i = 0; i < b.length; i++)
    b[i].view();

  if ((flag || nMosse == size) && cSQ == colore(lol)) //Attendo la fine dell'animazione per fare il gameover
    gameover(flag);
  fill(255);
  if (nMosse <= size)
    text(nMosse+"/"+size, 180, 620, 20);
  text("Record:"+record[n+(k*grid.length)], 180, 500, 20);
  text("Menu", 180, 40, 30, colore(6), 6);
}


public void gioco_2() {
  boolean flag = true;
  background(0);
  if (!end && animazione) {
    if (!con || nMosse > 0 && delay)
      cambiaColore(Col);
  }
  for (int i = 0; i < b.length; i++) {
    if (player1)b[i].view();
    else  b2[i].view();
    //orco
  }
  for (int i=0; i < s.length; i++)
    for (int j = 0; j < s[0].length; j++) {
      s[i][j].view();
      if (!s[i][j].controller())
        flag = false; 
      else {
        if (s[i][j].giocatore == 0)
          s[i][j].c = cSQ;
        else
          s[i][j].c = cSQ1;
      }
    }

  if ((flag)) //Attendo la fine dell'animazione per fare il gameover
    gameover(flag);

  if (cSQ == colore(lol)) {
    player1 = delay = false;
    lol = -1;
  }
  if (cSQ1 == colore(lol)) {
    player1 = true;
    delay = false;
    lol = -1;
  }
  pushMatrix();
  translate(180*PApplet.parseInt(!player1), 520*PApplet.parseInt(!player1));
  textAlign(CENTER);
  rotate(radians(180)*PApplet.parseInt(!player1));
  fill(255);
  if (!end)
    text("G1:"+(g1+1)+"/ G2:"+(g2+1), 180*PApplet.parseInt(player1), 100*PApplet.parseInt(player1), 30);//color(255));
  popMatrix();
  pushMatrix();
  translate(150, 30+(565*PApplet.parseInt(!player1)));
  textAlign(CENTER);
  rotate(radians(180)*PApplet.parseInt(!player1));
  if (!end)
    text("Player: "+(PApplet.parseInt(player1)+1)+" move's", 0, 0, 20);
  popMatrix();
}
int gr = 0;
public void score() {
  int cc = 0;
  background(0);
  text("Menu", 180, 40, 30, colore(6), 6);
  text("<  "+parola[6]+""+colors[gr]+"  >", 180, 120, 30, colore(1), 1);
  for (int i = 0; i < grid.length; i++) {
    if (record[i*(gr+1)].equals("/")) cc = 3; 
    else if (str(record[i*(gr+1)].charAt(record[i*(gr+1)].length()-1)).equals("%")) cc = 2; 
    else cc = 4;
    text(grid[i]+": "+record[i*(gr+1)], 180, 180+(50*i), 22, colore(cc), cc);
  }  
  //if (rel) scene = "Menu";
}

public void reset(boolean replay) {
  rx = 0;
  ry = 0;
  player1 = true;
  for (int i =0; i< s.length; i++)
    for (int j = 0; j < s[0].length; j++) {
      if (replay) {
        s[i][j].controller(false, 2);
      } else {
        s[i][j].controller(false, 2);
        s[i][j].realC = s[i][j].c = s[i][j].nc = s[i][j].NC = s[i][j].colore();
      }
    }
  if (singleplayer)
    s[rx][ry].controller(true, 0);
  else {
    s[0][0].controller(true, 1);
    s[s.length-1][s[0].length-1].controller(true, 0);
    separa();
  }
  Col = cSQ = nCol;
  nMosse = g1 = g2 = nQuad = f1 = f2 = f3 = 0;
  end = false;
  imhere = true;
}

public void separa() {
  int i = RI(b.length-2);
  cSQ = s[0][0].c = colore(i);
  cSQ1 = s[s.length-1][s[0].length-1].c = colore(i+1);
}
int g1 =0, g2=0;
public void gameover(boolean win) {
  int easy = n+(k*grid.length);
  String ve;
  if (!end) { 
    for (int i = 0; i < s.length; i++) for (int j = 0; j < s[0].length; j++)  
      if (s[i][j].controller) { 
        if (s[i][j].giocatore == 1) g1++; 
        else if (s[i][j].giocatore == 0) g2++; 
        nQuad++;
      }
    // score = append(score, str(score.length+1)+"  :"+str((nQuad*(100))/(s.length*s[0].length))+"% Complete");
    if (singleplayer) {
      if (!win && (str(record[easy].charAt(record[easy].length()-1)).equals("%") || record[easy].equals("/"))) { 
        //Se hai perso, e il record finisce con una percentuale o non esiste
        if (record[easy].length() > 2)
          ve = str(record[easy].charAt(0))+""+str(record[easy].charAt(1));
        else
          ve = str(record[easy].charAt(0));

        if (nQuad*(100)/(s.length*s[0].length) > PApplet.parseInt(ve))
          record[easy] = str(PApplet.parseInt(nQuad*(100)/(s.length*s[0].length)))+"%";
      } else if (win && (str(record[easy].charAt(record[easy].length()-1)).equals("%") || record[easy].equals("/"))) {
        record[easy] = str(nMosse);
      } else if (win && !str(record[easy].charAt(record[easy].length()-1)).equals("%") && !record[easy].equals("/")) {
        if (nMosse < PApplet.parseInt(record[easy]))
          record[easy] = str(nMosse);
      }
      salvataggio();
    }
    //  salva = append(salva, "Numero mosse:"+str(nMosse)+" Girglia: "+ grid[n]+ " Difficolt\u00e0: "+diff[l]);
  }
  end = true;
  rect(30, 400, 80, 60, color(255));
  rect(130, 400, 80, 60, color(255));
  rect(230, 400, 80, 60, color(255));
  if (singleplayer)
    rect(130, 300, 80, 60, color(255));
  if (cSQ == color(0)) fill(255);
  else fill(0);
  if (!win)  text("Game over \n"+(nQuad*(100))/(s.length*s[0].length)+"% "+parola[7], 180, 160, 35);
  else if (win && singleplayer)text(parola[8]+" \n 100% "+parola[7]+"\n in "+nMosse+" "+parola[9], 180, 160, 35);
  else  text("Player1 :"+g1+"\nPlayer2 :"+g2, 180, 180, 35);
  fill(0);
  text(parola[10], 68, 430, 17); //Share
  text(parola[11], 168, 430, 17); //Menu
  text(parola[12], 268, 430, 17); //Reset
  if (singleplayer)
    text(parola[14], 168, 330, 17); //Retry
  if (mouseX >= 230*width/360 && mouseY >= 400*height/640 && mouseX <= 310*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
  } else if (mouseX >= 130*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
    scene = "Menu";
    mouseY = 20000;
  } else if (mouseX >= 130*width/360 && mouseY >= 300*height/640 && mouseX <= 210*width/360 && mouseY <= 360*height/640 && end && rel && singleplayer) {
    reset(true);
    mouseY = 20000;
  }
}

public void pause() {  
  rect(30, 400, 80, 60, color(255));
  rect(130, 400, 80, 60, color(255));
  rect(230, 400, 80, 60, color(255));
  fill(0);
  text(parola[13], 68, 430, 17); //Resume
  text(parola[11], 168, 430, 17); //Menu
  text(parola[12], 268, 430, 17); //Reset
  if (mouseX >= 230*width/360 && mouseY >= 400*height/640 && mouseX <= 310*width/360 && mouseY <= 460*height/640 &&  rel) {
    reset(false);
    scene = "R-Play";
  } else if (mouseX >= 130*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && rel) {
    reset(false);
    scene = "Menu";
    mouseY = -20;
  } else if (mouseX >= 30*width/360 && mouseY >= 400*height/640 && mouseX <= 110*width/360 && mouseY <= 460*height/640 && rel) {
    scene = "R-Play";
    mouseY = -20;
  }
}
public int RI(float x) {
  return PApplet.parseInt(random(x));
}

public int colore(int r) {
  if (r >= 0) {
    String[] x = split(fill[r], ',');
    return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }
  return 1;
}

public void cambiaColore(int x) {
  for (int i = 0; i < fill.length; i++) {
    String[] y = split(fill[i], ',');
    int A=PApplet.parseInt(y[0]), B=PApplet.parseInt(y[1]), C=PApplet.parseInt(y[2]);
    if (x == color(A, B, C)) {
      if (f1 <= A) f1+= (A/17)*60/frameRate;
      else f1 = A;

      if (f2 < B) f2+= (B/17)*60/frameRate; 
      else f2 = B;

      if (f3 < C) f3+= (C/17)*60/frameRate; 
      else f3 = C;
    }
    if (player1||singleplayer) {
      cSQ = color(f1, f2, f3);
    } else {
      cSQ1 = color(f1, f2, f3);
    }
  }

  if (cSQ == x || cSQ1 == x ) {
    con = true;
  } else con = false;
}

int nk = 0;
boolean cont;
public void movimentoRec(float y, float nk, float ts, int l) {
  tint(colore(l));
  image(rec[0], 0, (y-ts/2.5f)*height/640, nk*width/360, ts*2*width/360);
  image(rec[1], (360)*width/360, (y-ts/2.5f)*height/640, nk*width/360, ts*2*width/360);
  if (nk >= 180)
    fill(0);
}

public void text(String a, float x, float y, float ts) {
  textSize(ts*width/360);
  text(a, x*width/360, y*height/640);
}

public void text(String a, float x, float y, float ts, int fil, int i) {
  fill(fil);
  if (mouseY >= (y-ts*2)*height/640 && mouseY <= (y+ts/2)*height/640) { 
    movimentoRec(y, nk+=60*60/frameRate, ts, i);
    cont = true;
    if (rel && (scene.equals("Menu") || a.equals("Menu"))) {
      scene = a;
      if (a.equals("Menu") && s != null) reset(false);
    } else if(scene.equals(parola[2]) && rel && i >= 2 && i <= 4) {
       scene = parola[0];
       singleplayer = true;
       k = gr;
       n = PApplet.parseInt((y-180)/50);
    }
  } 
  textSize((ts)*width/360);
  text(a, x*width/360, y*height/640);
}

public void rect(float x, float y, float x2, float y2, int co) {
  fill(co);
  rect(x*width/360, y*height/640, x2*width/360, y2*height/640);
}

public void ellipse(float x, float y, float dim, float dim2, int c) {
  fill(c);
  ellipse(x*width/360, y*height/640, dim*width/360, dim2*width/360);
}
public class Button {
  private int px, c, py, dim;
  public int i;
  private int turno;
  Button() {
  }
  Button(int px, int c, int i) {
    this.px = px;
    this.c = c;
    this.i = i;
    py = 530;
    dim = 50;
    turno = 0;
  }
  Button(int px, int py, int c, int i, int turno) {
    this.px = px;
    this.c = c;
    this.i = i;
    this.py = py;
    this.turno = turno;
    dim = 35;
  }
  public void view() {
    rect(px, py, 50*6/PApplet.parseInt(colors[k]), dim, color(c));
    fill(0);
    text(str(i), px+25*6/PApplet.parseInt(colors[k]), py+dim/2, 20);
    if (((mouseX >= px*width/360 && mouseX <= (px+(50*6/PApplet.parseInt(colors[k])))*width/360 && mouseY >= py*height/640 && mouseY <= (py+dim)*height/640 && rel) || (str(key).equals(str(i)) && kel)) 
      && !end && scene.equals("R-Play") && (con || !animazione)) { //Se clicci sul bottone, il gioco non \u00e8 finito, stai giocando e \u00e8 finita l'animazione oppure non c'\u00e8 allora fai..
      println("x");
      for (int j = 0; j < s[0].length; j++)
        for (int i = 0; i < s.length; i++)
          if (s[i][j].controller() && turno == s[i][j].giocatore)
            if (s[i][j].c != this.c)
              if (s[i][j].realC != this.c && (s[i][j].realC != colore(lol)||singleplayer)) {// && (s[0][0].realC != s[s.length-1][s[0].length-1].realC || singleplayer)) {
                Col = s[i][j].realC = this.c;
                if (!animazione && player1) cSQ = this.c;
                if (!animazione && !player1) cSQ1 = this.c;
                scambio = true;
              } //else imhere = true;
      if (scambio) {
        println("sc");
        lol = this.i;
        delay = true;
        nMosse++;
        scambio = false;
      }
      rel = false;
      mouseX = 0;
    } else if (mouseX >= px*width/360 && mouseX <= (px+(50*6/PApplet.parseInt(colors[k])))*width/360 && mouseY >= 530*height/640 && mouseY <= 580*height/640 ) {
    }
  }
}
public class Square {
  private int x, y;
  private float  px, py, dim;
  int c, realC;
  int nc, NC;
  private boolean controller;
  public int giocatore = 2;
  Square() {
  }
  Square (int px, int py) {
    this.px = px;
    this.py = py;
    c = realC = colore();
  }

  Square (int x, int y, float px, float py, boolean controller, float dim) {
    this.x = x;
    this.y = y;
    this.px = px;
    this.py = py;
    this.dim = dim;
    this.controller = controller;
    c = realC = nc = NC= colore();
  }

  Square (int x, int y, int px, int py, boolean controller) {
    this.x = x;
    this.y = y;
    this.px = px;
    this.py = py;
    this.controller = controller;
    c = realC = colore();
  }

  public void view() {
    int C;
    if (controller) {
      if (c == Col || nMosse == 0)
        newController();
      C = c;
    } else
      C = realC;
    //noStroke();    
    rect(px, py, dim, dim, color(C));

    /* if (giocatore == 0) {
     fill(color(0));
     text("x", px+dim/2, py+dim/2, 10);
     } else if ( giocatore == 1) {
     fill(color(0));
     text("y", px+dim/2, py+dim/2, 10);
     } else {
     //fill(color(0));
     //text("z", px+dim/2, py+dim/2, 10);
     }
     }*/
  }

  public int colore() {
    String[] x = split(fill[RI(b.length)], ',');
    return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }

  public void newController() {
    if (x+1 != s.length) {
      pigrizia(x+1, y);
    }
    if (x-1 >= 0) {
      pigrizia(x-1, y);
    }
    if (y+1 != s[0].length) {
      pigrizia(x, y+1);
    }
    if (y-1 >= 0) {
      pigrizia(x, y-1);
    }
  }

  public void pigrizia(int a, int b) {
    if ((str(s[a][b].realC).equals(str(s[x][y].realC)) || str(s[a][b].c).equals(str(s[x][y].c))) && s[a][b].giocatore == 2) {
      s[a][b].controller = true;
      s[a][b].giocatore = s[x][y].giocatore;
      if (giocatore == 0) g2++;
      else if (giocatore == 1) g1++;
      //  println("Succede con:"+a+"-"+b+"  gioc:"+s[a][b].giocatore);
    }
  }
  public void controller(boolean b) {
    controller = b;
  }

  public void controller(boolean ll, int giocatore) {
    controller = ll;
    this.giocatore = giocatore;
    c = nc;
    realC = NC;
  }
  public boolean controller() {
    return controller;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Ink" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
