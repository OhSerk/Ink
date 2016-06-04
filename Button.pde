public class Button {
  private int px, c, py, dim;
  public int i;
  private int turno;
  Button(int px, int c, int i) {
    this.px = px;
    this.c = c;
    this.i = i;
    py = 480;
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
    stroke(255);
    rect(px, py, 50*6/PApplet.parseInt(colors[k]), 50*6/PApplet.parseInt(colors[k]), color(c));
    fill(0);
    noStroke();

    // text(str(i), px+25*6/PApplet.parseInt(colors[k]), py+dim/2, 20);
    if (((mouseX >= px*width/360 && mouseX <= (px+(50*6/PApplet.parseInt(colors[k])))*width/360 && mouseY >= py*height/640 && mouseY <= (py+(50*6/PApplet.parseInt(colors[k])))*height/640 && rel)
      || (str(key).equals(str(i)) && kel)) && !end && scene.equals("R-Play") && con) { //Se clicci sul bottone, il gioco non è finito, stai giocando e è finita l'animazione oppure non c'è allora fai..
      //println("x");
      for (int j = 0; j < s[0].length; j++)
        for (int i = 0; i < s.length; i++)
          if (s[i][j].controller() && turno == s[i][j].giocatore)
            if (s[i][j].realC != this.c && s[i][j].c != this.c && (s[i][j].realC != colore(lol)||singleplayer)) {// && (s[0][0].realC != s[s.length-1][s[0].length-1].realC || singleplayer)) {
              Col = s[i][j].realC = this.c;
              scambio = true;
            } //else imhere = true;
      if (scambio) {
        //println("sc");
        lol = this.i;
        delay = true;
        nMosse++;
        scambio = false;
        if (effetti && animazione) {           stoppa(apswipe);         parti(apswipe);}
      }
      rel = false;
      mouseX = 0;
    } else if (mouseX >= px*width/360 && mouseX <= (px+(50*6/PApplet.parseInt(colors[k])))*width/360 && mouseY >= 530*height/640 && mouseY <= 580*height/640 ) {
    }
  }
}