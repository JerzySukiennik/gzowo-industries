# G.L.A.S.S. v0.8: co drukować i w jakiej kolejności

**v0.8 (2026-10-14, po wydruku v0.7):** brwi i pokrywki na **magnesach Ø6×2** zamiast śrub (3 magnesy + 2 kołki na brew, 4 magnesy na pokrywkę), śruby zostają tylko w zawiasach. Zauszniki smukłe (6×9 → 4×6 mm) z hakiem za ucho i płaskim medalionem głośnika, drukowane płasko na zewnętrznym boku bez podpór. Lewy zawias 8 mm wyżej, żeby zauszniki składały się jeden nad drugim. Noskówki pochylone pod nos (30°), większe. Słupki pokrywek od podłogi do góry. Zestaw magnesów na całość: 2 × 3 (płyta) + 2 × 3 (brwi) + 2 × 4 (słupki) + 2 × 4 (pokrywki) = **28 szt.**

v0.7 było przebudową po pierwszym pełnym wydruku v0.6 (2026-10-12): v0.6 zsuwała się po nosie, przechylała do przodu, zauszniki nie dotykały głowy i były za krótkie, obręcze ściskały nos, a pody wyglądały jak przyklejone klocki. Zawias, otwory i tolerancje śrub z v0.6 zostały (były przetestowane).

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
| `03-zauszniki/temple-r.stl` | płasko na zewnętrznym boku, kieszeń głośnika do góry | to samo, brim, **bez podpór** | ok. 30 min |
| `03-zauszniki/temple-l.stl` | płasko na zewnętrznym boku | to samo, brim, **bez podpór** | ok. 25 min |

Zauszniki wkładasz w szczelinę między kostkami na rogach płyty i skręcasz 2 × M2,5×12 od góry (jak w teście zawiasu). Płetwa obok zawiasu blokuje otwieranie poza pozycję prostą. Lewy zawias jest celowo 8 mm wyżej niż prawy: przy składaniu najpierw prawy zausznik, potem lewy nad nim.

**Magnesy w płycie:** 3 gniazda Ø6,4 na przedniej ścianie belki po każdej stronie. Wklej magnesy (kropla CA) tak, żeby **wszystkie sześć miały ten sam biegun na zewnątrz**. Potem magnesy w brwiach wkładaj przyciągając je do płyty, wtedy biegunowość sama się ustawi, i dopiero wklej.

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
| `05-pokrywki/lid-r.stl`, `lid-l.stl` | zewnętrzną stroną na stole, kieszenie magnesów i klatka przycisku do góry | 0.20 mm Standard, 3 ścianki | ok. 20 min każda |

Brwi trzymają się płyty na 3 magnesach i 2 kołkach ustalających (kołki na tylnej ścianie brwi wchodzą w otwory w płycie nad magnesami). Brew zdejmujesz, ciągnąc do przodu. Pokrywki trzymają się na 4 magnesach w narożnych słupkach, wchodzą równo z górną krawędzią; magnesy w pokrywce wklej od spodu (kieszenie są od strony wewnętrznej, od góry zostaje 0,7 mm skóry). Śruby na całość: tylko **2 × M2,5×12** w zawiasach. Prawa brew: okrągła kieszeń na soczewkę w podłodze, skośna szczelina pod spodem, przycisk w pokrywce. Lewa: okno kamery z przodu, wycięcie USB-C na zewnętrznym końcu.

## Do potwierdzenia po dostawie części

- Pozycja obiektywu kamery i USB-C na realnym XIAO (okno Ø7 w przedniej ściance i wycięcie w zewnętrznej ściance lewej brwi).
- Wymiary baterii (w modelu 40 × 20 × 8 mm, stoi na półce przy tylnej ścianie lewej brwi).
- Offset aktywnego pola OLED (`OLED_X`, zakres przesuwu 60..66 = ostrość 14..31 cm).

## Jak to powstaje

`cad/glass.scad` jest źródłem prawdy. `cad/export-all.sh` eksportuje części w orientacji do druku do `cad/stl/`, a `python3 tools/pack-print.py` układa je w `do-druku/`. Widoki kontrolne w SCAD: `part="fit"` (elektronika i optyka w brwiach), `part="fold"` (złożone zauszniki), `part="assembly"` (ze skanem głowy).
