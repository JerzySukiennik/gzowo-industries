# G.L.A.S.S. v0.6: co drukować i w jakiej kolejności

v0.6 to najnowsza wersja i **nigdy jeszcze nie była drukowana**. V0.5 nie mieściła śrub i nie dało się jej nosić, więc zanim wydrukujemy cały front (prawie 7 godzin), sprawdzamy trzy rzeczy na małych wydrukach: średnicę otworów na M2,5×12, pracę zawiasu i dopiero potem dopasowanie do głowy.

Wszystkie pliki STL są **już obrócone do druku** (front do góry nogami, pokrywki łbem do stołu, zauszniki na boku). Nie używaj auto-orient ani ręcznego obracania.

```
do-druku/
├── 00-START.md            ← ten plik
├── 01-testy/              ← ETAP 1 (2 h 10 min)
│   ├── test-plate.stl     ← kupon śrub + próbka zawiasu, jedna płytka
│   └── osobno/            ← te same trzy części osobno (samo kupon: około 15 min)
├── 02-przymiarka/         ← ETAP 2 (front + 2 zauszniki, bez elektroniki)
├── 03-pokrywki/           ← ETAP 3 (dopiero po przymiarce)
└── podglad/               ← zdjęcia modeli
```

## Przed pierwszym wydrukiem (5 minut)

- **M2,5×12 DIN 912**: potrzeba 14 na całość, na testy 3 do 4 sztuk. Klucz imbusowy 2 mm.
- **Zmierz PD** (odległość źrenic): stań przed lustrem, przyłóż linijkę poziomo do nosa tuż pod oczami, patrz prosto w lustro i odczytaj odległość od środka jednej źrenicy do środka drugiej. W modelu jest na sztywno **62 mm**, to tylko roboczy zgadnięty wynik. Jeśli wyjdzie inaczej, zmieniam jedną liczbę i eksportuję od nowa.
- Drukarka: X1C, dysza 0,4, PLA. Ta sama szpula na wszystkie testy i na finał (różne marki mają różny skurcz i luz).

## ETAP 1: test tolerancji (`01-testy/test-plate.stl`)

**Ustawienia (Bambu Studio):** 0.20mm Standard, 3 ścianki, wypełnienie 20 %, brim auto, **bez podpór**. Czas około 2 h 10 min, około 18 g PLA.

Na płytce leżą trzy rzeczy:

1. **Kupon śrub (długi blok z dwoma rzędami otworów).** Liczba kropek nad otworem = jego numer od lewej (1 do 6).
   - *Blok z długim rowkiem, otwory ślepe* (`TAP`: 2,1 / 2,2 / 2,3 / 2,4 / 2,5 / 2,6 mm). Wkręć M2,5×12 w każdy. Szukamy **największego otworu, w którym śruba jeszcze trzyma mocno**. Model używa 2,4 (4 kropki).
   - *Cienka płytka, otwory na wylot* (`CLR`: 2,6 / 2,7 / 2,8 / 2,9 / 3,0 / 3,1 mm). Szukamy **najmniejszego otworu, przez który śruba przechodzi i kręci się luźno**. Model używa 2,9 (4 kropki).
2. **Próbka zawiasu, część ramy** (skrzynka z dwiema kostkami z tyłu). To prawdziwy zawias z frontu: górna i dolna kostka i szczelina 7 mm między nimi.
3. **Próbka zawiasu, część zausznika** (mały ząbek z otworem, stoi na krawędzi, tak jak będzie drukowany zausznik).

**Zawias, jak zmontować:** włóż ząbek zausznika w szczelinę między kostkami ramy, wkręć M2,5×12 od strony cienkiej (górnej) kostki, aż łeb dosiądzie. Sprawdź:

- czy zausznik obraca się swobodnie o 90 stopni, bez zgrzytu i bez ocierania o kostki,
- czy nie chybocze się bokiem więcej niż mniej więcej pół milimetra,
- czy śruba łapie w dolnej (grubszej) kostce i nie przelatuje ani nie kręci się w miejscu,
- czy szczelina 7 mm wydrukowała się czysto (brak zwisających nitek, które blokują ząbek),
- czy łeb śruby wystaje z góry (ma wystawać).

**Odeślij mi:** numer kropek TAP, numer kropek CLR i cztery odpowiedzi o zawiasie (tak, nie, ciasno, luźno). Wpisuję wartości jako `S_TAP` i `S_CLR`, eksportuję od nowa i dopiero wtedy ruszamy dalej.

## ETAP 2: przymiarka (`02-przymiarka/`)

Wydruk tylko do sprawdzenia kształtu na głowie: bez elektroniki, bez pokrywek, bez śrub poza zawiasami.

| Plik | Ustawienia | Czas | PLA |
|---|---|---|---|
| `front.stl` | 0.28mm Extra Draft, 2 ścianki, wypełnienie 5 %, **bez podpór** | około 6 h 45 min (na noc) | około 55 g |
| `temple_r.stl` | to samo | około 45 min | około 6 g |
| `temple_l.stl` | to samo | około 45 min | około 6 g |

Front to **największy wydruk projektu** (194 × 75 × 68 mm). Ma 60 cm³ objętości, prawie całą w ściankach, dlatego nawet wersja robocza trwa prawie 7 godzin. Z podporami byłoby 10 godzin, więc na przymiarkę ich nie dajemy (możliwe lekkie zwisy noskówek i górnych łuków obręczy, to nie szkodzi).

**Co sprawdzić na głowie** (zmierz i zgłoś liczby, wszystko jest parametrem): mostek nie dotyka nosa · noskówki leżą płasko na bokach nosa · zauszniki nie uciskają przed uszami i nie wchodzą w głowę · daszek nad prawym okiem nie zasłania więcej niż górny skrawek widzenia · odległość szybki od rzęs co najmniej 2 cm · front nie zsuwa się po nosie.

Uwaga: `temple_r` ma kieszeń na głośnik, która w tym modelu jest **zamknięta ze wszystkich stron** (siatka dziurek po stronie głowy, z tyłu lity materiał), więc głośnika nie da się włożyć. Do przymiarki to bez znaczenia, ale **przed finałem poprawiam** kieszeń na otwartą.

## ETAP 3: finał (dopiero po przymiarce)

1. `03-pokrywki/`: `lid_hood.stl` (25 min), `lid_l.stl` (25 min), `lid_r.stl` (20 min). 0.20mm Standard, 3 ścianki. Są liczone na otwory z Etapu 1, po zmianie `S_CLR` eksportuję je od nowa, więc **nie drukuj ich przed wynikami testu**.
2. Finałowy front i zauszniki z poprawkami z przymiarki: 0.20mm Standard, 3 ścianki, 20 %, około 8 h. Podpory tylko, jeśli podgląd w slicerze ich wymaga.
3. Na końcu sprawdzenie z elektroniką po dostawie części (pozycje OLED, XIAO, szybka).

## Jak to powstaje (dla porządku)

`cad/glass.scad` jest źródłem prawdy. `cad/export-all.sh` eksportuje części do `cad/stl/`, a `python3 tools/pack-print.py` obraca je do druku i układa w `do-druku/`. Czasy i ilości filamentu liczone w Bambu Studio (profil X1C 256 × 256, Generic PLA).
