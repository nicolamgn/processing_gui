import oscP5.*;
import netP5.*;

OscP5 oscP5;

int xspacing = 8;   // Distanza orizzontale tra ogni punto
int w;              // Larghezza dell'intera onda
int maxwaves = 4;   // Numero totale di onde da sommare

float theta = 0.0;
float[] amplitude = new float[maxwaves];   // Altezza dell'onda
float[] dx = new float[maxwaves];          // Valore per l'incremento di X, da calcolare come funzione del periodo e dello spaziamento X
float[] yvalues;                           // Array per memorizzare i valori di altezza per l'onda

int signalType; // Tipo di segnale (0 = quadrata, 1 = sinusoidale, 2 = treno di impulsi, 3 = dente di sega)

void setup() {
  size(640, 360);
  frameRate(30);
  colorMode(RGB, 255, 255, 255, 100);
  w = width + 16;

  oscP5 = new OscP5(this, 12000); // Inizializza OscP5 sulla porta 12000 (puoi modificare la porta se necessario)

  for (int i = 0; i < maxwaves; i++) {
    amplitude[i] = random(10, 30);
    float period = random(100, 300); // Quanti pixel prima che l'onda si ripeta
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new float[w / xspacing];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/signal") && msg.checkTypetag("i")) {
    signalType = msg.get(0).intValue(); // Ricevi il tipo di segnale da SuperCollider
  }
}

void calcWave() {
  // Incrementa theta (prova diversi valori per 'velocità angolare' qui)
  theta += 0.02;

  // Imposta tutti i valori di altezza a zero
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }

  // Accumula i valori di altezza delle onde
  for (int j = 0; j < maxwaves; j++) {
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      // Ogni altra onda è un coseno invece di un seno
      if (j % 2 == 0) {
        if (signalType == 0) // Quadrata
          yvalues[i] += square(x) * amplitude[j];
        else if (signalType == 1) // Sinusoidale
          yvalues[i] += sin(x) * amplitude[j];
        else if (signalType == 2) // Treno di impulsi
          yvalues[i] += pulse(x) * amplitude[j];
        else if (signalType == 3) // Dente di sega
          yvalues[i] += sawtooth(x) * amplitude[j];
      } else {
        if (signalType == 0)
          yvalues[i] += square(x) * amplitude[j];
        else if (signalType == 1)
          yvalues[i] += cos(x) * amplitude[j];
        else if (signalType == 2)
          yvalues[i] += pulse(x) * amplitude[j];
        else if (signalType == 3)
          yvalues[i] += sawtooth(x) * amplitude[j];
      }
      x += dx[j];
    }
  }
}

void renderWave() {
  // Disegna l'onda con un ellisse in ogni posizione
  noStroke();
  fill(255, 50);
  ellipseMode(CENTER);
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x * xspacing, height / 2 + yvalues[x], 16, 16);
  }
}

// Funzione per generare un treno di impulsi
float pulse(float x) {
  float p = TWO_PI / 50; // Frequenza del treno di impulsi
  return sin(x * p) > 0 ? 1 : 0;
}

// Funzione per generare un dente di sega
float sawtooth(float x) {
  float p = TWO_PI / 50; // Frequenza del dente di sega
  return (x % p) / p * 2 - 1;
}
