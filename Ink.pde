//E' una features o e' un bug? //<>// //<>//
Square[][] s;
Button[] b, b2;
public boolean con = false, imhere = true;
boolean rel = false, kel = false, scambio = false, delay = true;
int size, rx, ry, cSQ = color(0), cSQ1;
int nMosse = 0, nQuad = 0, Col, nCol, f1, f2, f3;
PImage rec[] = new PImage[2], play;
static String scene = "Menu";
static boolean end = false, animazione = true, singleplayer =true, player1 = true, local = true;
String parola[], grid[], colors[], fill[], diff[], mosse[][][], salva[], record[];
static int lol = 0; //Uso in button
//Variabili di riavvio
public void settings() {
  orientation(PORTRAIT);
  //fullScreen();
  size(int(displayHeight*0.5625), displayHeight);
}

public void setup() {
  rec[0] = loadImage("0.png");
  rec[1] = loadImage("1.png");
  play = loadImage("play.png");
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
float tS;
public void draw() {
  //animazione = frameRate >= 40;
  if ((mouseY > (sY+(tS*2))*height/640 || mouseY < sY*height/640)) {
    nk = 0;  
    cont = false;
    //println(sY, tS);
  }

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
  rect(0, 550, 360,90, color(255));
  text("Questo è un banner", 180, 590, 20, color(0), 7);
}

void salvataggio() {
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
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 70*height/640 && mouseY <= 120*height/640 && gr >= 1) gr--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 70*height/640 && mouseY <= 120*height/640 && gr < colors.length-1) gr++;
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
  size = int(sqrt((sq(s.length)+sq(int(colors[k])+1))));//PApplet.parseInt(mosse[k][2][n]); //HAHAHAHAH FANCULO SCIENZA
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
      b[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), 500, colore(i), i, 0);
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
    text("Left: "+str(size-nMosse), 280, 100, 30);
  text("Record:"+record[n+(k*colors.length)], 80, 100, 30);
  text("Menu", 180, 40, 30, colore(6), 6);
}


void gioco_2() {
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
  translate((180*int(!player1))*width/360, (470*int(!player1))*height/640);
  textAlign(CENTER);
  rotate(radians(180)*int(!player1));
  fill(255);
  if (!end)
    text("G1:"+(g1+1)+"/ G2:"+(g2+1), 180*int(player1), 100*int(player1), 30);//color(255));
  popMatrix();
  pushMatrix();
  translate(150*width/360, (30+(505*int(!player1)))*height/640);
  textAlign(CENTER);
  rotate(radians(180)*int(!player1));
  if (!end)
    text("Player: "+(int(player1)+1)+" move's", 0, 0, 20);
  popMatrix();
}
int gr = 0;
public void score() {
  int cc = 0;
  background(0);
  text("Menu", 180, 40, 30, colore(6), 6);
  text("<  "+parola[6]+""+colors[gr]+"  >", 180, 110, 30, colore(1), 1);
  for (int i = 0; i < grid.length; i++) {
    if (record[i+(gr)*colors.length].equals("/")) cc = 3; 
    else if (str(record[i+(gr)*colors.length].charAt(record[i+(gr)*colors.length].length()-1)).equals("%")) cc = 2; 
    else cc = 4;
    text(grid[i]+": "+record[i+(gr)*colors.length], 180, 160+(45*i), 22, colore(cc), cc); //Metti un play
    image(play, 320*width/360, (152.5+(45*i))*height/640, 35*width/360, 35*width/360);
  }
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

void separa() {
  int i = RI(b.length-2);
  cSQ = s[0][0].c = colore(i);
  cSQ1 = s[s.length-1][s[0].length-1].c = colore(i+1);
}
int g1 =0, g2=0;
public void gameover(boolean win) {
  int easy = n+(k)*colors.length;
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

        if (nQuad*(100)/(s.length*s[0].length) > int(ve))
          record[easy] = str(int(nQuad*(100)/(s.length*s[0].length)))+"%";
      } else if (win && (str(record[easy].charAt(record[easy].length()-1)).equals("%") || record[easy].equals("/"))) {
        record[easy] = str(nMosse);
      } else if (win && !str(record[easy].charAt(record[easy].length()-1)).equals("%") && !record[easy].equals("/")) {
        if (nMosse < int(record[easy]))
          record[easy] = str(nMosse);
      }
      salvataggio();
    }
    //  salva = append(salva, "Numero mosse:"+str(nMosse)+" Girglia: "+ grid[n]+ " Difficoltà: "+diff[l]);
  }
  end = true;
  for (int i = 0; i < 6; i++) //Stampo i quadrati del gameover
    if ((i <= 2 || singleplayer) && (i != 3 || (n > 0 || k > 0)) && (i != 5 || (n != grid.length-1 || k != colors.length))) {
      rect(30+(i%3*100), 400-(100*(int(i>2))), 80, 60, color(255));
      fill(0);
      text(parola[10+i], (i%3*100)+68, 430-(int(i>2)*100), 17);
    }
  if (cSQ == color(0)) fill(255);
  else fill(0);
  if (!win)  text("Game over \n"+(nQuad*(100))/(s.length*s[0].length)+"% "+parola[7], 180, 160, 35);
  else if (win && singleplayer)text(parola[8]+" \n 100% "+parola[7]+"\n in "+nMosse+" "+parola[9], 180, 160, 35);
  else  text("Player1 :"+g1+"\nPlayer2 :"+g2, 180, 180, 35);

  if (mouseX >= 230*width/360 && mouseY >= 400*height/640 && mouseX <= 310*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
  } else if (mouseX >= 130*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
    scene = "Menu";
    mouseY = 20000;
  } else if (mouseX >= 130*width/360 && mouseY >= 300*height/640 && mouseX <= 210*width/360 && mouseY <= 360*height/640 && end && rel && singleplayer) {
    reset(true);
    mouseY = 20000;
  } else if (mouseX >= 230*width/360 && mouseY >= 300*height/640 && mouseX <= 310*width/360 && mouseY <= 360*height/640 && end && rel && singleplayer && (n != grid.length-1 || k != colors.length-1)) {
    if (n != grid.length-1) n++;
    else if (n == grid.length-1 && k != colors.length-1) { 
      k++; 
      n = 0;
    }
    creazioneGriglia(true);
    reset(false);
  } else if (mouseX >= 30*width/360 && mouseY >= 300*height/640 && mouseX <= 110*width/360 && mouseY <= 360*height/640 && end && rel && singleplayer && (n != 0 || k != 0)) {
    if (n != 0) n--;
    else if (n == 0 && k != colors.length-1) { 
      k--; 
      n = grid.length-1;
    }
    creazioneGriglia(true);
    reset(false);
  }
}

