# G.L.A.S.S. v0.7: co drukować i w jakiej kolejności

v0.7 to przebudowa po pierwszym pełnym wydruku v0.6 (2026-10-12): v0.6 zsuwała się po nosie, przechylała do przodu, zauszniki nie dotykały głowy i były za krótkie, obręcze ściskały nos, a pody wyglądały jak przyklejone klocki. Zawias, otwory i tolerancje śrub z v0.6 zostały (były przetestowane).

**Co się zmieniło**

- Zero podów. Dwie identyczne „brwi" 60 × 36 × 36 mm siedzą na przodzie płyty nad oczami. Prawa = optyka (OLED, lusterko, soczewka, szybka pod spodem). Lewa = elektronika (XIAO z kamerą patrzącą do przodu, bateria, wzmacniacz). Przycisk w prawej pokrywce, USB-C przez zewnętrzną ściankę lewej brwi.
- Zawiasy na rogach płyty, 144 mm od siebie (było 162), zauszniki rozchylone tylko 7°, 17 mm dłuższe i schodzące do góry ucha. Każdy zawias ma płetwę, o którą zausznik opiera się w pozycji otwartej (nie wychyla się na zewnątrz).
- Mostek typu „keyhole": wewnętrzne krawędzie obręczy odsuwają się od nosa w dół (wg skanu), a front opiera się na noskówkach 3,5 mm za płytą, na bokach nosa.
- Front podzielony na części: po poprawce nosa drukujesz tylko płytę (ok. 2 h), nie całość.
- Rowek na kable ma przeloty: lewa brew → płyta → rowek za mostkiem → prawa brew, i prawa brew → rowek → zawias → prawy zausznik (głośnik, 2 żyły, krótka pętla po wewnętrznej stronie zawiasu).

Wszystkie STL są **już obrócone do druku**. Nie używaj auto-orient.

```
do-druku/
├── 00-START.md
├── 01-testy/        test-plate.stl (kupon śrub + zawias v0.7 na jednej płytce) i te same części osobno
├── 02-plyta/        plate.stl        ← ETAP 1: przymiarka nosa i zawiasów
├── 03-zauszniki/    temple-r.stl, temple-l.stl   ← ETAP 1
├── 04-brwi/         brow-r.stl, brow-l.stl       ← ETAP 2
└── 05-pokrywki/     lid-r.stl, lid-l.stl         ← ETAP 2
```

## ETAP 1: płyta + zauszniki (przymiarka na głowie, ok. 3,5 h)

| Plik | Orientacja (już ustawiona) | Ustawienia | Czas |
|---|---|---|---|
| `02-plyta/plate.stl` | leży na przedniej ścianie, noskówki i zawiasy do góry | 0.20 mm Standard, 3 ścianki, 20 %, **bez podpór** | ok. 2 h |
| `03-zauszniki/temple-r.stl` | na zewnętrznym boku, kieszeń głośnika do góry | to samo, brim | ok. 45 min |
| `03-zauszniki/temple-l.stl` | to samo | to samo, brim | ok. 45 min |

Zauszniki wkładasz w szczelinę między kostkami na rogach płyty i skręcasz 2 × M2,5×12 od góry (jak w teście zawiasu). Płetwa obok zawiasu ma blokować otwieranie poza pozycję prostą.

**Sprawdź na głowie i napisz:**
1. Czy front opiera się na noskówkach (po bokach nosa), a nie krawędziami obręczy. Gdzie uciska, jeśli uciska.
2. Czy zagięcie zausznika ląduje na górze ucha, czy przed nim, czy za nim (ile mm).
3. Czy zauszniki dotykają głowy nad uszami i trzymają, czy wiszą luźno.
4. Czy okulary siedzą poziomo i nie zjeżdżają po nosie.
5. Czy zausznik opiera się o płetwę i nie wychyla na zewnątrz; czy składa się do środka.

Każda z tych rzeczy to jeden parametr w `cad/glass.scad` (`PAD_X`, `PAD_Z`, `TEMPLE_L`, `TEMPLE_SPLAY`, `EAR_Z`, `VD`). Po poprawce drukujesz tylko płytę albo tylko zauszniki.

## ETAP 2: brwi + pokrywki (dopiero gdy płyta pasuje)

| Plik | Orientacja | Ustawienia | Czas |
|---|---|---|---|
| `04-brwi/brow-r.stl`, `brow-l.stl` | otwarte od góry, dnem na stole | 0.20 mm Standard, 3 ścianki, 20 %, bez podpór | ok. 1 h 15 min każda |
| `05-pokrywki/lid-r.stl`, `lid-l.stl` | zewnętrzną stroną na stole, klatka przycisku do góry | 0.20 mm Standard, 3 ścianki | ok. 20 min każda |

Brwi przykręcasz do płyty **od tyłu** (łby śrub chowają się w belce nad mostkiem): 2 × M2,5×12 na brew. Pokrywki: 4 × M2,5×12 na brew, wchodzą równo z górną krawędzią. Razem na całość: 2 (zawiasy) + 4 (brwi) + 8 (pokrywki) = **14 × M2,5×12**.

## Do potwierdzenia po dostawie części

- Pozycja obiektywu kamery i USB-C na realnym XIAO (okno Ø7 w przedniej ściance i wycięcie w zewnętrznej ściance lewej brwi).
- Wymiary baterii (w modelu 40 × 20 × 8 mm, stoi na półce przy tylnej ścianie lewej brwi).
- Offset aktywnego pola OLED (`OLED_X`, zakres przesuwu 60..66 = ostrość 14..31 cm).

## Jak to powstaje

`cad/glass.scad` jest źródłem prawdy. `cad/export-all.sh` eksportuje części w orientacji do druku do `cad/stl/`, a `python3 tools/pack-print.py` układa je w `do-druku/`. Widoki kontrolne w SCAD: `part="fit"` (elektronika i optyka w brwiach), `part="fold"` (złożone zauszniki), `part="assembly"` (ze skanem głowy).
