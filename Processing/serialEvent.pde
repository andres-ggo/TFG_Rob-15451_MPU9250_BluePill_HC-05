/* Andres Gomez (2021), a partir del codigo de Juan Palomares (2020) */

// Esta funcion procesa la informacion que le llega por el bus serie. Se activa cuando llega algo.

void serialEvent (Serial p) {

  try {
    String data = p.readStringUntil('\n'); // Se leera el string que llegue hasta el salto de linea.
    if (data != null) { 
      data = data.substring(0, data.length()-1);  
      String[] dataList = split(data, ',');  // Corta el bus de caracteres por cada coma y asigna cada division a una variable "String".
      
      // Accedemos a cada uno de los parametros enviados.
      
      roll1 = dataList[0]; 
      pitch1 = dataList[1];
      yaw1 = dataList[2];
      pot1 = dataList[3];
      pot2 = dataList[4];
      detumbling = dataList[5];
      
      // Convertimos los datos recibidos en valores numericos.
      
      Roll1 = Float.parseFloat(roll1);
      Pitch1 = Float.parseFloat(pitch1);
      Yaw1 = Float.parseFloat(yaw1);
      Pot1 = Float.parseFloat(pot1);
      Pot2 = Float.parseFloat(pot2);
      Detumbling = Float.parseFloat(detumbling); //La variable booleana, por comodidad, se usa a traves de un "float", en el que 0 = false y 1 = true.
    }
  }
  catch(RuntimeException e) {
  }
}
