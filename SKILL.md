---
name: aissist-prototyping
version: 2.0.0
description: >
  Erstellt und iteriert YAML Feature-Specs für den AISSIST Prototype Renderer
  — vom Feature-Briefing bis zum lokal deployten Klickdummy im Browser.
  Immer verwenden wenn: ein AISSIST-Prototyp oder Klickdummy gebaut werden
  soll, eine Feature-Spec als YAML geschrieben oder überarbeitet werden soll,
  jemand fragt „welche Komponenten kann der Renderer?", „passt mein Feature
  zu den vorhandenen Komponenten?", „brauche ich eine neue Komponente?" oder
  wenn eine User Story, ein Feature-Briefing oder eine Featurebeschreibung
  vorliegt und daraus ein YAML entstehen soll. Dieser Skill enthält den
  vollständigen Komponenten-Prüfprozess (Fit-Check → Kompositionslösung →
  Experimental-Proposal) und die Deployment-Anleitung für den lokalen Renderer.
  Auch bei Fragen zu Layout-Presets, dem YAML-Schema oder der Renderer-Bedienung
  diesen Skill verwenden — nicht auf Vorwissen verlassen.
assets:
  renderer: assets/aissist-prototype-renderer.html
references:
  design_system: references/DESIGN-SYSTEM.md
  layout_presets: references/LAYOUT-PRESETS.md
scripts:
  deploy_local: scripts/deploy-local.sh
---

# AISSIST Prototyping Skill

Dieser Skill steuert den vollständigen Workflow vom Feature-Briefing bis zum
laufenden lokalen Klickdummy im Browser.

**Skill-Struktur:**
```
aissist-prototyping/
├── SKILL.md                              ← diese Datei
├── assets/
│   └── aissist-prototype-renderer.html  ← Renderer (standalone, kein Build)
├── references/
│   ├── DESIGN-SYSTEM.md                 ← Vollständiger Komponentenkatalog
│   └── LAYOUT-PRESETS.md                ← Layout-Dokumentation
└── scripts/
    └── deploy-local.sh                  ← Lokales HTTP-Deployment
```

> **Wenn Details zu Komponenten, Tokens oder Layouts gefragt sind:**
> `references/DESIGN-SYSTEM.md` bzw. `references/LAYOUT-PRESETS.md` lesen.
> Diese Datei enthält nur die Schnellreferenz.

---

## 1. Was der Renderer kann — und was nicht

Der **AISSIST Prototype Renderer** (`assets/aissist-prototype-renderer.html`) ist
eine single-file HTML-Datei, die ohne Build-Schritt direkt im Browser läuft. Sie
nimmt eine YAML Feature-Spec entgegen und rendert daraus eine klickbare
AISSIST-Oberfläche.

### Fähigkeiten

| Fähigkeit | Details |
|---|---|
| Live-Rendering | YAML links editieren → Vorschau rechts nach 500 ms (debounced) |
| Screens | Beliebig viele Screens, Navigation per `navigate:<screen-id>` |
| AISSIST-Shell | App Bar, Sidebar, Settings-Spalte, Content-Pane — je nach Preset |
| Komponenten | 10 Kernkomponenten, rekursiv verschachtelbar |
| Chat-Modus | Automatisch aktiv wenn `input / prompt` im Screen vorhanden |
| Layout-Presets | `default` · `editor` · `fullscreen` · `split` |
| Feature-Fetch | `?feature=<id>` lädt `features/<id>.yaml` — erfordert lokalen HTTP-Server (§8 Methode B) |
| Fehlerbehandlung | Parse-Fehler: letzte gültige Spec bleibt, Fehler im Status |
| Aktionen | `navigate:<id>` · `send` · `toggle` · beliebige Strings (Snackbar) |

### Grenzen

- **Kein echter API-Call** — alles ist simuliert
- **Feature-Fetch braucht HTTP** — `?feature=` funktioniert nicht über `file://`
- **Kein Komponentenbau on-the-fly** — neue Typen → Proposal-Prozess (§6)
- **Keine Bilder** — nur Text, MDI-Icons, Vuetify-Elemente
- **Unbekannte Typen** rendern als rote Fallback-Box (kein Crash, aber kein UI)