public void pause() {  
  rect(30, 400, 80, 60, color(255));
  rect(130, 400, 80, 60, color(255));
  rect(230, 400, 80, 60, color(255));
  fill(0);
  text(parola[16], 68, 430, 17); //Resume
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
  if( r >= 0){
  String[] x = split(fill[r], ',');
  return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }
  return 0;
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
public void movimentoRec(float y, float lx, float ts, int l) {
  tint(colore(l));
  image(rec[0], 0, (y-ts/2.5)*height/640, lx*width/360, ts*2*width/360);
  image(rec[1], (360)*width/360, (y-ts/2.5)*height/640, lx*width/360, ts*2*width/360);
  if (lx >= 180)
    fill(0);
  if (!cont) { 
    sY = y-ts*1.5; 
    tS = ts;
  }
}

public void text(String a, float x, float y, float ts) {
  textSize(ts*width/360);
  text(a, x*width/360, y*height/640);
}
float sY;
public void text(String a, float x, float y, float ts, int fil, int i) {
  fill(fil);
  if (mouseY >= (y-ts*1.5)*height/640 && mouseY <= (y+ts/2)*height/640) { 
    movimentoRec(y, nk+=60*60/frameRate, ts, i);
    tint(0);
    cont = true;
    if (rel && (scene.equals("Menu") || a.equals("Menu"))) {
      scene = a;
      if (a.equals("Menu") && s != null) reset(false);
    } else if (scene.equals(parola[2]) && rel && i >= 2 && i <= 4 && mouseX >= 300*width/360) {
      //(152.5+(45*i))*height/640, 35*width/360, 35*width/360)
      scene = parola[0];
      singleplayer = true;
      k = gr;
      n = int((y-152.5)/45);
    }
  } else tint(fil);

  textSize((ts)*width/360);
  text(a, x*width/360, y*height/640);
}

public void rect(float x, float y, float x2, float y2, color co) {
  fill(co);
  rect(x*width/360, y*height/640, x2*width/360, y2*height/640);
}

public void ellipse(float x, float y, float dim, float dim2, color c) {
  fill(c);
  ellipse(x*width/360, y*height/640, dim*width/360, dim2*width/360);
}