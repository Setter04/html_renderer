# AISSIST Design System

Extrahiert aus dem AISSIST-Prototyp und verbindlich für den Prototype Renderer.
Diese Datei ist die **Single Source of Truth** für visuelle Design-Entscheidungen.
Renderer und spätere echte Vue-Plattform referenzieren dieselben Tokens.

`specVersion: 1` · Stand: Renderer MVP (Phase 1)

---

## 1. Design Tokens

### Farben

| Token | Wert | Verwendung |
| --- | --- | --- |
| `accent` | `#edff01` | Zentrale Akzentfarbe: CTAs, aktive Chips, Fokus, Fortschritt, Status BEREIT |
| `primary` | `#7C4DFF` | Vuetify-Theme-Primary (im UI kaum sichtbar, nur Theme-intern) |
| `background` / `surface` | `#202020` | App-Hintergrund, App-Bar, Sidebar |
| `content` | `#191919` | Content-Pane (abgerundete Hauptfläche) |
| `surface-raised` | `#262626` | Erhöhte Panels, Akkordeons (Dialog: `#232323`) |
| `surface-chip` | `#2E2E2E` | Neutrale Chips, Zähler |
| `bubble` | `#2A2A2A` | User-Chat-Bubble |
| `border` | `#3A3A3A` | Standard-Rahmenlinie (Boxen, Panels) |
| `border-light` | `#777777` | Sekundäre Rahmen (Tiles, Swatches) |
| `text` | `#FFFFFF` | Primärtext |
| `text-secondary` | `#CFCFCF` | Sekundärtext |
| `text-muted` | `#8A8A8A` | Placeholder |
| `info` | `#5C7CFA` | Status NEU |
| `warning` | `#FF9800` | Status IN ARBEIT |
| `success` | `#edff01` | Status BEREIT (= accent) |
| `error` | `#F44336` | Status FEHLER (Alert-Icon: `#E53935`) |
| `on-accent` | `#000000` | Text/Icons auf Accent-Flächen — **immer schwarz** |

Als CSS-Custom-Properties (Kanonform, identisch im Renderer):

```css
:root {
  --aissist-accent: #edff01;
  --aissist-surface: #202020;
  --aissist-content: #191919;
  --aissist-surface-raised: #262626;
  --aissist-surface-chip: #2E2E2E;
  --aissist-bubble: #2A2A2A;
  --aissist-border: #3A3A3A;
  --aissist-border-light: #777777;
  --aissist-text: #FFFFFF;
  --aissist-text-secondary: #CFCFCF;
  --aissist-text-muted: #8A8A8A;
  --aissist-info: #5C7CFA;
  --aissist-warning: #FF9800;
  --aissist-success: #edff01;
  --aissist-error: #F44336;
}
```

### Typografie

Schriftfamilie: **Roboto** (Vuetify-Standard), Gewichte 300 / 400 / 500 / 700 / 900.

| Rolle | Größe | Gewicht | Verwendung |
| --- | --- | --- | --- |
| `h1` | 30px | 400 | View-Titel (z. B. „Freitext", „Wähle deinen Agent") |
| `h2` | 24px | 600 | Abschnittstitel, Live-Vorschau |
| `h3` | 19px | 700 | Untertitel in Inhalten |
| `subtitle` | 22px | 300 | Beschreibender Hero-Text unter dem Titel |
| `body` | 17px | 400 | Fließtext (line-height 1.5–1.6) |
| `label` | 15px | 400 | Feldbeschriftungen (mit Info-Icon) |
| `caption` | 12–14px | 500–700 | Status, Hints, Tabs |
| `button` | 13–15px | 700 | UPPERCASE, letter-spacing 0.08–0.12em |

### Spacing

Vuetify-4px-Raster.

| Token | Wert |
| --- | --- |
| `xs` | 4px |
| `sm` | 8px |
| `md` | 16px |
| `lg` | 24px |
| `xl` | 40px |

### Radius

| Token | Wert | Verwendung |
| --- | --- | --- |
| `sm` | 8px | Thumbnails, kleine Tiles |
| `md` | 14px | Filterleisten, Eingabe-Panels, Upload-Chips |
| `lg` | 18px | Karten, Prompt-Box, Chat-Bubbles |
| `xl` | 26px | Große Panels, Dialog (Content-Pane-Ecke: 28px) |
| `pill` | 9999px | Buttons, Chips, Selects, Suchfelder |

### Elevation

Flat-Design. **Keine Schatten.** Abgrenzung erfolgt ausschließlich über 1px-Borders
und Flächenabstufung (`surface` → `content` → `surface-raised`).

---

## 2. Komponentenmodell

Maximal 10 Kernkomponenten. Ausdrucksstärke entsteht über **Varianten** und
**Komposition**, nicht über neue Komponenten. Neue Komponenten folgen der
Eskalationsleiter (siehe Abschnitt 4).

| # | Komponente | Beschreibung | Varianten |
| --- | --- | --- | --- |
| 1 | `page` | Grundlayout einer View (Hero, Content, optional Settings-Spalte, Sidebar) | gesteuert über `layout.preset` |
| 2 | `button` | Aktionselement, immer pill-förmig | `primary`, `outlined`, `icon`, `text` |
| 3 | `input` | Alle Eingabefelder, outlined auf transparentem Grund | `text`, `textarea`, `select`, `search`, `slider`, `switch`, `colorpicker`, `prompt` |
| 4 | `chip` | Kompaktes Status-/Auswahl-Element, pill | `active`, `neutral`, `removable`, `counter` |
| 5 | `card` | Rahmenbasierter Container mit Titel, Text, Aktionszeile | `default`, `create`, `compact` |
| 6 | `list` | Vertikale Navigationsliste (Sidebar) | — |
| 7 | `tabs` | Umschalter zwischen Ansichten/Filtern | `segmented`, `underline` |
| 8 | `panel` | Gerahmter, optional einklappbarer Container | `collapsible`, `accordion`, `overlay` |
| 9 | `upload` | Drag-&-Drop-Zone mit Status-Chips | — |
| 10 | `message` | Chat-Nachricht im Verlauf | `user`, `assistant` |

