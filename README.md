# AISSIST Prototype Renderer

Ein browserbasiertes Tool, das **YAML Feature-Specs** in klickbare AISSIST-Prototypen
verwandelt — ohne Build-Schritt, ohne Installation, ohne Server.

Gedacht für Product Owner, Designer und alle, die schnell ein Feature greifbar
machen wollen, bevor es in die Entwicklung geht.

---

## Inhalt dieses Repos

```
html_renderer/
├── aissist-prototype-renderer.html   # Der Renderer — diese Datei ist alles
├── DESIGN-SYSTEM.md                  # Designsystem: Tokens, Komponenten, Governance
└── LAYOUT-PRESETS.md                 # Layout-Presets: default, editor, fullscreen, split
```

---

## Schnellstart — 2 Minuten bis zum ersten Prototyp

**1. Renderer öffnen**

`aissist-prototype-renderer.html` herunterladen und per Doppelklick im Browser öffnen.
Kein Server nötig. Der Renderer läuft direkt als `file://`-URL.

**2. YAML schreiben oder generieren**

Im linken Panel siehst du eine Demo-Spec mit allen 10 Komponenten. Ersetze sie durch
deine eigene Feature-Spec — oder lass dir eine von Claude generieren (siehe unten).

**3. Anwenden**

Klick auf **„Anwenden"** oder einfach 500 ms warten. Die Vorschau rechts aktualisiert
sich live. Navigation zwischen Screens funktioniert direkt im Prototyp.

---

## Mit Claude arbeiten — der AISSIST Prototyping Skill

Der einfachste Weg zum fertigen YAML ist der **AISSIST Prototyping Skill** für Claude.
Er kennt das Renderer-Schema, das Designsystem und den Fit-Check-Prozess — und liefert
direkt YAML, das du in den Renderer einfügen kannst.

### Skill installieren

