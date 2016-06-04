import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RelativeLayout;
import com.google.ads.*;
@Override
  public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
}

@Override
  public void onPause() {
  super.onPause();
  aptheme.pause();
}
@Override
  public void onStop() {
  super.onStop();
  aptheme.pause();
}
@Override
  public void onDestroy() {
  super.onDestroy();
  distruggi(aptheme);
  distruggi(aplose);
  distruggi(apwin);
  distruggi(apswipe);
  distruggi(aptic);
}
@Override
  public void onResume() {
  super.onResume();
  if (musica&& endsetup)parti(aptheme);
}
@Override
  public void onUserInteraction() {
  super.onUserInteraction();
  //if (inputMethodManager != null) {
  //inputMethodManager.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
  //}
}

public void distruggi(APMediaPlayer a) {
  if (a!=null) a.release();
}

public void parti(APMediaPlayer a) {
  if (a!=null) a.start();
}

public void stoppa(APMediaPlayer a) {
  if (a!= null) {
    a.seekTo(0);
    a.pause();
  }
}

public APMediaPlayer crea(String b) {
  APMediaPlayer a;
  a = new APMediaPlayer(this);
  a.setMediaFile(b);
  a.setVolume(1.0, 1.0);
  a.setLooping(false);
  return a;
}