---

## 2. Design Tokens (Kurzreferenz)

> Vollständig: `references/DESIGN-SYSTEM.md` (Abschnitt 1) — bei Detailfragen dort nachlesen.

| Token | Wert | Verwendung |
|---|---|---|
| `accent` | `#edff01` | CTAs, aktive Chips, Fokus, Progress, Status BEREIT |
| `background` / `surface` | `#202020` | App-Bar, Sidebar, App-Hintergrund |
| `content` | `#191919` | Content-Pane (abgerundete Hauptfläche) |
| `surface-raised` | `#262626` | Panels, Akkordeons |
| `surface-chip` | `#2E2E2E` | Neutrale Chips |
| `border` | `#3A3A3A` | Standard-Rahmen |
| `text` | `#FFFFFF` | Primärtext |
| `text-secondary` | `#CFCFCF` | Sekundärtext |
| `text-muted` | `#8A8A8A` | Placeholder |
| `on-accent` | `#000000` | Text/Icons auf Accent — **immer schwarz** |
| Font | Roboto | Gewichte 300 / 400 / 500 / 700 / 900 |
| Icons | MDI | Material Design Icons |

**Wichtig:** Keine Schatten (Flat Design). Abgrenzung nur über Borders und
Flächenabstufung. Tokens sind tabu — Experimental-Komponenten dürfen keine
neuen Farben oder Radien einführen.

---

## 3. YAML-Schema (vollständig)

```yaml
specVersion: 1                        # Pflicht, immer 1

feature:
  id: kebab-case-id                   # Pflicht, eindeutig
  name: "Feature-Name"                # Pflicht
  goal: "Was soll die Nutzerin …"     # Pflicht, 1–2 Sätze
  description: "Optional"            # optional

theme: aissist-dark                   # fix, nicht ändern

navigation:
  start: screen-id                    # Pflicht, muss einer der Screen-IDs sein

# Optionale Contract-Sektionen (Renderer ignoriert sie — für Dev-Handoff):
# behavior:
#   - trigger: "Nutzerin klickt X"
#     result: "Y passiert"
#     assumed: true
# openQuestions:
#   - "Welches Endpoint liefert die Daten?"

screens:
  - id: screen-id                     # eindeutig, kebab-case
    title: "Screen-Titel"             # Hero-Überschrift
    subtitle: "Optional"             # Hero-Untertitel
    layout:
      preset: default                # default | editor | fullscreen | split
    components:
      - type: <komponente>           # Pflicht — einer der 10 Typen (§4)
        variant: <variante>          # optional, typspezifisch
        label: "Beschriftung"        # optional
        slot: settings               # optional: settings | left | right (§5)
        props: {}                    # typspezifisch (§4)
        children: []                 # rekursiv verschachtelbar
        action: "navigate:screen-id" # navigate:<id> | send | toggle | <string>
        assumed: true                # optional, markiert Annahmen
```

### Regeln

- `id`-Werte: immer kebab-case, keine Leerzeichen
- `children` werden rekursiv gerendert — jede Tiefe erlaubt
- `slot: settings` nur wirksam bei `preset: editor`
- `slot: left` / `slot: right` nur wirksam bei `preset: split`
- Falsche Slots werden ignoriert (Komponente landet im Content-Bereich)
- `assumed: true` auf jedem Feld möglich — Renderer ignoriert es, Team sieht es
- Unbekannte `type`-Werte → rote Fallback-Box, kein Crash

---

## 4. Komponenten-Referenz

> Vollständig mit Props und Vuetify-Mapping: `references/DESIGN-SYSTEM.md` Abschnitte 2–3
> — bei Detailfragen dort nachlesen, nicht auf Vorwissen verlassen.

