//E' una features o e' un bug? //<>// //<>//
import apwidgets.*;
Square[][] s;
Button[] b, b2;
protected boolean con = false, imhere = true, rel = false, kel = false, scambio = false, delay = true;
int size, rx, ry, cSQ = color(0), cSQ1, nMosse = 0, nQuad = 0, Col, nCol, f1, f2, f3;
PImage rec[], play, logo;
static String scene = "", cambia="", swap[];
static boolean end = false, animazione = true, singleplayer =true, player1 = true, local = true, backpressed = false, nondevi = true, musica=true, effetti=true, endsetup = false;
String parola[], grid[], colors[], fill[], diff[], record[], col[], visual[], datiutili[], lingue[];
static int lol = 0; //Uso in button
//Variabili per l'animazione del rettangolo
int nk = 0; 
boolean cont;
float tS, sY; //
int n=0, k=0, l=0, gr = 0, g1 =0, g2=0; //Indici di array (n = griglia) (k = colori) (l = difficolta') (gr = score) (g1 , g2 = punteggi finali)
PFont font;
APMediaPlayer aplose, apswipe, aptheme, aptic, apwin;
public void settings() {
  orientation(PORTRAIT);
  size(PApplet.parseInt(displayHeight*0.5625f), displayHeight, P2D);
  //fullScreen(P2D);
  aptheme = crea("theme.mp3");
  aptheme.setLooping(true);
  aptic = crea("tic.mp3");
  apwin = crea("win.mp3");
  aplose = crea("lose.mp3");
  apswipe = crea("swipe.mp3");
}

public void setup() {
  // println(displayWidth, displayHeight);
  //println(System.getProperty("os.name"));
  rec = new PImage[2];
  font = createFont("3.ttf", 27*width/360);
  textFont(font);
  rec[0] = loadImage("0.png");
  rec[1] = loadImage("1.png");
  play = loadImage("play.png");
  logo = loadImage("logo.png");
  grid = loadStrings("griglia.txt");
  colors = loadStrings("colors.txt");
  fill = loadStrings("fill.txt");
  col = loadStrings("fill.txt");
  diff = loadStrings("diff.txt");
  lingue = loadStrings("lingue.txt");
  File f = new File(dataPath("savedata.txt"));
  if (f.exists())
    record = loadStrings(dataPath("savedata.txt"));
  else {
    record = loadStrings("vuoto.txt");
    salvataggio("savedata.txt", record);
  }
  File k = new File(dataPath("datiutili.txt"));
  if (k.exists()) {
    println("porcodio");
    datiutili = loadStrings(dataPath("datiutili.txt"));
    parola = swap = loadStrings(datiutili[0]+".txt");
    animazione = boolean(datiutili[1]);
    if (datiutili.length > 2) {
      println(datiutili);
      musica = boolean(datiutili[2]);
      effetti = boolean(datiutili[3]);
    }
  } else {
    datiutili = new String[4];
    for (int i = 0; i < datiutili.length; i++) datiutili[i] = "";
    parola = swap = loadStrings("Italiano.txt");
  }
  scene = parola[19];
  noStroke();
  textAlign(CENTER);
  imageMode(CENTER);
  scene = "logo";
  background(255);
  mouseY = height/10;
  if (musica) 
    parti(aptheme); //faccio partire la musica
  endsetup=true;
}

