import controlP5.*;
import java.util.HashMap; // Importa la classe HashMap
import oscP5.*;
import netP5.*;

ControlP5 cp5;
DropdownList dropdown;
PFont f;

OscP5 oscP5;
int ellipseX;
int ellipseY;
int diameter = 50; // Diametro del pallino
int rectX, rectY, rectWidth, rectHeight; // Rettangolo di confine

void setup() {
  size(900, 600); // Imposta la dimensione della finestra
  smooth();
  f = createFont("Arial", 13, true); // Crea un font Arial in grassetto

  cp5 = new ControlP5(this);

  // Definisci le dimensioni e la posizione del rettangolo di confine
  rectWidth = 400;
  rectHeight = 400;
  rectX = width - rectWidth - 50; 
  rectY = (height - rectHeight) / 2;

  // Aggiungi i knob 
  cp5.addKnob("knob1", 1, 5, 1, 50, 50, 120); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob1").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob1").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob1").setColorActive(color(200)); // Colore quando è attiva

  cp5.addKnob("knob2", 0, 1, 0, 250, 50, 120); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob2").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob2").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob2").setColorActive(color(200)); // Colore quando è attiva
  
  cp5.addKnob("knob3", 0, 1, 0,150, 170, 120); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob3").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob3").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob3").setColorActive(color(200)); // Colore quando è attiva
  
  
 


  // Aggiungi la dropdown 
  dropdown = cp5.addDropdownList("menu")
                 .setPosition(50, 350) // Posiziona la dropdown 
                 .setSize(350, 350) //  grandezza della dropdown
                 .setItemHeight(40)
                 .setBarHeight(40);

  // Aggiungi le opzioni al menu
  dropdown.addItem("Sinusoid", 1);
  dropdown.addItem("Impulse", 2);
  dropdown.addItem("Sawtooth", 3);
  dropdown.addItem("Square", 4);

  // Inizializza la posizione del pallino all'interno del rettangolo di confine
  ellipseX = rectX + rectWidth / 2;
  ellipseY = rectY + rectHeight / 2;

  // Inizializza la libreria OSC e la porta di ascolto
  oscP5 = new OscP5(this, 8000);
}

void draw() {
  background(255); // Sfondo 

  // Disegna il rettangolo
  noFill();
  stroke(0);
  rect(rectX, rectY, rectWidth, rectHeight);

  // Disegna il testo "Knob"
  fill(0); // Colore del testo 0 = nero 
  textFont(f, 20); // Specifica il font da utilizzare
  text("Knob", 20, 40); // Disegna il knob

  // Disegna il pallino 
  ellipse(ellipseX, ellipseY, diameter, diameter);
}

// Funzione che gestisce gli eventi generati dagli elementi di interfaccia utente
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("Control event from: " + theEvent.getController().getName());
    println(", Value: " + int(theEvent.getController().getValue()));
  }
}

// Funzione per ricevere i valori tramite OSC
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/handMovement") == true) { // Controlla il messaggio
    if (msg.checkTypetag("ii")) { // Controlla che il messaggio contenga due interi
      int valueX = msg.get(0).intValue(); // Estrae il primo valore (asse X)
      int valueY = msg.get(1).intValue(); // Estrae il secondo valore (asse Y)

      // Mappa i valori X e Y sui limiti del canvas e li limita al rettangolo di confine
      ellipseX = constrain(int(map(valueX, 0, 126, rectX, rectX + rectWidth)), rectX + diameter / 2, rectX + rectWidth - diameter / 2);
      ellipseY = constrain(int(map(valueY, 0, 126, rectY, rectY + rectHeight)), rectY + diameter / 2, rectY + rectHeight - diameter / 2);
    }
  }
}