| `type` | Varianten | Wichtigste Props |
|---|---|---|
| `button` | `primary` (default) · `outlined` · `icon` · `text` | `label`, `icon`, `action` |
| `input` | `text` · `textarea` · `select` · `search` · `slider` · `switch` · `colorpicker` · `prompt` | `placeholder`, `items`, `value`, `hint`, `multiple` |
| `chip` | `active` · `neutral` (default) · `removable` · `counter` | `label`, `icon`, `action` |
| `card` | `default` · `create` · `compact` | `label`, `description`, `icon`, `favorite`, `active`, `action` |
| `list` | – | `items: [{label, icon, meta, action}]` |
| `tabs` | `segmented` · `underline` | `items: [string]`, `active` |
| `panel` | `collapsible` (default) · `accordion` · `overlay` | `label`, `collapsed`, `children` |
| `upload` | – | `label`, `formats`, `maxSize` |
| `message` | `user` · `assistant` | `text`, `html`, `files` |
| `page` | – | Meta-Wrapper, normalerweise nicht direkt verwendet |

**Renderer-wahre Prop-Regeln:**
- `message.user` rendert `props.text`; optionale Datei-Tiles über `props.files: [DOCX, PDF]`
- `message.assistant` rendert bevorzugt `props.html`; ohne HTML fällt es auf `props.text` zurück
- `message.props.content` wird nicht angezeigt — nicht verwenden
- `upload` zeigt `props.formats` und `props.maxSize`; `accept`/`multiple` sind für Handoff, nicht sichtbar
- `panel`-Fortschritt nutzt numerisch `props.progress` plus optional `props.progressLabel`
- `input.prompt` kann `props.counters`, `props.hint`, `props.rows` und `children` aus `panel`/`chip` nutzen

**Verschachtelungsmuster:**
- `panel` → `children` → `input`, `chip`, `button`, weitere `panel`
- `card` → `children` → `list`, `button`
- `tabs` → `children` (nach Tab-Selektion gerendert)

---

## 5. Layout-Presets

> Vollständig mit Slot-Referenz: `references/LAYOUT-PRESETS.md`
> — bei Detailfragen dort nachlesen.

| Preset | Sidebar | Settings-Spalte | Typischer Use Case |
|---|---|---|---|
| `default` | ✅ | — | Chat, Galerien, Listen |
| `editor` | ✅ | ✅ 330px (`slot: settings`) | Bildgenerierung, Konfiguration + Vorschau |
| `fullscreen` | — | — | Fokussierte Formulare, Onboarding |
| `split` | — | — | Vergleich, A/B — via `slot: left` / `slot: right` |

Fehlt `preset`, fällt der Renderer auf `default` zurück. Unbekannte Presets
zeigen eine Warnung und rendern als `default`.

---

## 6. Komponenten-Fit-Check & Escalation-Ladder

Vor dem Schreiben von YAML wird systematisch geprüft, ob die nötigen
UI-Elemente abbildbar sind. Das verhindert Renderer-Überraschungen und
hält das Komponentenmodell stabil.

### Prüfprozess (immer in dieser Reihenfolge)

**Stufe 1 — Direkter Fit**
Lässt sich das Element 1:1 mit einem der 10 Typen und Varianten abbilden?
→ Einsetzen, fertig.

*Beispiel:* „Dropdown" → `input / select` ✓

---

**Stufe 2 — Komposition**
Lässt sich das Element aus mehreren vorhandenen Komponenten zusammensetzen?
Komposition braucht keine Renderer-Änderung und funktioniert sofort.

| Gewünschtes Element | Kompositionslösung |
|---|---|
| Filterpanel mit Checkboxen | `panel` (collapsible) → `chip` (active/neutral) × n |
| Schritt-für-Schritt-Wizard | `tabs` (underline) → Screens pro Schritt |
| Bestätigungsdialog | `panel` (overlay) → `button` (primary + outlined) |
| Statistik-Kacheln | `card` (compact) × n |
| Fortschrittsanzeige | `panel` (collapsible) mit numerischem `props.progress` |

Wenn eine Komposition das Ziel erfüllt: umsetzen und im YAML kurz kommentieren,
warum diese Lösung gewählt wurde.