public void draw() {
  //println(frameRate);
  if ((mouseY > (sY+(tS*2))*height/640 || mouseY < sY*height/640) || rel) {
    nk = 0;  
    cont = false;
    stoppa(aptic);//Resetto il suono della slide
  }
  if (scene.equals("logo")) {
    nondevi = true;
    if (frameCount > 200 && !datiutili[0].equals("")) scene = parola[19];
    else if (frameCount > 200 && datiutili[0].equals("")) scene = "Linguaggiamelo";
    noTint();
    image(logo, 180*width/360, 320*height/640, 180*width/360, 180*width/360);
    if (!musica) stoppa(aptheme);
  } else if (scene.equals(parola[19])) {
    menu();
  } else if (scene.equals("Menu-b")) {
    reset(false);
    scene = parola[19];
  } else if (scene.equals("R-Play") && singleplayer) {
    gioco_1();
  } else if (scene.equals("R-Play") && !singleplayer) {
    gioco_2();
  } else if (scene.equals(parola[0])) {
    setPlay();
  } else if (scene.equals(parola[2])) {
    score();
  } else if (scene.equals(parola[1])) {
    options();
  } else if (scene.equals(parola[3])) {
    background(0);
    text("Serk", 180, 320, 40, colore(6), 6);
    text(parola[19], 180, 40, 30, colore(6), 6);
  } else if (scene.equals("Linguaggiamelo")) {
    background(0);
    text(parola[19], 180, 40, 30, colore(6), 6);
    text("< "+parola[27]+": "+parola[28]+" >", 180, 220, 30, colore(2), 2);

    if (rel && mouseY >= 180*height/640 && mouseY <= 260*height/640) scene = "x";
  } else if (scene.equals("x")) {
    cambialingua();
  }
  if (backpressed && scene.equals("R-Play")) Ink_pause();
  rel = kel = nondevi = false;
  //rect(0, 550, 360, 90, color(255));
  //text("Questo e' un banner", 180, 590, 20, color(0), 7);
}

public void salvataggio(String s, String[] save) {
  String salvo = dataPath(s);
  File f = new File(salvo);
  if (f.exists())
    f.delete();
  saveStrings(salvo, save);
}

public void options() {
  background(0);
  text(parola[19], 180, 40, 30, colore(6), 6);
  text("< "+parola[26]+" >", 180, 120, 30, colore(0+(PApplet.parseInt(!animazione))), 0+(PApplet.parseInt(!animazione)));
  text("< "+parola[27]+": "+parola[28]+" >", 180, 220, 30, colore(0), 0);
  text("< "+parola[29]+" >", 180, 320, 30, colore(2-PApplet.parseInt(!musica)), 2-PApplet.parseInt(!musica)); //verde se c'è la musica, altrimenti rossa 
  text("< "+parola[30]+" >", 180, 420, 30, colore(2-PApplet.parseInt(!effetti)), 2-PApplet.parseInt(!effetti));// -   -  ci sono gli effetti, -      -
  if (rel && mouseY >= 80*height/640 && mouseY <= 160*height/640) animazione = !animazione;
  if (rel && mouseY >= 180*height/640 && mouseY <= 260*height/640) scene = "x";
  if (rel && mouseY >= 280*height/640 && mouseY <= 360*height/640) musica = !musica;
  if (rel && mouseY >= 380*height/640 && mouseY <= 460*height/640) effetti = !effetti;
  if (!musica && rel) stoppa(aptheme);
  if (musica && rel) parti(aptheme);
}
int lingua =0;
public void cambialingua() {
  cambia = lingue[int(!(lingua+1>=lingue.length))*++lingua];
  if (lingua >= lingue.length) lingua = 0;
  parola = loadStrings(cambia+".txt");
  if (!datiutili[0].equals("")) {
    scene = parola[1];
    swap = parola;
  } else scene = "Linguaggiamelo";
}  

public void onBackPressed() {
  if (Ink.scene.equals("R-Play") && Ink.singleplayer)
    Ink.backpressed = !Ink.backpressed; 
  else if (nondevi);
  else if (!Ink.scene.equals(Ink.swap[19])) {
    Ink.scene = Ink.swap[19];
  }
  return;
}


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
    if (mouseY < 60*height/640 && mouseY > 0) scene = parola[19];
    if (rel && mouseY >= 450*height/640) {
      scene = "R-Play"; 
      creazioneGriglia(singleplayer);
      player1 = true;
    }
  } else if ( scene.equals(parola[2])) {
    if (mouseX >= 0 && mouseX <= 120*width/360 && mouseY >= 70*height/640 && mouseY <= 120*height/640 && gr >= 1) gr--;
    else if (mouseX >= 200*width/360 && mouseX <= 340*width/360 && mouseY >= 70*height/640 && mouseY <= 120*height/640 && gr < colors.length-1) gr++;
  }
}

