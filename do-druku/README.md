# do-druku — v0.6 (po przeglądzie gauntlet, przed drukiem)

Sześć części + 14 × M2,5×12 (2 zawiasy + 4 pokrywka daszka + 4 + 4 pokrywki podów) + kupon do doboru tolerancji śrub.

**Poprawka zawiasu (2026-09-16, przed pierwszym drukiem):** ramię zausznika ma teraz 5 mm wysokości aż do 12 mm od osi (wcześniej rozszerzało się do 14 mm zaraz za dyskiem i blokowało obrót), szczelina między kostkami 7 mm zamiast 6. Widok `part="fold"` w SCAD pokazuje złożone zauszniki.
Folder jest kopią `cad/stl/`, źródłem jest `cad/glass.scad`. Co się zmieniło i dlaczego: `GAUNTLET-REPORT.md`.

| Plik | Szt. | Orientacja na stole | Podpory |
|---|---|---|---|
| `front.stl` | 1 | **DO GÓRY NOGAMI**: górne krawędzie daszka i podów na stole (otwarte komory w dół) | brak w komorach; tree pod noskówkami i pod belką między podami |
| `lid_hood.stl`, `lid_r.stl`, `lid_l.stl` | 1+1+1 | płasko | brak |
| `temple_r.stl`, `temple_l.stl` | 1+1 | na boku, występ głośnika do góry | brim, bez podpór |
| `screw-coupon.stl` | 1 | płasko | brak |

PLA, 0,2 mm, 3 ścianki, 20 %. Skala 1:1 (PD = 62 roboczo). Front 200 × 68 × 42 mm.

## Co jest inaczej niż w v0.3/v0.4

- Daszek nad prawym okiem jest wyższy (34 mm) i **otwarty od góry**: tam siedzi OLED (na szynach, przesuwny 6 mm = ostrość), jedno lusterko 30×30 (między żebrami pod 45°) i soczewka (w kieszeni w podłodze, nad szybką). Szybka 25×25 wchodzi od dołu w skośną szczelinę w podłodze daszka.
- Pody otwarte od góry, pokrywki na 4 śrubki. Prawy: wzmacniacz na żebrach + przycisk w pokrywce. Lewy: bateria przy ściance + XIAO za przednią ścianką (okno kamery), USB-C przez pokrywkę.
- Zawias: śruba z góry, 4 mm gwintu w dolnej kostce, łeb wystaje 2,5 mm. Zauszniki rozchylone na zewnątrz.
- Tył płaski, rowek na kable 5×5 na tylnej ścianie belki.

## Kupon śrub (`screw-coupon.stl`, 5 min druku)

Dwa rzędy po 6 otworów, średnice rosną od lewej do prawej, liczba kropek nad otworem = pozycja (1..6).
- **Blok z rowkiem, otwory ślepe 8 mm (TAP)**: 2,1 / 2,2 / 2,3 / 2,4 / 2,5 / 2,6 mm. Wkręć M2,5×12 w każdy. Szukamy **największego otworu, w którym śruba jeszcze trzyma mocno** (nie kręci się w kółko). Model używa 2,4 (4 kropki).
- **Płytka cienka, otwory na wylot (CLR)**: 2,6 / 2,7 / 2,8 / 2,9 / 3,0 / 3,1 mm. Szukamy **najmniejszego otworu, przez który śruba przechodzi i kręci się luźno**. Model używa 2,9 (4 kropki).
Zgłoś dwie liczby kropek; wpisuję je jako `S_TAP` i `S_CLR` i eksportuję ponownie.

## Przymiarka (bez elektroniki)

Drukuj front + zauszniki (pokrywki opcjonalnie). Sprawdź: mostek nie dotyka nosa (VD 21), noskówki leżą płasko na bokach nosa, zauszniki nie uciskają przed uszami, daszek nie zasłania więcej niż górny skrawek widzenia prawego oka, szczelina szybki ≥ 2 cm od rzęs. Zgłoś liczby, wszystko jest parametrem.

## Do potwierdzenia po dostawie części

- Pozycja obiektywu kamery i USB-C na realnym XIAO (okno i wycięcie w pokrywce lewego poda).
- Offset aktywnego pola OLED względem środka płytki (`OLED_OFF`).
- Grubość szybki i lusterka (szczeliny liczone na 1,1 i 1,6 mm).
