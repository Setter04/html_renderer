# AISSIST Prototype Renderer

Ein Werkzeug für das AISSIST-Produktteam, um Feature-Ideen als klickbare
UI-Prototypen zu visualisieren — ohne Build-Schritt, ohne Figma, ohne Code.

Eine YAML-Datei beschreibt das Feature. Der Renderer macht daraus eine klickbare
AISSIST-Oberfläche im Browser.

---

## Schnellstart

1. `aissist-prototype-renderer.html` herunterladen
2. Per Doppelklick im Browser öffnen
3. YAML ins linke Panel einfügen → Prototyp erscheint rechts

Kein Server, kein npm, kein Setup.

---

## Repo-Inhalt

## Repo-Inhalt

| Datei / Ordner | Beschreibung |
|---|---|
| `aissist-prototype-renderer.html` | Der Renderer — standalone, läuft direkt im Browser |
| `DESIGN-SYSTEM.md` | Designsystem: Tokens, Komponenten, Vuetify-Mapping, Governance |
| `LAYOUT-PRESETS.md` | Layout-Presets und Slot-Referenz |
| `features/` | Optionaler Ordner für YAML-Feature-Dateien (Methode B) |
| `skill.md` | Agent Skill — enthält `SKILL.md`, Renderer-Kopie, Docs und Deploy-Script |

---

## YAML-Grundstruktur

```yaml
specVersion: 1

feature:
  id: mein-feature
  name: "Feature-Name"
  goal: "Was soll die Nutzerin erreichen können?"

theme: aissist-dark

navigation:
  start: start-screen

screens:
  - id: start-screen
    title: "Titel"
    layout:
      preset: default       # default · editor · fullscreen · split
    components:
      - type: button
        variant: primary
        label: Weiter
        action: navigate:naechster-screen
```

Vollständiges Schema und alle Komponenten: → `DESIGN-SYSTEM.md`

---

## Komponenten

10 Kernkomponenten, rekursiv verschachtelbar:

`button` · `input` · `chip` · `card` · `list` · `tabs` · `panel` · `upload` · `message` · `page`

Jede Komponente hat Varianten statt Sonderfälle — z. B. `input` deckt `text`,
`textarea`, `select`, `search`, `slider`, `switch`, `colorpicker` und `prompt` ab.

---

## Layout-Presets

| Preset | Sidebar | Settings-Spalte | Use Case |
|---|---|---|---|
| `default` | ✅ | — | Chat, Listen, Galerien |
| `editor` | ✅ | ✅ (`slot: settings`) | Konfiguration + Vorschau |
| `fullscreen` | — | — | Formulare, Onboarding |
| `split` | — | — | Vergleich, A/B (`slot: left` / `slot: right`) |

---

## Feature-Datei per URL laden (optional)

Für reproduzierbare Features kann die YAML-Datei per URL-Parameter geladen werden.
Dafür ist ein lokaler HTTP-Server nötig:

```bash
python3 -m http.server 8080
```

```
http://localhost:8080/aissist-prototype-renderer.html?feature=mein-feature
```

Der Renderer sucht dann `features/mein-feature.yaml` relativ zur HTML-Datei.

---

## Neue Komponenten vorschlagen

Das Komponentenmodell wächst kontrolliert:

1. **Komposition prüfen** — lässt sich der Bedarf aus vorhandenen Komponenten zusammensetzen?
2. **Neue Variante** — reicht eine zusätzliche Variante eines bestehenden Typs?
3. **Proposal** — erst wenn beides nicht reicht, als `COMPONENT-PROPOSAL` im YAML-Kommentar dokumentieren

Experimental-Komponenten werden in `DESIGN-SYSTEM.md` als `status: experimental` geführt
und erst nach Review als stable markiert. Neue Farben oder Radien außerhalb der
bestehenden Tokens sind nicht erlaubt.

---

## Agent Skill

Im Ordner `aissist-prototyping/` liegt ein installierbarer Skill für diesen Workflow:
Feature-Briefing → Fit-Check → YAML-Generierung → Deployment-Anweisung.

Der Skill enthält `DESIGN-SYSTEM.md` und `LAYOUT-PRESETS.md` als lokale Snapshots
sowie ein Deploy-Script für den lokalen HTTP-Server. Er ist agent-unabhängig und
funktioniert in jedem Kontext, der das Skill-Format unterstützt.

---

## Stack

Vue 3 · Vuetify 3 · js-yaml — alles via CDN, kein Build-Schritt.

## Stack

Vue 3 · Vuetify 3 · js-yaml — alles via CDN, kein Build-Schritt.
