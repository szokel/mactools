# mactools

Kisméretű, átlátható macOS-parancssori segédeszközök gyűjteménye.

Az első eszköz a `mi-ez-a-hatterkep`, amely az Apple Aerial háttérképek közül azonosítja az éppen aktívat akkor is, ha a macOS egy teljes kategóriát—például a 79 elemes Landscape készletet—váltogatja.

## Használat

```sh
mi-ez-a-hatterkep
```

Példa:

```text
Aktuális háttérkép: The Ganges
```

További módok:

```sh
# Natív macOS-párbeszédablak
mi-ez-a-hatterkep --dialog

# Név, Apple asset ID, shot ID és videófájl
mi-ez-a-hatterkep --details

# Géppel feldolgozható JSON
mi-ez-a-hatterkep --json
```

## Telepítés

```sh
git clone https://github.com/szokel/mactools.git
cd mactools
./install.sh
```

Apple siliconos gépen a telepítő alapértelmezetten az `/opt/homebrew/bin` mappát használja. Egyedi célmappa is megadható:

```sh
PREFIX="$HOME/.local" ./install.sh
```

## Hogyan működik?

A Shuffle Landscape beállítás állapotfájlja csak a Landscape kategória azonosítóját tartalmazza; az éppen kiválasztott képét nem. A futó macOS Wallpaper folyamat azonban nyitva tartja az aktív Aerial videófájlt.

A parancs működése:

1. Az `lsof` segítségével lekéri a Wallpaper folyamat nyitott fájljait.
2. Kiválasztja az Aerial videómappából megnyitott `.mov` fájlt.
3. A fájlnévből kinyeri az Apple asset UUID-t, például `B6461ECC-44F5-4BC9-877F-484A605D0D10`.
4. Beolvassa az Apple helyi `entries.json` katalógusát.
5. Az UUID alapján megkeresi a megfelelő rekordot, majd kiírja annak `accessibilityLabel` mezőjét—például `The Ganges`.

A művelet teljesen helyben és csak olvasási módban történik. Nem módosítja a háttérképet, és nem küld hálózati kérést.

## Shortcut készítése

A Parancsok alkalmazásban hozz létre új parancsot, adj hozzá egy **Run Shell Script / Shell-szkript futtatása** műveletet, majd add meg ezt:

```sh
/opt/homebrew/bin/mi-ez-a-hatterkep --dialog
```

Ezután a Shortcut kitehető a menüsávba vagy billentyűkombinációhoz rendelhető.

## Korlátok

- Az Apple saját Aerial háttérképeit azonosítja.
- A jelenlegi megoldás az Apple nem dokumentált belső fájlútvonalait használja; ezek egy későbbi macOS-verzióban megváltozhatnak.
- Ha a Wallpaper folyamat éppen nem tart nyitva Aerial videót, jelenítsd meg az Asztalt vagy a Lock Screent, majd futtasd újra.
- A feldolgozáshoz a macOS `lsof` eszköze és a gépen elérhető `/usr/bin/python3` szükséges.

## Fejlesztés és tesztelés

```sh
zsh -n bin/mi-ez-a-hatterkep
./tests/test_wallpaper_info.zsh
```

## Licenc

MIT