---

**Stufe 3 — Neue Variante experimentell ergänzen**
Fehlt nur eine Variante eines vorhandenen Typs (z. B. `card` mit Statusbadge)?
→ Variante im YAML als Proposal markieren **und** als experimentelle Erweiterung
im Renderer und Designsystem ergänzen.

```yaml
# VARIANT-PROPOSAL: card / status-badge
# Beschreibung: Card mit farbigem Badge (success/warning/error) oben rechts
# Begründung: Wird in 3+ Screens gebraucht, Komposition nicht ausreichend
# Status: experimental — in Renderer und references/DESIGN-SYSTEM.md aufzunehmen
- type: card
  variant: status-badge
  props:
    status: warning
    assumed: true
```

Wenn die Variante umgesetzt werden soll:
- `assets/aissist-prototype-renderer.html`: Variante in `SpecNode` implementieren
- `references/DESIGN-SYSTEM.md`: Variante unter der bestehenden Komponente als
  `status: experimental` dokumentieren
- YAML-Beispiel unter `features/<id>.yaml` aktualisieren
- Im Browser prüfen: keine Fallback-Box, Variante sichtbar, bestehende Demo intakt

---

**Stufe 4 — Neue Kernkomponente experimentell ergänzen**
Nur wenn weder Komposition noch Variante reichen. Bis zur Implementierung eine
Annäherung liefern; wenn Umsetzung gewünscht ist, Renderer und Doku gemeinsam ändern:

```markdown
## COMPONENT-PROPOSAL: <typ-name>

**Problem:** [Warum reicht Komposition nicht?]
**Vorgeschlagener Typ:** `<kebab-case>`
**Varianten (initial):** `default` · `<variante>`
**Props (minimal):** `label`, `<prop>`
**Verwendung:** [Screen-ID + Begründung]
**Häufigkeit:** [Wie oft taucht dieses Muster auf?]
**Status:** `experimental`
**Nächster Schritt:** In references/DESIGN-SYSTEM.md eintragen und
                      assets/aissist-prototype-renderer.html ergänzen
```

Experimentelle Kernkomponenten brauchen mindestens:
- Eintrag in `references/DESIGN-SYSTEM.md` mit `status: experimental`,
  Zweck, Varianten, minimalen Props und Vuetify-Mapping
- Render-Zweig in `assets/aissist-prototype-renderer.html`
- Fallback-freies Beispiel in `features/<feature-id>.yaml`
- Browser-Verifikation für Beispiel und vorhandene Default-Spec

---

**Stufe 5 — Neues Layout-Preset experimentell ergänzen**
Wenn `default`, `editor`, `fullscreen` und `split` nicht reichen, darf ein neues
Layout ergänzt werden. Keine freien Layout-Parameter in YAML erfinden.

```markdown
## LAYOUT-PROPOSAL: <preset-name>

**Problem:** [Warum reichen bestehende Presets/Slots nicht?]
**Preset:** `<kebab-case>`
**Slots:** `<slot-a>` · `<slot-b>`
**Struktur:** [Makrostruktur, z. B. Sidebar + Canvas + Inspector]
**Verwendung:** [Screen-ID + Begründung]
**Status:** `experimental`
**Nächster Schritt:** In references/LAYOUT-PRESETS.md eintragen und
                      assets/aissist-prototype-renderer.html ergänzen
```

Experimentelle Layouts brauchen mindestens:
- Eintrag in `references/LAYOUT-PRESETS.md` mit `status: experimental`,
  Struktur, Slots, Responsive-Verhalten und Use Case
- Eintrag im Renderer-`PRESETS`-Objekt
- Render-Zweig in `assets/aissist-prototype-renderer.html`
- Beispiel-Screen in `features/<feature-id>.yaml`
- Browser-Verifikation bei Desktop und schmalem Viewport

---

### Entscheidungsbaum

