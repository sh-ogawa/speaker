package ooga.sh4.jp.speaker;

import android.media.MediaPlayer;
import android.util.Log;

import java.io.IOException;

class Speaker implements MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener, MediaPlayer.OnErrorListener {

    private static MediaPlayer player = new MediaPlayer();

    void play(String resourceUri) throws IOException {
        player.setOnPreparedListener(this);
        player.setOnCompletionListener(this);
        player.setOnErrorListener(this);
        player.setDataSource(resourceUri);

        player.prepare();
        Log.i("ooga04_speaker", "media player started play.");
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        Log.i("ooga04_speaker", "handle complete.");
        mp.release();
    }

    @Override
    public void onPrepared(MediaPlayer mp) {
        Log.i("ooga04_speaker", "handle prepared.");
        mp.start();

    }

    @Override
    public boolean onError(MediaPlayer mp, int what, int extra) {
        mp.release();
        return false;
    }
}
