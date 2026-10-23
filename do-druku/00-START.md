# G.L.A.S.S. v0.9: co drukować i w jakiej kolejności

**v0.9 (2026-10-23):** boxy z elektroniką przeniesione z przodu na boki, za zawiasy. Każdy box (22 × 86 × 34 mm) trzyma się na 3 magnesach Ø6×2 i 2 kołkach na szynie wyrastającej z rogu płyty; szyna jest też blokadą zausznika, a zausznik składa się pod boxem. Front to sama płyta plus **ramię HUD** (nowa część `arm.stl`) przykręcane 2 × M2,5×12 do przodu płyty: trzyma soczewkę i szybkę przed prawym okiem. OLED stoi w przedniej części prawego boxu i świeci przez okienko do środka na soczewkę, bez lusterka (obraz lustrzany poziomo, firmware odwraca jednym rejestrem SSD1306). Lewy box: XIAO z przodu (kamera przez przednią ściankę, USB-C przez pokrywkę), bateria za nim, wzmacniacz na dnie. Pokrywki na 4 magnesach. Magnesy na całość: 2 × 3 (szyny) + 2 × 3 (boxy) + 2 × 4 (słupki) + 2 × 4 (pokrywki) = **28 szt.** Śruby: 2 (zawiasy) + 2 (ramię) = **4 × M2,5×12**.

```
do-druku/
├── 00-START.md
├── 01-testy/        kupon śrub i test zawiasu (tylko gdy coś nie pasuje)
├── 02-plyta/        plate.stl + arm.stl          ← ETAP 1 (z zausznikami)
├── 03-zauszniki/    temple-r.stl, temple-l.stl   ← ETAP 1
├── 04-boxy/         box-r.stl, box-l.stl         ← ETAP 2
└── 05-pokrywki/     lid-r.stl, lid-l.stl         ← ETAP 2
```

Wszystkie STL są **już obrócone do druku**. Nie używaj auto-orient. Podpory wyłączone dla wszystkiego.

## ETAP 1: płyta, ramię, zauszniki (ok. 3,5 h)

| Plik | Orientacja (już ustawiona) | Ustawienia | Czas |
|---|---|---|---|
| `02-plyta/plate.stl` | przednią ścianą na stole, noskówki, zawiasy i szyny do góry | 0.20 Standard lub Strength, bez podpór | ok. 2 h 15 min |
| `02-plyta/arm.stl` | tylną ścianą na stole, pierścień soczewki i głowica szybki do góry | to samo | ok. 25 min |
| `03-zauszniki/temple-r.stl`, `temple-l.stl` | płasko na zewnętrznym boku, brim | to samo | po ok. 25 min |

Montaż: zauszniki w szczeliny zawiasów (lewy zawias jest 12 mm wyżej, to celowe), 2 × M2,5×12 od góry. Ramię HUD: dwa otwory z przodu płyty nad prawym okiem, 2 × M2,5×12 od przodu, łby chowają się w ramieniu. Soczewkę wsuwasz w pierścień od strony zewnętrznej (od boxu) i przyklejasz 3 kroplami na obwodzie; szybkę wsuwasz od dołu w skośną szczelinę w głowicy ramienia i przyklejasz górną krawędź.

**Magnesy w szynach:** 3 gniazda na zewnętrznej ścianie każdej szyny. Wklej wszystkie 6 tym samym biegunem na zewnątrz. Magnesy do boxów wkładaj przyciągając do szyny, wtedy biegun ustawi się sam.

**Sprawdź na głowie i napisz:** czy front leży na noskówkach i nie zjeżdża, czy haki łapią za uszy, czy zauszniki trzymają przy głowie, czy ramię HUD nie dotyka rzęs (szybka jest 44 mm przed okiem), czy przez szybkę widać normalnie.

## ETAP 2: boxy i pokrywki (po przymiarce)

| Plik | Orientacja | Ustawienia | Czas |
|---|---|---|---|
| `04-boxy/box-r.stl`, `box-l.stl` | otwarte od góry, dnem na stole, kołki i magnesy w stronę płyty | bez podpór | po ok. 1 h |
| `05-pokrywki/lid-r.stl`, `lid-l.stl` | zewnętrzną stroną na stole | | po ok. 20 min |

Box nasuwasz na szynę od zewnątrz: kołki w otwory, magnesy łapią. Zdejmujesz, odciągając w bok. Prawy box ma okienko w wewnętrznej ściance (na wysokości soczewki) i klatkę przycisku w pokrywce; lewy ma okno kamery z przodu i wycięcie USB-C w pokrywce. Kable z lewego boxu do prawego: otwór w wewnętrznej ściance lewego boxu → rowek z tyłu lewego rogu → rowek z tyłu belki → przelot przez płytę przy prawym rogu → rowek z przodu prawego rogu (pod ramieniem HUD) → otwór w prawym boxie.

## Do potwierdzenia po dostawie części

- Pozycja kamery i USB-C na realnym XIAO (okno Ø7 w przedniej ściance lewego boxu, wycięcie w pokrywce).
- Wymiary baterii (w modelu 40 × 20 × 8 mm, leży za XIAO).
- Pozycja OLED-a w prawym boxie (`OLED_X`, przesuw ±3 mm na szynach = ostrość).

## Jak to powstaje

`cad/glass.scad` jest źródłem prawdy. `cad/export-all.sh` eksportuje części w orientacji do druku do `cad/stl/`, `python3 tools/pack-print.py` układa je w `do-druku/`, `cad/export-asm.sh` eksportuje zestaw w orientacji złożonej do renderów i filmu (`film/film_build.py`).