```
Feature-Anfrage
      │
      ▼
Direkter Fit mit 10 Kerntypen?
  JA → YAML schreiben                          (Stufe 1)
  NEIN ↓
Durch Komposition lösbar?
  JA → Komposition + Kommentar                 (Stufe 2)
  NEIN ↓
Neue Variante eines vorhandenen Typs?
  JA → Variante + VARIANT-PROPOSAL             (Stufe 3)
  NEIN ↓
Neue Kernkomponente nötig?
  JA → COMPONENT-PROPOSAL + experimental Impl. (Stufe 4)
  NEIN ↓
Neues Layout-Preset nötig?
  JA → LAYOUT-PROPOSAL + experimental Impl.    (Stufe 5)
```

**Governance-Regeln (aus `references/DESIGN-SYSTEM.md` §4):**
- Tokens sind tabu — keine neuen Farben oder Radien in Proposals
- `experimental` → `stable` ist eine menschliche Entscheidung
- Wenn nach einigen Wochen kein Promote: Komponente fliegt raus
- Keine freien CSS/Vuetify-Wildwüchse außerhalb der Registry
- Experimentelles gehört ins Skill: Renderer-Datei, Design-/Layout-Doku und
  Feature-Beispiel müssen gemeinsam aktualisiert werden
- YAML darf experimentelle Typen/Varianten/Presets erst produktiv verwenden,
  wenn der Renderer sie ohne Fallback-Box rendert

---

## 7. Workflow

### Schritt 1 — Feature verstehen

Frage, falls nicht aus dem Kontext klar:
- **Was ist das Ziel der Nutzerin?** (1–2 Sätze)
- **Welche Screens / welcher Flow?** (z. B. „nur Upload-Dialog" vs. „kompletter Flow")
- **User Story oder Briefing vorhanden?**

Modus aus dem Kontext ableiten:
- **Modus A** — YAML + Erklärung parallel (Standard)
- **Modus B** — YAML zuerst, User Story auf Anfrage
- **Modus C** — User Story zuerst, YAML auf Anfrage

### Schritt 2 — Fit-Check (§6)

Vor dem ersten YAML-Zeichen den Fit-Check aus §6 durchlaufen.
Ergebnis transparent kommunizieren, z. B.:

> „Für die KPI-Kacheln gibt es keinen direkten Fit. Ich löse das per
> Komposition: 3× `card` (compact). Für den Echtzeit-Chart wäre eine neue
> Komponente nötig — ich baue eine Annäherung mit `panel` + `message`
> und schreibe einen COMPONENT-PROPOSAL dazu."

### Schritt 3 — YAML schreiben

- Mit `specVersion: 1` und vollständigem `feature:`-Block beginnen
- `feature.goal` in 1–2 Sätzen
- Screens logisch sortieren, `navigation.start` setzen
- Nur Kerntypen verwenden (oder Kompositionslösungen aus Schritt 2)
- Unbekannte Werte mit `assumed: true` markieren
- Offene Fragen in `openQuestions`
- Proposals als Kommentare direkt im YAML

**Anti-Halluzinations-Regel:** Nichts erfinden. Unbekannte Werte (z. B. welche
Items ein Select enthält) als Platzhalter + `assumed: true`.

### Schritt 4 — Deployment-Anweisung mitliefern

```
➜ Deployment (Methode A — schnelle Iteration):
1. assets/aissist-prototype-renderer.html im Browser öffnen
2. YAML vollständig in das linke Panel einfügen
3. „Anwenden" klicken → Prototyp erscheint rechts
```

Wenn eine Feature-Datei angelegt wird, zusätzlich Methode B angeben:

```
➜ Deployment (Methode B — überprüfbare Feature-Datei):
1. YAML als features/<feature-id>.yaml neben dem Renderer ablegen
2. scripts/deploy-local.sh ausführen (oder: python3 -m http.server 8080)
3. Öffnen: http://localhost:8080/aissist-prototype-renderer.html?feature=<id>
```

Vor dem Liefern prüfen:
- YAML parsen (z. B. mit `python3 -c "import yaml; yaml.safe_load(open('features/<id>.yaml'))"`)
- Im Browser laden: Zieltexte sichtbar, keine rote Fallback-Box, kein Fehler