public void mousePressed() {
  rel = false;
  nk = 0;
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
  //for (int i = 0; i < 3; i++) {     ellipse(70+(i*110), 35, 60, 60, colore(i+4));     image(cose[i], (70+(i*110))*width/360, 35*height/640, 60*width/360, 60*width/360);  }
  for (int i = 0; i < 4; i++) text(parola[i], 180, 125+(125*i), 30, colore(i), i);
}
public void setPlay() {
  background(0);
  text(parola[19], 180, 40, 30, colore(6), 6); //Menu
  text("<  "+parola[5]+""+grid[n]+"  >", 180, 100, 30, colore(0), 0); //Griglia
  //text(parola[4]+"\n"+diff[l], 180, 150, 25, colore(2), 2);
  //text("<  "+parola[4]+(l+1)+"  >", 180, 190, 25, colore(4), 4);
  text("<  "+parola[6]+""+colors[k]+"  >", 180, 280, 30, colore(4), 4); //Colore
  text(parola[0], 180, 525, 55, colore(3), 3); //Play
  text("<  "+parola[24+PApplet.parseInt(!singleplayer)]+"  >", 180, 370, 30, colore(1), 1);
  if (!singleplayer) {
    if (n < 4) n = 3;
    if (k < 2) k = 2;
  }
  //192.000 processori 86 core 17megawat
}

public void creazioneGriglia(boolean uno) {
  String x[] = split(grid[n], "x");
  s = new Square[PApplet.parseInt(x[0])][PApplet.parseInt(x[1])];
  b = new Button[PApplet.parseInt(colors[k])];
  b2 = new Button[PApplet.parseInt(colors[k])]; //UOVA DI PASQUA PER TUTTI
  size = PApplet.parseInt(sqrt(sq(s.length)+sq(s[0].length)+sq(PApplet.parseInt(colors[k]))));//PApplet.parseInt(mosse[k][2][n]); //HAHAHAHAH FANCULO SCIENZA
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
      b[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), altrocolore(i), i);
  } else { //Multi player
    for (int i = 0; i < b.length; i++)
      b[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), 500, altrocolore(i), i, 0);
    for (int i = 0; i < b2.length; i++)
      b2[i] = new Button(5+(i*60*6/PApplet.parseInt(colors[k])), 15, altrocolore(i), i, 1);
    for (int i =0; i< s.length; i++)
      for (int j = 0; j < s[0].length; j++) 
        s[i][j] = new Square(i, j, 10+(d*i), 120+(dd*j), false, d);
    s[0][0].controller(true, 1);
    s[s.length-1][s[0].length-1].controller(true, 0);
    separa();
  }
  Col = nCol = cSQ = s[rx][ry].c;
  nMosse = nQuad = 0;
  aptheme.setVolume(1.0, 1.0); //Rialzo il volume durante la partita
}

