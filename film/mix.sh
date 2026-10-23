#!/bin/bash
# Assemble the film: frames -> video, song + narration -> audio, mux. Usage: film/mix.sh h|v
set -e
cd "$(dirname "$0")"
M="${1:-h}"
FPS=24
# narration placement (seconds)
ffmpeg -y -v error \
  -framerate $FPS -i "frames_$M/f%04d.png" \
  -i song.mp3 \
  -i tts/line01.wav -i tts/line02.wav -i tts/line03.wav -i tts/line04.wav -i tts/line05.wav -i tts/line06a.wav -i tts/line06b.wav \
  -filter_complex "
    [1:a]atrim=0:60,afade=t=in:st=0:d=1.5,afade=t=out:st=57:d=3,volume=0.55[music];
    [2:a]adelay=7000|7000,volume=1.6[n1];
    [3:a]adelay=15000|15000,volume=1.6[n2];
    [4:a]adelay=23500|23500,volume=1.6[n3];
    [5:a]adelay=32000|32000,volume=1.6[n4];
    [6:a]adelay=40500|40500,volume=1.6[n5];
    [7:a]adelay=50000|50000,volume=1.6[n6];
    [8:a]adelay=55000|55000,volume=1.6[n7];
    [music][n1][n2][n3][n4][n5][n6][n7]amix=inputs=8:duration=first:normalize=0,alimiter=limit=0.95[a]
  " \
  -map 0:v -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -r $FPS -t 60 -c:a aac -b:a 192k -movflags +faststart \
  "glass-unveiling-$( [ "$M" = v ] && echo 9x16 || echo 16x9 ).mp4"
ls -la glass-unveiling-*.mp4
