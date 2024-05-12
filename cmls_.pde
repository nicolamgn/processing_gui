import controlP5.*;
import java.util.HashMap; // Importa la classe HashMap

ControlP5 cp5;
DropdownList dropdown;
ControlP5 cP5; // Dichiarazione dell'oggetto controlP5
PFont f;

void setup() {
  size(800, 600); // Imposta la dimensione della finestra
  smooth();
  f = createFont("Arial", 13, true); // Crea un font Arial in grassetto

  cp5 = new ControlP5(this);
  cP5 = new ControlP5(this);

  // Aggiungi i knob 
  cP5.addKnob("knob1", 1, 5, 1, 50, 50, 150); //( minimo valore, max , default , posizione x , posizione y , diametro)
  
  // Imposta lo stile della prima manopola 
  cP5.getController("knob1").setColorForeground(color(30,30,30)); // Colore del bordo
  cP5.getController("knob1").setColorBackground(color(50)); // Colore di sfondo
  cP5.getController("knob1").setColorActive(color(150)); // Colore quando è attiva

  // Aggiungi un secondo knob accanto al primo
  cP5.addKnob("knob2", 0, 1, 1, 250, 50, 150); //( minimo valore, max , default , posizione x , posizione y , diametro)
  
  // Imposta lo stile della seconda manopola 
  cP5.getController("knob2").setColorForeground(color(30,30,30)); // Colore del bordo
  cP5.getController("knob2").setColorBackground(color(50)); // Colore di sfondo
  cP5.getController("knob2").setColorActive(color(200)); // Colore quando è attiva

  // Aggiungi la dropdown sotto i knob
  dropdown = cp5.addDropdownList("menu")
                 .setPosition(50, 300) // Posiziona la dropdown 
                 .setSize(350, 350) //  grandezza della dropdown
                 .setItemHeight(40)
                 .setBarHeight(40);

  // Aggiungi le opzioni al menu
  dropdown.addItem("Sinusoid", 1);
  dropdown.addItem("Impulse", 2);
  dropdown.addItem("Sawtooth", 3);
  dropdown.addItem("Square", 4);

  // Imposta un'azione quando viene selezionata un'opzione
  dropdown.onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      int selectedIndex = (int) event.getController().getValue();
      // Itera attraverso tutte le opzioni del menu
      for (Object itemObj : dropdown.getItems()) {
        // Converti l'oggetto in HashMap
        HashMap<String, Object> item = (HashMap<String, Object>) itemObj;
        // Controlla se l'opzione non è selezionata
        if ((int) item.get("value") != selectedIndex) {
          // Nascondi l'opzione
          item.put("visible", false);
        } else {
          // Mostra l'opzione selezionata
          item.put("visible", true);
          // Stampa il testo dell'opzione selezionata
          println("Opzione selezionata: " + item.get("name"));
        }
      }
    }
  });
}

void draw() {
  background(255); // Sfondo 

  // Disegna il testo "Knob"
  fill(1); // Colore del testo: nero
  textFont(f, 20); // Specifica il font da utilizzare
  text("Knob", 20, 40); // Disegna il testo sopra i knob
}

// Funzione che gestisce gli eventi generati dagli elementi di interfaccia utente
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("Control event from: " + theEvent.getController().getName());
    println(", Value: " + int(theEvent.getController().getValue()));
  }
}
