import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
DropdownList dropdown;
PFont f;

OscP5 oscP5;
NetAddress superColliderAddr; // Indirizzo di rete di SuperCollider
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
  cp5.addKnob("knob1", 1, 5, 1, 50, 50, 120).setDragDirection(Knob.VERTICAL).setNumberOfTickMarks(4).snapToTickMarks(true).setTickMarkLength(4); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob1").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob1").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob1").setColorActive(color(200)); // Colore quando è attiva

  cp5.addKnob("knob2", 0.0, 1.0, 0.5, 250, 50, 120).setDragDirection(Knob.VERTICAL); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob2").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob2").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob2").setColorActive(color(200)); // Colore quando è attiva
  
  cp5.addKnob("knob3", 0.0, 1.0, 0.5,150, 170, 120).setDragDirection(Knob.VERTICAL); //( minimo valore, max , default , posizione x , posizione y , diametro)
  cp5.getController("knob3").setColorForeground(color(30,30,30)); // Colore del bordo
  cp5.getController("knob3").setColorBackground(color(50)); // Colore di sfondo
  cp5.getController("knob3").setColorActive(color(200)); // Colore quando è attiva
  
  // Inizializza la connessione OSC con SuperCollider
  oscP5 = new OscP5(this, 8000);
  superColliderAddr = new NetAddress("127.0.0.1", 57120); // Indirizzo di SuperCollider

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

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("Control event from: " + theEvent.getController().getName());
    println(", Value: " + int(theEvent.getController().getValue()*1000)/1000.0);
    
    // Invia i valori dei knob tramite OSC a SuperCollider
    OscMessage msg = new OscMessage("/interface"); // Cambia il nome del messaggio OSC

    // Gestisci gli eventi della dropdown
    if (theEvent.getController().getName().equals("menu")) {
      msg.add("dropdown"); // Aggiungi un identificatore per la dropdown
      msg.add(int(theEvent.getController().getValue())); // Aggiungi il valore selezionato dalla dropdown
    }
    // Gestisci gli eventi dei knob
    else {
      // Valore intero per knob1
      if (theEvent.getController().getName().equals("knob1")) {
        msg.add("knob1");
        msg.add(int(theEvent.getController().getValue()));
      }
      // Valori float per knob2 e knob3
      else if (theEvent.getController().getName().equals("knob2") || theEvent.getController().getName().equals("knob3")) {
        msg.add(theEvent.getController().getName());
        msg.add(mapFloat(theEvent.getController().getValue(), 0, 1, 0, 1)); // Mappa il valore da 0-1 a 0-1
      }
    }
    
    oscP5.send(msg, superColliderAddr);
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

// Funzione per mappare un float tra due range
float mapFloat(float value, float start1, float stop1, float start2, float stop2) {
  return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
}
