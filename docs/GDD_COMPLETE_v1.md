# SCRIPTORIUM ALCHIMICO - Game Design Document Completo v1.0

**Data:** 21 Gennaio 2026  
**Stato:** Design definitivo con dati storici integrati

---

## INDICE

1. [Vision & Core Loop](#1-vision--core-loop)
2. [Meccaniche Core](#2-meccaniche-core)
3. [Database Pigmenti Completo](#3-database-pigmenti-completo)
4. [Database Leganti](#4-database-leganti)
5. [Sistema Sintesi](#5-sistema-sintesi)
6. [Progressione e Unlock](#6-progressione-e-unlock)
7. [Bilanciamento Valori](#7-bilanciamento-valori)
8. [Implementazione Tecnica](#8-implementazione-tecnica)

---

## 1. VISION & CORE LOOP

### 1.1 Pitch
Roguelite push-your-luck dove sei un miniatore medievale. Completi manoscritti (Folii) lanciando dadi e riempiendo slot, bilanciando il rischio della Macchia contro la resa dei pigmenti tossici.

### 1.2 Loop di un Folio

```
PREPARAZIONE
↓
Scegli 1 Pigmento + 1 Legante → Applica Sintesi (se esiste)
↓
ESECUZIONE
↓
Tira 4d6 → Interpreta (1=Macchia, 2-5=slot, 6=ToccoOro)
→ Assegna risultati a un elemento della Checklist
→ Rilancia dadi non assegnati (se permesso)
→ Ripeti fino a completamento o Bust (Macchia=7)
↓
RISOLUZIONE
↓
Completato? → Bonus + Denari + avanza al Folio successivo
Bust? → Perdi Reputazione → Opzione Scraping (50 Denari)
```

### 1.3 Obiettivo Run
Completare tutti i **Folii del fascicolo** scelto senza portare la Reputazione a 0.

**Sistema Fascicoli Medievali:**
- **BIFOLIO** (2 Folii) 
- **DUERNO** (4 Folii) 
- **TERNIONE** (6 Folii)
- **QUATERNIONE** (8 Folii) 
- **QUINTERNO** (10 Folii) 
- **SESTERNO** (12 Folii) 

---

## 2. MECCANICHE CORE

### 2.1 Checklist del Folio

| Elemento | Slot | Bonus Completamento | Note |
|----------|------|---------------------|------|
| **TEXT** | 
| **DROPCAPS** | 
| **BORDERS** |
| **CORNERS** | 
| **MINIATURE** | 

### 2.2 Sistema Dadi (4d6)

**Interpretazione risultati:**
- **1** = +1 Macchia (modificabile da tossicità)
- **2-5** = Riempie 1 slot
- **6** = Tocco d'Oro: riempie 2 slot OPPURE rimuove 1 Macchia





**Reputazione (HP)**
- Inizio run: 20
- Perdi in caso di Bust o effetti negativi
- Recuperabile: Pardon (+2) se Folio completato con <2 Macchia e 0 Peccati

**Denari**
- Guadagno base: 30 per Folio completato
- Uso: Negozi (Folio 3 e 6), Scraping (50)

---

## 3. DATABASE PIGMENTI COMPLETO



### 3.2 Pigmenti per Colore

#### 🔴 ROSSI

**OCRA ROSSA** (Red Ochre)


**ROBBIA** (Madder Lake)


**MINIO** (Red Lead)


**VERMIGLIONE** (Cinabro, Vermilion)


**REALGAR**


**KERMES**

**BRAZILWOOD**

#### 💛 GIALLI

**OCRA GIALLA** (Yellow Ochre)


**ORPIMENTO** (Orpiment)


**GIALLORINO** (Lead-Tin Yellow)


**ORO MUSIVO** (Mosaic Gold)


**RESEDA** (Weld)


#### 💚 VERDI

**VERDERAME** (Verdigris)


**VERGAUT**


**MALACHITE**


#### 💙 BLU

**GUADO/INDIGO** (Woad)


**LAPISLAZZULI** (Ultramarino)


**AZZURRITE** (Azurite)


**BLU EGIZIO** (Egyptian Blue)


#### 💜 PORPORA/VIOLA

**PORPORA DI TIRO** (Tyrian Purple)

**ORCHIL**


**FOLIUM** (Turnsole)


#### 🟤⚫⚪ MARRONI, NERI, BIANCHI

**OCRA BRUNA** (Brown Ochre)
i"

**NERO FERROGALLICO** (Iron Gall)


**NERO CARBONIOSO** (Carbon Ink)

**CRETA/GESSO** (Chalk/Gypsum)

**BIANCO DI PIOMBO** (Lead White)


#### 🥇 ORO (Metallo)

**ORO** (Gold Leaf / Shell Gold)

---

## 4. DATABASE LEGANTI

### 4.1 Leganti Base

**GOMMA ARABICA** (Gum Arabic)


**GLAIR** (Albume d'Uovo)


**TUORLO D'UOVO** (Tempera)


**COLLA DI PESCE** (Fish Glue)


**MIELE** (Honey)


**LISCIVIA** (Lye)


**ACETO** (Vinegar Dilution)
)

**GOMME VEGETALI** (Plant Gum)


**COLLA DI CONIGLIO** (Rabbit Glue)


**GUM SANDARAC** (Polvere Assorbente)


---






### 6.2 Flow UX: Selezione Run

**MENU PRINCIPALE** → [New Game]
↓
**BIBLIOTECA** (Selezione Fascicolo/Libro)
- Mostra 6 libri chiusi su scaffali
- Icone: 📿 ✝️ 📜 ⏰ 📕 🐉
- Info: difficoltà, tempo, note storiche
- Visualizza unlock status
↓
**SCRIPTORIUM** (Starting Kit)
- Scegli 2 Pigmenti iniziali
- Scegli 1 Legante iniziale
- Preset suggeriti per principianti
↓
**FOLIO 1** - Inizio Run

### 6.3 Unlock Pigmenti (Progression Tree)

**Tier 1 (Inizio - Starting Kit):** Ocre, Nero Carbonioso, Creta, Reseda, Guado, Verderame
**Tier 2 (Unlock DUERNO):** Brazilwood, Folium
**Tier 3 (Unlock TERNIONE):** Minio, Giallorino, Azzurrite, Robbia
**Tier 4 (Unlock QUATERNIONE):** Vermiglione, Orpimento, Bianco di Piombo, Orchil
**Tier 5 (Unlock QUINTERNO):** Lapislazzuli, Oro, Kermes, Oro Musivo
**Tier 6 (Unlock SESTERNO + Elite Loot):** Realgar, Malachite, Blu Egizio
**Tier 7 (Boss SESTERNO):** Porpora di Tiro

### 6.3 Dadi Speciali (GDP §11)

**Vassoio:** 4 slot, inizi con 4d6 standard

**Dadi Speciali:**
- **Dado di Piombo** (30D): Facce 2,2,3,3,4,5 - no "1", no "6"
- **Punta d'Argento** (40D): Facce 1,3,4,5,6,6 - doppio "6"
- **Dado di Sego** (35D): Se esce "1", sacrifica per ignorare Macchia
- **Cubo del Rubricatore** (45D): Pari→TEXT, Dispari→DROPCAPS

**Unlock:** Negozi o loot Elite

---

