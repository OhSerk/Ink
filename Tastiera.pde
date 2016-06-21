/*public class Keyboard {
  String Key;
  float x, y, si;
  Keyboard(String Key, float x, float y, float si) {
    this.Key = Key;
    this.x = x;
    this.y = y;
    this.si = si;
  }

  public void view() {
    stroke(255);
    rect(x-15, y-20, 30, 30, color(0));
    if (mouseX >= (x-15)*width/360 && mouseX <= (x+15)*width/360 && mouseY >= (y-20)*height/640 && mouseY <= (y+10)*height/640) {
      fill(255, 0, 0);
      if (rel) {
        if (!Key.equals("←") && nomeGiocatore[1].length() <= 10)
          if (nomeGiocatore[1].length() >= 1)
            nomeGiocatore[1] += Key.toLowerCase();
          else 
          nomeGiocatore[1] += Key;
        else if (Key.equals("←")) {
          String deb = "";
          for (int i = 0; i < nomeGiocatore[1].length()-1; i++) {
            deb += str(nomeGiocatore[1].charAt(i));
          }
          nomeGiocatore[1] = deb;
        }
        fill(255);
      }
    } else fill(255);
    text(Key, x, y, si);
  }
}*/