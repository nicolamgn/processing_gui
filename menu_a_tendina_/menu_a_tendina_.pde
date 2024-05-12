import controlP5.*;
import java.util.HashMap; // Importa la classe HashMap

ControlP5 cp5;
DropdownList dropdown;

void setup() {
  size(500, 400);
  cp5 = new ControlP5(this);

  dropdown = cp5.addDropdownList("menu")
                 .setPosition(50, 50)
                 .setSize(300, 300)
                 .setItemHeight(30)
                 .setBarHeight(30);

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
  background(255);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup() && theEvent.name().equals("menu")) {
    // Aggiorna lo stato visibile delle opzioni
    for (Object itemObj : dropdown.getItems()) {
      // Converti l'oggetto in HashMap
      HashMap<String, Object> item = (HashMap<String, Object>) itemObj;
      // Controlla se l'opzione non è selezionata
      if ((int) item.get("value") != (int) theEvent.getValue()) {
        // Nascondi l'opzione
        item.put("visible", false);
      } else {
        // Mostra l'opzione selezionata
        item.put("visible", true);
      }
    }
  }
}