### Varianten-Details

**button** — `primary`: flat, accent-Fill, schwarzer Text, bold uppercase. `outlined`:
accent-Rahmen, transparent. `icon`: runder Icon-Button (z. B. Senden). `text`: rahmenlos.

**input** — `prompt` ist die zusammengesetzte Chat-Eingabe (Textarea + eingebettete Panels
+ Chips + Senden-Button + optionale Zähler w/z/t). `slider` zeigt Wert-Pill rechts.
`colorpicker` ist ein einklappbares Panel mit Swatches.

**chip** — `active`: accent-Fill, schwarzer Text. `neutral`: `#2E2E2E`. `removable`: outlined
accent mit Close-Icon. `counter`: small, neutral.

**card** — `default`: Titel, Beschreibung, Footer-Icons, Favoriten-Stern. `create`: gestrichelter
Rahmen, zentrierter Plus-Button (CTA). `compact`: Datei-Karte mit Icon, Name, Delete, Switch.

**panel** — `collapsible`: einklappbar mit Header (Titel, Info-Icon, optionale Progress-Bar).
`accordion`: gestapelte Sektionen mit Auswahl-Grid. `overlay`: zentrierter Dialog.

**message** — `user`: rechtsbündige Bubble (`#2A2A2A`), optional Datei-Tiles. `assistant`:
linksbündiges Rich-Text-Layout ohne Bubble.

---

## 3. Mapping auf Vuetify

| Komponente | Vuetify-Komponente |
| --- | --- |
| `page` | `v-app` + `v-app-bar` + `v-navigation-drawer` + `v-main` |
| `button` | `v-btn` (rounded="pill", variant: flat/outlined/text, icon) |
| `input.text` / `search` | `v-text-field` (variant="outlined", rounded="pill"/"lg") |
| `input.textarea` | `v-textarea` (variant="outlined" / "plain") |
| `input.select` | `v-select` (rounded, multiple) |
| `input.slider` | `v-slider` + Wert-Pill |
| `input.switch` | `v-switch` (color="accent", inset) |
| `input.colorpicker` | `v-color-picker` (modes=['hex']) |
| `chip` | `v-chip` (rounded="pill", variant="flat"/"outlined", closable) |
| `card` | `v-card` / `v-sheet` (variant="outlined", rounded="lg") |
| `list` | `v-list` + `v-list-item` + `v-list-subheader` |
| `tabs.segmented` | `v-btn-toggle` / custom |
| `tabs.underline` | `v-tabs` (custom Styling) |
| `panel.collapsible` / `accordion` | `v-expansion-panels` / `v-sheet` + `v-divider` |
| `panel.overlay` | `v-dialog` + `v-sheet` (rounded="xl") |
| `panel` Progress | `v-progress-linear` (color="accent", rounded) |
| `upload` | custom Dropzone-`div` + `v-btn` + `v-chip` |
| `message` | custom `div` (Bubble) / `v-html`-Container |

---

## 4. Governance: Eskalationsleiter für neue Komponenten

Bevor eine neue Komponente eingeführt wird, wird in dieser Reihenfolge geprüft:

1. **Komposition** — Lässt sich der Bedarf mit bestehenden Komponenten abbilden?
   (z. B. `panel` + `chip` statt einer „Filter-Bar"). Kein Proposal nötig.
2. **Neue Variante** — Reicht eine zusätzliche Variante einer bestehenden Komponente?
   Geringes Risiko, kein Proposal nötig, nur hier dokumentieren.
3. **Neue Komponente (Proposal)** — Erst wenn 1 und 2 scheitern. Mit Begründung,
   *warum* Komposition nicht reicht, plus Vuetify-Mapping. Wird als
   `status: experimental` isoliert (siehe Renderer-Registry, To-do 2).

**Regeln:**
- Tokens sind tabu. Experimentelle Komponenten dürfen neue Strukturen einführen,
  aber **keine neuen Farben oder Radien**.
- Promotion `experimental` → `stable` ist eine menschliche Entscheidung (UX + Dev).
  Der Agent schlägt vor, befördert nie selbst.
- Verfallsregel: Was nach einigen Wochen nicht promotet wird, fliegt raus.
- Verboten: freie HTML-/CSS-/Vuetify-Wildwüchse außerhalb der Registry. Unbekannte
  Komponenten rendern im Renderer als sichtbare Fallback-Box, nicht still.

---

## 5. Prinzipien

- **Flat over elevation** — Borders und Flächenabstufung statt Schatten.
- **Pill-first** — Buttons, Chips, Selects sind pill-förmig; schwarzer Text auf Accent.
- **Wenige Komponenten, viele Varianten** — Reduktion ist Feature, nicht Mangel.
- **Spec bleibt layoutfrei** — Layout-Verantwortung liegt im Renderer (siehe
  `LAYOUT-PRESETS.md`), nicht in der Feature-Spec.
- **Anti-Halluzination** — Unbekanntes wird nicht geraten, sondern sichtbar markiert.