Falls Proposals enthalten:
> „Komponenten mit Proposal erscheinen als rote Fallback-Box — das ist korrekt.
> Der Kommentar im YAML ist die Grundlage für die nächste Renderer-Erweiterung."

### Schritt 5 — Iteration

- Feedback → YAML anpassen → erneut liefern
- Bei neuen UI-Wünschen: Fit-Check wiederholen, keine neuen `type`-Werte erfinden
- Proposals akkumulieren: 3+ Features mit gleicher fehlender Komponente = starkes
  Signal für eine Renderer-Erweiterung

---

## 8. Lokales Deployment

### Methode A — YAML direkt einfügen (schnelle Iteration)

1. `assets/aissist-prototype-renderer.html` per Doppelklick im Browser öffnen
2. Linkes YAML-Panel: bestehenden Code vollständig ersetzen
3. „Anwenden" klicken (oder 500 ms warten) → Live-Update

Kein HTTP-Server nötig. Funktioniert offline.

### Methode B — YAML-Datei per URL-Parameter (reproduzierbare Features)

Voraussetzung: lokaler HTTP-Server (siehe `scripts/deploy-local.sh`).

```bash
# Kurzform:
python3 -m http.server 8080
```

```
http://localhost:8080/aissist-prototype-renderer.html?feature=mein-feature
```

Renderer sucht dann `features/mein-feature.yaml` relativ zum Renderer-Verzeichnis:

```
/ordner/
├── assets/
│   └── aissist-prototype-renderer.html
└── features/
    └── mein-feature.yaml
```

Regeln für `?feature=<id>`:
- `<id>` muss kebab-case sein (`^[a-z0-9][a-z0-9-]*$`)
- Renderer hängt selbst `features/` und `.yaml` an
- Bei 404 oder Netzwerkfehler bleibt die Default-Spec sichtbar, Status zeigt Fehler
- Cache-Buster bei Iteration: `?feature=mein-feature&v=2`

### Methode C — GitHub Pages (Team-Sharing)

Nur nötig für Team-übergreifendes Sharing. Für lokale Iteration reicht Methode A.
→ Repo `Setter04/html_renderer`, GitHub Pages Deployment.

---

## 9. Häufige Fehler

| Fehler | Ursache | Fix |
|---|---|---|
| Nichts passiert / weißer Screen | YAML-Parse-Fehler | Statuszeile lesen; meist falsche Einrückung oder Tabs statt Spaces |
| Rote Fallback-Box | `type` unbekannt oder Proposal-Variante | Typ aus §4 prüfen — oder ist es ein bewusster Proposal? |
| Settings-Spalte leer | `slot: settings` ohne `preset: editor` | `layout.preset: editor` setzen |
| `slot: left/right` ignoriert | `preset` ist nicht `split` | `layout.preset: split` setzen |
| `navigate:` löst nichts aus | Screen-ID falsch | ID in `screens[].id` prüfen, exakt matchen |
| YAML per URL nicht geladen | Kein HTTP-Server | `scripts/deploy-local.sh` ausführen oder `python3 -m http.server 8080` |
| YAML per URL zeigt alte Version | Browser-Cache | Cache-Buster anhängen: `&v=2` |
| Message bleibt leer | Falscher Prop-Name | `props.text` oder `props.html` verwenden, nicht `content` |
| Upload-Hinweise fehlen | Falsche Upload-Props | `props.formats` und `props.maxSize` verwenden |

---

## 10. Vollständiges Beispiel-YAML

