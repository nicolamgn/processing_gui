import oscP5.*;
import netP5.*;

OscP5 oscP5;
int ellipseX;
int ellipseY;
int diameter = 50; // Diametro del pallino

void setup() {
  size(700, 500);
  ellipseX = width / 2;
  ellipseY = height / 2;
  
  oscP5 = new OscP5(this, 8000); // Inizializza la libreria OSC / la porta di ascolto
}

void draw() {
  background(0);
  // Disegna il pallino con i nuovi valori
  ellipse(ellipseX, ellipseY, diameter, diameter);
}

// Funzione per ricevere i valori tramite OSC
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/handMovement") == true) { // Controlla il messaggio
    if (msg.checkTypetag("ii")) { // Controlla che il messaggio contenga due interi
      int valueX = msg.get(0).intValue(); // Estrae il primo valore (asse X)
      int valueY = msg.get(1).intValue(); // Estrae il secondo valore (asse Y)

      // Mappa i valori X e Y sui limiti del canvas
      ellipseX = int(map(valueX, 0, 126, diameter / 2, width - diameter / 2));
      ellipseY = int(map(valueY, 0, 126, diameter / 2, height - diameter / 2));
    }
  }
}