1. `aissist-prototyping-skill.zip` aus dem [`aissist-skills`-Repo](https://github.com/Setter04/aissist-skills) herunterladen *(Link folgt)*
2. In Claude → Einstellungen → Skills → Skill installieren
3. Zip-Datei auswählen → fertig

### Skill benutzen

Einfach Claude beschreiben, was du bauen willst:

> „Bau mir einen Klickdummy für die Dokumenten-Upload-Maske. Nutzerin soll PDFs
> hochladen können und danach in einen Chat-Screen wechseln."

Claude führt automatisch einen **Komponenten-Fit-Check** durch, schreibt das YAML
und liefert die Deployment-Anweisung. Wenn ein UI-Element nicht mit den vorhandenen
10 Komponenten abbildbar ist, schlägt Claude eine Kompositionslösung vor — oder
einen Proposal für eine neue Variante.

---

## Das YAML-Schema

Jede Feature-Spec folgt diesem Aufbau:

```yaml
specVersion: 1

feature:
  id: mein-feature          # kebab-case, eindeutig
  name: "Mein Feature"
  goal: "Was die Nutzerin erreichen soll."

theme: aissist-dark         # fix

navigation:
  start: erster-screen      # ID des Start-Screens

screens:
  - id: erster-screen
    title: "Screen-Titel"
    layout:
      preset: default       # default | editor | fullscreen | split
    components:
      - type: button
        variant: primary
        label: Weiter
        action: navigate:zweiter-screen

  - id: zweiter-screen
    title: "Zweiter Screen"
    layout:
      preset: default
    components:
      - type: message
        variant: assistant
        props:
          content: Willkommen auf dem zweiten Screen.
```

Vollständiges Schema mit allen Props → **[DESIGN-SYSTEM.md](./DESIGN-SYSTEM.md)**

---

## Die 10 Kernkomponenten

| `type` | Varianten |
|---|---|
| `button` | `primary` · `outlined` · `icon` · `text` |
| `input` | `text` · `textarea` · `select` · `search` · `slider` · `switch` · `colorpicker` · `prompt` |
| `chip` | `active` · `neutral` · `removable` · `counter` |
| `card` | `default` · `create` · `compact` |
| `list` | – |
| `tabs` | `segmented` · `underline` |
| `panel` | `collapsible` · `accordion` · `overlay` |
| `upload` | – |
| `message` | `user` · `assistant` |
| `page` | – |

Komponenten sind **rekursiv verschachtelbar**: ein `panel` kann `chip`s, `input`s und
weitere `panel`s als `children` enthalten. Ausdrucksstärke entsteht über Komposition,
nicht über neue Komponenten.

Vollständige Variantenbeschreibungen und Vuetify-Mapping → **[DESIGN-SYSTEM.md](./DESIGN-SYSTEM.md)**

---

## Layout-Presets

Das Layout eines Screens wird über ein einziges Feld gesteuert:

| Preset | Beschreibung | Typischer Einsatz |
|---|---|---|
| `default` | Sidebar + Content-Pane | Chat, Galerien, Listen |
| `editor` | Sidebar + 330px Settings-Spalte links + Content | Konfiguration mit Live-Vorschau |
| `fullscreen` | Nur Content, kein Frame | Fokussierte Formulare, Onboarding |
| `split` | Zwei gleichwertige Hälften | Vergleich, A/B-Bewertung |

Komponenten landen per `slot` in der richtigen Zone:

```yaml
# editor: Settings-Spalte
- type: input
  slot: settings
  variant: select
  label: Modellauswahl

# split: linke und rechte Hälfte
- type: card
  slot: left
  label: Variante A
- type: card
  slot: right
  label: Variante B
```

Details und Governance → **[LAYOUT-PRESETS.md](./LAYOUT-PRESETS.md)**

---

## Neue Komponenten vorschlagen

Der Renderer kennt genau 10 Komponenten. Wenn ein UI-Element damit nicht abbildbar
ist, gibt es einen klaren Prozess:

1. **Komposition** — Lässt es sich aus vorhandenen Komponenten zusammensetzen?
   (meistens ja — kein Proposal nötig)
2. **Neue Variante** — Reicht eine zusätzliche Variante eines vorhandenen Typs?
   → Als `VARIANT-PROPOSAL`-Kommentar im YAML dokumentieren
3. **Neue Kernkomponente** — Erst wenn 1 und 2 scheitern.
   → Als `COMPONENT-PROPOSAL` in Markdown dokumentieren, in DESIGN-SYSTEM.md eintragen

Unbekannte `type`-Werte rendern als **rote Fallback-Box** — kein Crash, aber kein
echtes UI. So bleibt sichtbar, was noch fehlt.

Details zur Governance → **[DESIGN-SYSTEM.md §4](./DESIGN-SYSTEM.md)**

---

## Häufige Probleme

| Problem | Ursache | Fix |
|---|---|---|
| Nichts passiert nach Änderung | YAML-Parse-Fehler | Statuszeile lesen — meist Einrückung oder Tabs statt Spaces |
| Rote Box statt Komponente | `type`-Wert unbekannt | Typ aus der Tabelle oben nehmen, exakt so schreiben |
| Settings-Spalte leer | `slot: settings` ohne passendes Preset | `layout.preset: editor` setzen |
| `slot: left/right` wird ignoriert | Falsches Preset | `layout.preset: split` setzen |
| `navigate:` tut nichts | Screen-ID falsch | ID unter `screens[].id` prüfen, exakt matchen |
| Renderer lädt YAML per URL nicht | Kein HTTP-Server | `python3 -m http.server 8080` starten |

---

## Technischer Hintergrund

Der Renderer ist eine **vollständig self-contained HTML-Datei** — Vue 3, Vuetify 3,
js-yaml und MDI-Icons werden via CDN geladen. Es gibt keinen Build-Schritt, kein npm,
kein Bundler. Die Datei kann direkt geteilt werden.

Stack: Vue 3 · Vuetify 3.7 · js-yaml · MDI Icons 7.4

---

## Maintainer

AISSIST Product Team — Hubert Burda Media
