public class Square {
  private int x, y;
  private float  px, py, dim;
  int c, realC;
  int nc, NC;
  private boolean controller;
  public int giocatore = 2;
  Square (int x, int y, float px, float py, boolean controller, float dim) {
    this.x = x;
    this.y = y;
    this.px = px;
    this.py = py;
    this.dim = dim;
    this.controller = controller;
    c = realC = nc = NC= colore();
  }
  public void view() {
    int C;
    if (controller) {
      if (c == Col || nMosse == 0)
        newController();
      C = c;
    } else {
      C = realC;
    }
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
    String[] x = split(col[RI(b.length)], ',');
    return color(PApplet.parseInt(x[0]), PApplet.parseInt(x[1]), PApplet.parseInt(x[2]));
  }

  public void newController() {
    if (x+1 != s.length) pigrizia(x+1, y);
    if (x-1 >= 0) pigrizia(x-1, y);
    if (y+1 != s[0].length) pigrizia(x, y+1);
    if (y-1 >= 0) pigrizia(x, y-1);
  }

  public void pigrizia(int a, int b) {
    if ((str(s[a][b].realC).equals(str(s[x][y].realC)) || str(s[a][b].c).equals(str(s[x][y].c))) && s[a][b].giocatore == 2) {
      s[a][b].controller = true;
      s[a][b].giocatore = s[x][y].giocatore;
      if (giocatore == 0) g2++;
      else if (giocatore == 1) g1++;
    }
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