```yaml
specVersion: 1

feature:
  id: dokument-chat
  name: Dokument-Chat
  goal: >
    Die Nutzerin soll Dokumente hochladen und anschließend gezielt
    Fragen dazu stellen können — mit Quellangaben in der Antwort.

theme: aissist-dark

navigation:
  start: upload

openQuestions:
  - "Maximale Dokumentanzahl pro Session?"
  - "Welche Dateiformate werden unterstützt?"

screens:
  - id: upload
    title: Dokumente hochladen
    subtitle: Lade deine Dateien hoch, um den Chat zu starten
    layout:
      preset: default
    components:
      - type: upload
        label: Dateien auswählen oder hierher ziehen
        props:
          formats: "pdf, docx, txt"
          maxSize: 15 MB
      - type: button
        variant: primary
        label: Chat starten
        action: navigate:chat

  - id: chat
    title: Dokument-Chat
    layout:
      preset: editor
    components:
      - type: list
        slot: settings
        props:
          items:
            - label: Q3-Report.pdf
              icon: mdi-file-pdf-box
              meta: "2,4 MB"
            - label: Strategie-2025.docx
              icon: mdi-file-word-box
              meta: "840 KB"
              assumed: true
      - type: button
        variant: outlined
        label: Weiteres Dokument
        slot: settings
        action: navigate:upload
      - type: message
        variant: assistant
        props:
          text: Ich habe 2 Dokumente geladen. Was möchtest du wissen?
      - type: input
        variant: prompt
        action: send
        props:
          placeholder: Stelle eine Frage zu deinen Dokumenten …
          hint: Antworten basieren auf den hochgeladenen Dateien

behavior:
  - trigger: "Nutzerin sendet Frage"
    result: "Antwort erscheint mit Quellenangabe (Dateiname + Seite)"
    assumed: true
```

---

## 11. Versionierung & Sync

Bei Änderungen am Renderer oder Designsystem muss dieser Skill manuell
aktualisiert werden.

**Sync-Checkliste (bei Renderer-Update):**
- [ ] Design Tokens in §2 mit `references/DESIGN-SYSTEM.md` abgleichen
- [ ] Komponenten-Tabelle in §4 prüfen (Typen, Varianten, Props, experimental/stable Status)
- [ ] Renderer-HTML prüfen: tatsächliche Prop-Namen in `SpecNode` abgleichen
- [ ] Layout-Presets in §5 prüfen (inkl. experimenteller Presets und Slots)
- [ ] Feature-Fetch prüfen: `?feature=<id>` → `features/<id>.yaml`, Fehlerpfad bei 404
- [ ] Governance-Regeln in §6 mit `references/DESIGN-SYSTEM.md §4` abgleichen
- [ ] Bei neuen Komponenten/Varianten: `references/DESIGN-SYSTEM.md`,
      `assets/aissist-prototype-renderer.html` und Feature-YAML gemeinsam aktualisieren
- [ ] Bei neuen Layouts: `references/LAYOUT-PRESETS.md`,
      `assets/aissist-prototype-renderer.html` und Feature-YAML gemeinsam aktualisieren
- [ ] Beispiel-YAML in §10 per Parser und Browser testen
- [ ] `version` im Frontmatter erhöhen (SemVer)
- [ ] Changelog-Eintrag unten anhängen

### Changelog

| Version | Datum | Änderung |
|---|---|---|
| 1.0.0 | 2026-06 | Initiale Version — Schema v1, 10 Kernkomponenten, 4 Layout-Presets, lokales Deployment |
| 1.1.0 | 2026-06 | Komponenten-Fit-Check & Escalation-Ladder (§6), Workflow um Fit-Check erweitert |
| 1.2.0 | 2026-06 | Sync mit Repo: korrekte Farbtokens (#edff01, #202020), Chip-/Panel-Varianten, Split-Slots, Governance-Regeln |
| 1.2.1 | 2026-06 | Renderer-wahre Props ergänzt, Feature-Fetch dokumentiert, Deployment präzisiert |
| 1.3.0 | 2026-06 | Experimentelle Renderer-Erweiterungen explizit erlaubt (Varianten, Komponenten, Layouts) |
| 2.0.0 | 2026-06 | Ordner-basierte Skill-Architektur: Renderer in assets/, Docs in references/, Deploy-Script in scripts/. Frontmatter auf lokale Pfade umgestellt. Alle externen GitHub-Referenzen entfernt. Alle Formulierungen agent-unabhängig. |
