# AISSIST Layout Presets

Das Layout-System des Renderers ist **parametrisch über benannte Presets**, nicht
über freie Parameter. Jedes Preset ist ein bewusst gebauter, benannter Renderer-Zweig.
Damit bleibt das Layout-System explizit, reviewbar und für Agents wählbar — ohne
freies CSS.

`specVersion: 1` · Stand: Renderer MVP (Phase 1)

---

## Grundprinzip

Eine Feature-Spec beschreibt **was** auf einem Screen liegt, nicht **wie** der Rahmen
aussieht. Der Rahmen (Sidebar, Spalten, Vollfläche) wird über ein einziges Feld
gesteuert:

```yaml
screens:
  - id: mein-screen
    title: Titel
    layout:
      preset: default      # default · editor · fullscreen · split
    components:
      - ...
```

Fehlt `preset`, greift Rückwärtskompatibilität: alte `sidebar:` / `settingsColumn:`-Flags
werden weiterhin interpretiert und auf ein Preset abgebildet.

---

## Die vier Presets

| Preset | Sidebar | Settings-Spalte | Struktur | Use Case |
| --- | --- | --- | --- | --- |
| `default` | ✅ | — | Sidebar + Content-Pane | Chat, Galerien, Listen |
| `editor` | ✅ | ✅ (330px links) | Sidebar + Settings-Spalte + Content | Bildgenerierung, Konfiguration mit Live-Vorschau |
| `fullscreen` | — | — | Kein Frame, volle Fläche | Formulare, fokussierte Eingabe (Agent erstellen) |
| `split` | — | — | Zwei gleichwertige Hälften | Versionsvergleich, A/B-Bewertung |

### `default`

Die Standard-Shell. Linke Sidebar mit Erstellen-Button, Suche und Screen-Navigation;
rechts die abgerundete Content-Pane. Erkennt automatisch Chat-Layout (wenn eine
`input`-Komponente mit `variant: prompt` vorhanden ist) vs. Standard-Scroll-Layout.

```yaml
layout:
  preset: default
```

### `editor`

Wie `default`, zusätzlich eine 330px breite Settings-Spalte links der Content-Pane.
Komponenten landen über `slot: settings` in dieser Spalte.

```yaml
layout:
  preset: editor
components:
  - type: input
    variant: select
    label: Modellauswahl
    slot: settings          # → linke Settings-Spalte
  - type: input
    variant: prompt         # → Content-Bereich
    action: send
```

### `fullscreen`

Kein Sidebar, kein Frame — die Content-Pane nimmt die volle Breite ein (eckig statt
abgerundet). Für fokussierte Formulare und Eingabemasken.

```yaml
layout:
  preset: fullscreen
```

### `split`

Zwei gleichwertige, gerahmte Hälften nebeneinander. Komponenten werden über
`slot: left` und `slot: right` zugewiesen. Auf schmalen Viewports (< 900px) stapeln
sich die Hälften.

```yaml
layout:
  preset: split
components:
  - type: card
    slot: left
    label: Variante A
  - type: card
    slot: right
    label: Variante B
```

---

## Slot-Referenz

| Slot | Wirksam in Preset | Wirkung |
| --- | --- | --- |
| _(kein Slot)_ | alle | Content-Bereich (Hauptfläche) |
| `settings` | `editor` | Linke 330px-Settings-Spalte |
| `left` | `split` | Linke Hälfte |
| `right` | `split` | Rechte Hälfte |

Slots, die im aktiven Preset keine Bedeutung haben, werden ignoriert (die Komponente
landet im Content-Bereich bzw. wird nicht angezeigt, je nach Preset).

---

## Fehlerverhalten

Ein **unbekanntes Preset** wird nicht still interpretiert. Der Renderer zeigt eine
Warnung und fällt auf `default` zurück:

> ⚠️ Unbekanntes Layout-Preset „xyz" — Fallback auf **default**.
> Erlaubt: default · editor · fullscreen · split.

Das entspricht der Governance-Logik: Layout-Erweiterungen sind ein bewusster Schritt,
keine implizite Folge einer frei interpretierten YAML-Property.

---

## Governance: neue Layouts

Analog zur Komponenten-Eskalationsleiter (siehe `DESIGN-SYSTEM.md`, Abschnitt 4):

1. **Komposition** — Deckt ein bestehendes Preset den Use Case ab, ggf. mit Slots?
2. **Layout-Proposal** — Erst wenn kein Preset passt, wird ein neues Preset
   vorgeschlagen. Mit Begründung und bewusst gebautem Renderer-Zweig.

**Grenze des Systems:** Presets decken Editorial- und Form-getriebene Workflows ab.
Use Cases mit echter zweidimensionaler freier Komposition (Canvas, Drag-and-Drop-Board,
visueller Workflow-Editor) sind **kein** Preset-Fall — sie werden besser als nativer
Vue-Prototyp gebaut. Für AISSIST ist das ein Randfall, kein Regelfall.

---

## Erweiterbarkeit (Phase 4)

Das Preset-Feld ist so geschnitten, dass spätere Presets ohne Schema-Bruch andocken.
Ein neues Preset bedeutet: ein Eintrag in der Preset-Tabelle des Renderers plus ein
Render-Zweig — bestehende Specs bleiben unberührt.