public void gioco_1() {
  visual = split(record[k], "_");
  boolean flag = true;
  background(0);

  if (!end) {
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

  if ((flag || nMosse == size) && cSQ == altrocolore(lol)) //Attendo la fine dell'animazione per fare il gameover
    gameover(flag);
  fill(255);
  if (nMosse <= size)
    text(parola[18]+""+nMosse+"/"+size, 270, 100, 30);
  text(parola[17]+visual[n], 80, 100, 30);
  text(parola[19], 180, 40, 30, colore(6), 6);
  // stroke(255);
  // noFill();
  // rect(10*width/360,120*height/640,b_x*width/360,b_y*width/360);
}
float b_x, b_y;

public void gioco_2() {
  boolean flag = true;
  background(0);
  if (!end) {
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
  translate((180*PApplet.parseInt(!player1))*width/360, (470*PApplet.parseInt(!player1))*height/640);
  textAlign(CENTER);
  rotate(radians(180)*PApplet.parseInt(!player1));
  fill(255);
  if (!end)
    text("G1:"+(g1+1)+"/ G2:"+(g2+1), 180*PApplet.parseInt(player1), 100*PApplet.parseInt(player1), 30);//color(255));
  popMatrix();
  pushMatrix();
  translate(180*width/360, (40+(495*PApplet.parseInt(!player1)))*height/640);
  textAlign(CENTER);
  rotate(radians(180)*PApplet.parseInt(!player1));
  if (!end)
    text(parola[20]+(PApplet.parseInt(player1)+1), 0, 0, 20);
  popMatrix();
}

public void score() {
  int cc = 0;
  String view[] = split(record[gr], "_");
  background(0);
  text(parola[19], 180, 40, 30, colore(6), 6);
  text("<  "+parola[6]+""+colors[gr]+"  >", 180, 110, 30, colore(4), 4);
  for (int i = 0; i < grid.length; i++) {
    int ind = i+gr*(grid.length);
    if (view[i].equals("/")) cc = 1; 
    else if (str(view[i].charAt(view[i].length()-1)).equals("%")) cc = 3; 
    else cc = 2;
    text(grid[i]+": "+view[i], 180, 160+(45*i), 22, colore(cc), cc); //Metti un play
    image(play, 320*width/360, (152.5f+(45*i))*height/640, 35*width/360, 35*width/360);
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

public void separa() {
  int i = RI(b.length-2);
  cSQ = s[0][0].c = colore(i);
  cSQ1 = s[s.length-1][s[0].length-1].c = colore(i+1);
}
public void gameover(boolean win) {
  String view[] = split(record[k], "_");
  String ve;
  if (!end) { 
    for (int i = 0; i < s.length; i++) for (int j = 0; j < s[0].length; j++)  
      if (s[i][j].controller) { 
        if (s[i][j].giocatore == 1) g1++; 
        else if (s[i][j].giocatore == 0) g2++; 
        nQuad++;
      }
    if (singleplayer) {
      if (!win && (str(view[n].charAt(view[n].length()-1)).equals("%") || view[n].equals("/"))) { 
        //Se hai perso, e il record finisce con una percentuale o non esiste
        if (view[n].length() > 2)
          ve = str(view[n].charAt(0))+""+str(view[n].charAt(1));
        else
          ve = str(view[n].charAt(0));

        if (nQuad*(100)/(s.length*s[0].length) > PApplet.parseInt(ve))
          view[n] = str(PApplet.parseInt(nQuad*(100)/(s.length*s[0].length)))+"%";
      } else if (win && (str(view[n].charAt(view[n].length()-1)).equals("%") || view[n].equals("/"))) {
        view[n] = str(nMosse);
      } else if (win && !str(view[n].charAt(view[n].length()-1)).equals("%") && !view[n].equals("/")) {
        if (nMosse < PApplet.parseInt(view[n]))
          view[n] = str(nMosse);
      }
      String deb = "";
      for (int i = 0; i < view.length; i++) {
        deb += view[i];
        if (i != view.length-1) deb += "_";
      }
      record[k] = deb;
      salvataggio("savedata.txt", record);
      aptheme.setVolume(0.3, 0.3); //Abbasso il volume per far sentire la musica
      if (effetti) {
        stoppa(apwin);
        stoppa(aplose);
        if (win) parti(apwin); 
        else parti(aplose);
      }
    }
  }
  end = true;
  for (int i = 0; i < 6; i++) //Stampo i quadrati del gameover
    if ((i <= 2 || singleplayer) && (i != 3 || (n > 0 || k > 0)) && (i != 5 || (n != grid.length-1 || k != colors.length))) {
      rect(30+(i%3*100), 400-(100*(PApplet.parseInt(i>2))), 80, 60, color(255)); //SPAGHETTICODE
      fill(0);
      text(parola[10+i], (i%3*100)+68, 430-(PApplet.parseInt(i>2)*100), 17);
    }
  if (cSQ == color(0)) fill(255);
  else fill(0);
  if (!win)  text(parola[23]+"\n"+(nQuad*(100))/(s.length*s[0].length)+"% "+parola[7], 180, 160, 35);
  else if (win && singleplayer)text(parola[8]+" \n 100% "+parola[7]+"\n"+nMosse+" "+parola[9], 180, 160, 35);
  else  text(parola[21]+g1+"\n"+parola[22]+g2, 180, 180, 35);


  if (mouseX >= 230*width/360 && mouseY >= 400*height/640 && mouseX <= 310*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
  } else if (mouseX >= 130*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && end && rel) {
    reset(false);
    scene = parola[19];
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
  } else if (mouseX >= 30*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && end && rel) {
    k = RI(colors.length); 
    n = RI(grid.length);
    creazioneGriglia(true);
    reset(false);
  }
}

public void Ink_pause() {  
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
    backpressed = false;
  } else if (mouseX >= 130*width/360 && mouseY >= 400*height/640 && mouseX <= 210*width/360 && mouseY <= 460*height/640 && rel) {
    reset(false);
    scene = parola[19];
    mouseY = -20;
    backpressed = false;
  } else if (mouseX >= 30*width/360 && mouseY >= 400*height/640 && mouseX <= 110*width/360 && mouseY <= 460*height/640 && rel) {
    scene = "R-Play";
    mouseY = -20;
    backpressed = false;
  }
}
public int RI(float x) {
  return PApplet.parseInt(random(x));
}

public int colore(int r) {
  if ( r >= 0) {
    String[] x = split(fill[r], ',');
    return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }
  return 0;
}

public int altrocolore(int r) {
  if ( r >= 0) {
    String[] x = split(col[r], ',');
    return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }
  return 0;
}

public void cambiaColore(int x) {
  for (int i = 0; i < col.length; i++) {
    String[] y = split(col[i], ',');
    int A=PApplet.parseInt(y[0]), B=PApplet.parseInt(y[1]), C=PApplet.parseInt(y[2]);
    if (x == color(A, B, C)) {
      f1 = int(CambiaF(A, B, C, f1, A));
      f2 = int(CambiaF(A, B, C, f2, B));
      f3 = int(CambiaF(A, B, C, f3, C));
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

private float CambiaF(int A, int B, int C, int F, int X) {
  if (!animazione) return X;
  if (F <= X+(X/17)*60/frameRate && F >= X-(X/17)*60/frameRate) return X;
  if (F < X) return F+(X/17)*60/frameRate; 
  else if ( F > X) return F-(max(A, max(B, C))/17)*60/frameRate;
  else return X;
}

public void movimentoRec(float y, float lx, float ts, int l) {
  tint(colore(l));
  image(rec[0], 0, (y-ts/2.5f)*height/640, lx*width/360, ts*2*width/360);
  image(rec[1], (360)*width/360, (y-ts/2.5f)*height/640, lx*width/360, ts*2*width/360);
  if (lx >= 180)
    fill(0);
  if (!cont) { 
    sY = y-ts*1.5f; 
    tS = ts;
  }
}

public void text(String a, float x, float y, float ts) {
  textSize(ts*width/360);
  text(a, x*width/360, y*height/640);
}
public void text(String a, float x, float y, float ts, int fil, int i) {
  fill(fil);
  if (mouseY >= (y-ts*1.5f)*height/640 && mouseY <= (y+ts/2)*height/640) { 
    if (effetti && nk == 0 && mousePressed) parti(aptic);
    movimentoRec(y, nk+=60*60/frameRate, ts, i);
    tint(0);
    cont = true;
    if (rel && (scene.equals(parola[19]) || a.equals(parola[19]))) {
      if (rel && (scene.equals(parola[1]) || scene.equals("Linguaggiamelo"))) {
        datiutili = new String[4];
        println("Sto salvando!");
        datiutili[0] = parola[28];
        datiutili[1] = str(animazione);
        datiutili[2] = str(musica);
        datiutili[3] = str(effetti);
        salvataggio("datiutili.txt", datiutili);
        println("Ho finito di salvare, pezzo di merda!");
      }
      scene = a;
      if (a.equals(parola[19]) && s != null) reset(false);
    } else if (scene.equals(parola[2]) && rel && i >= 1 && i <= 3 && mouseX >= 300*width/360) {
      //(152.5+(45*i))*height/640, 35*width/360, 35*width/360)
      scene = parola[0];
      singleplayer = true;
      k = gr;
      n = PApplet.parseInt((y-152.5f)/45);
    }
  } else 
  tint(fil);
  textSize(ts*width/360);
  text(a, x*width/360, y*height/640);
}

public void rect(float x, float y, float x2, float y2, int co) {
  fill(co); 
  rect(x*width/360, y*height/640, x2*width/360, y2*height/640);
}

public void ellipse(float x, float y, float dim, float dim2, int c) {
  if (c <= 0)fill(c); 
  else noFill();
  ellipse(x*width/360, y*height/640, dim*width/360, dim2*width/360);
}