/*import android.os.Bundle;
import android.view.Gravity;
import android.view.Window;
import android.widget.RelativeLayout;
import com.google.ads.*;

@Override
public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  Window window = getWindow();
  RelativeLayout adsLayout = new RelativeLayout(this);
  RelativeLayout.LayoutParams lp2 = new RelativeLayout.LayoutParams(
    RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.FILL_PARENT);
  // Per vedere il banner in basso allo sketch ,altrimenti TOP per vederlo in alto
  adsLayout.setGravity(Gravity.BOTTOM);
  AdView  adView = new AdView(this, AdSize.BANNER, "ca-app-pub-8490206152530240~4819092010");  // add your app-id
  adsLayout.addView(adView);
  AdRequest newAdReq = new AdRequest();
  adView.loadAd(newAdReq);
  window.addContentView(adsLayout, lp2);
}

@Override
 public void onPause() {
 super.onPause();
 }
 @Override
 public void onStop() {
 super.onStop();
 }
 @Override
 public void onDestroy() {
 super.onDestroy();
 }
 @Override
 public void onResume() {
 super.onResume();
 }
 */