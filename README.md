# 400 bps High-Quality Speech Coding Algorithm

| ![Javier de la Rica](/Images/image-javier.jpg) | ![Logo](/Images/upc_etsetb.jpg) |
| :---: | :---: |
| Javier de la Rica | delaricajavier@gmail.com |

## RESUMEN

En el presente artículo se describe un sistema de codificación de voz a baja velocidad de bit. Ésta permite una 
alta calidad, importante en comunicaciones con voz en canales con ancho de banda limitado. Este proyecto se ha 
dividido en dos partes bien diferenciadas; la primera será la extracción de características de un audio de voz 
para generar el codificador, y la segunda parte será la que reconstruya la señal a partir de las características 
extraídas en la primera parte, intentando que en la salida se obtenga una señal parecida a la señal de entrada.

## 1. INTRODUCCIÓN

El objetivo de los sistemas de codificación a baja velocidad de bit es el de poder codificar a alta calidad para canales con ancho de banda limitados. La introducción de la transmisión con fibra óptica permite una elevada capacidad de comunicación, y el ancho de banda limitado parece dejar de ser un problema. Aun así, es necesaria una codificación de voz con baja velocidad de bit en el ancho de banda para comunicaciones acústicas acuáticas, comunicación por satélite, y para distintas otras áreas.
Las codificaciones a una baja velocidad de bit se pueden agrupar en dos categorías: Por un lado, una codificación basada en algoritmos de predicción lineal como SELP (Sinusoidal Excitation Linear Prediction) y MELP, mientras que por otro lado existe la compresión de voz harmónica, incluyendo STC (Sinusoidal Transform Coding).

En concreto, en éste proyecto se hace un codificador de voz a baja velocidad de bit basado en el proyecto representado en el paper 400bps High-Quality Speech Coding Algorithm, centrado en la predicción lineal LPC en concreto. 

Se hará un estudio de la señal de voz original, extrayendo las características que más útiles sean a la hora de querer reconstruir la señal en el decodificador, como el periodo de pitch, el voice strength, los coeficientes LSF a partir de los LPC y la ganancia de la señal, para posteriormente generar una excitación mixta entre un pulso unitario y ruido, y generar una señal lo más parecida a la original.

## 2. CODIFICADOR

Como se ha mencionado anteriormente, para la implementación del codificador se ha utilizado una señal de voz con una frecuencia de muestreo de 8kHz. El objetivo de éste es extraer características de la señal de voz para posteriormente poder reconstruir la señal original mediante el decodificador. En concreto, como se puede observar en la Figura 1, se hace una estimación del pitch de la señal original, un estudio de los coeficientes de la fuerza de la voz, la extracción de los coeficientes LSF y el cálculo de la ganancia.

### 2.1. Cálculo del pitch

Para el estudio del pitch de la señal original, se hace uso de la autocorrelación. En este caso, por definición, el pitch es el periodo en el que se maximiza la autocorrelación normalizada. En concreto se hace un estudio de la señal dividiéndola en tramas de 180 muestras cada una. Como ejemplo, se ha hecho uso de una señal de voz masculina y duración un segundo, así pues se obtiene un total de 64 tramas de 180 muestras. 

A continuación, para cada trama de 180 muestras se calcula la autocorrelación,

r(τ)=cτ(0,τ)/√(cτ(0,0)cτ(τ,τ)) (1)


Para dicho cálculo, se centra una ventana de 360 muestras en la última muestra de la trama presente y la primera de la siguiente.
Finalmente, se obtiene un valor de periodo de pitch para cada una de las tramas en las que se ha dividido la señal original. En concreto, para la señal utilizada se obtienen un total de 64 valores de periodo de pitch.

### 2.2. Análisis de voz

En este apartado, se estudia la fuerza de la voz de la señal. En concreto, se filtra la señal con cuatro filtros de Butterworth de orden 6 diseñados previamente. Para las bandas de 500Hz-1kHz, 1kHz-2kHz y 2kHz-3kHz se hace uso de un filtro Paso Banda, mientras que para la banda de 3kHz-4kHz se hace uso de un Paso Alto. A continuación se puede observar la forma del filtro de Butterworth para el caso de la banda de 500Hz-1kHz.
	
Para cada señal filtrada por dicho filtro, se vuelve a calcular el periodo de pitch de la misma manera que en el apartado anterior, obteniendo así un total de 5 vectores de 64 muestras, o en su defecto, del total de tramas de la señal utilizada. De éstos vectores, para cada trama se extrae el valor máximo en el que se encuentra la correlación en el punto del periodo de pitch, correspondientes a la fuerza de la voz, voice strength.

### 2.3. Análisis de predicción lineal

En este apartado se crea un predictor lineal de orden 10, para el que se usa la misma señal de 8kHz, y se filtra con una ventana de Hamming de 200 muestras, lo que corresponde a 25ms.

Inicialmente, una vez la señal se haya filtrado, se calculan los coeficientes de predicción lineal LPC de cada trama, utilizando el algoritmo de recursión de Levinson-Durbin. A continuación se aplica una expansión Paso Banda de 0.994. Seguidamente, éstos coeficientes expandidos se filtran, obteniendo finalmente los coeficientes residuales.

Éstos coeficientes también se enventanan con 320 muestras para asegurar la determinación del periodo de pitch, y la ventana queda centrada en la última muestra de la trama actual y la primera de la siguiente.

### 2.4. Cálculo de la ganancia

Para calcular la ganancia se hace uso de los coeficientes residuales calculados previamente. Se consideran 200 muestras por cada subtrama, y de esta manera se obtienen finalmente los parámetros de la energía.

## 3. DECODIFICADOR

En este apartado se hace uso de las características extraídas en el codificador para poder reconstruir una señal de salida lo más parecida a la señal original. 

Para ello se genera una excitación mixta, correspondiente a la suma de una excitación de pulso y un ruido. En concreto, la excitación se genera siguiendo la expresión que se puede observar a continuación, considerando que la señal e[n] es un pulso unitario.

Ésta excitación se filtra por 5 distintos filtros Paso banda FIR de 33 muestras cada uno, para posteriormente multiplicarlos cada uno con el correspondiente voice strength BPVC, generando así la señal e1 que se puede observar en la Figura 5. 
Paralelamente, se genera un ruido aleatorio uniforme con un valor RMS de 1000 en un rango entre -1732 y 1732. Éste ruido se filtra también por los mismos filtros que la señal e[n], y se multiplica la salida de cada uno por el valor 1-BPVC correspondiente.

Para hacer más simple la implementación, como se puede observar en la Figura 5, se ha comprimido el banco de filtros en un único sumatorio de todos los filtros, y todos los BPVC, para así tener únicamente dos bloques hp y hn, correspondientes a la excitación y el ruido.

Finalmente, se suman las salidas e1 y e2 para generar la excitación mixta, que posteriormente se multiplica por la ganancia calculada en el codificador, y se filtra utilizando los valores de los coeficientes LSF para generar la señal de salida, Xout.

## 4. RESULTADOS 

Para hacer la ejecución del sistema un poco más simple, se ha generado una sencilla interfaz gráfica como se puede ver en la siguiente figura, en la que se permite codificar y decodificar la señal mediante los botones correspondientes, a la vez que se pueden escuchar ambas señales para poder comparar la calidad del sistema.

### 4.1. Escala MOS

Para hacer una evaluación del sistema, se ha considerado hacer un estudio subjetivo de la señal reconstruida generando una escala MOS, con la opinión de un total de 66 personas. En concreto, se ha obtenido una calificación media del 1 al 5 de 2.89.

## 5. CONCLUSIONES

En éste proyecto se ha realizado un sistema de codificación y decodificación de una señal de voz muestreada a 8kHz basándose en el paper 400bps High-Quality Speech Coding Algorithm. En concreto, el sistema se ha desarrollado en Matlab, observando y estudiando los resultados obtenidos en cada punto del proyecto para asegurar un correcto funcionamiento del sistema, como se ha mencionado anteriormente. 

Primero se ha desarrollado el sistema de codificación de la señal de voz, extrayendo las características de la señal como el periodo de pitch, los valores del voice strength BPVC, los coeficientes LSF y la ganancia de la señal.

Una vez se ha comprobado el correcto funcionamiento del codificador, se ha desarrollado el decodificador, utilizando las características extraídas en la primera fase, para reconstruir la señal generando un pulso de excitación y un ruido para obtener una excitación mixta y poder filtrarla y multiplicarla por la ganancia obtenida anteriormente.

Finalmente, se ha hecho un estudio de los resultados obtenidos. Por una parte, una comparación entre la señal de entrada y la de salida, viendo bastantes similitudes y por tanto considerando como correcta la señal de salida. Además, también se ha comprobado, escuchando ambos audios (entrada y salida) el correcto funcionamiento del sistema. 
Paralelamente también se hizo un estudio de una escala MOS para poder evaluar el sistema de una forma subjetiva con una amplia participación, obteniendo un valor medio de 2.89.

Como resultado se puede observar que el sistema funciona correctamente, teniendo en cuenta que se podría mejorar de diversas maneras. Por un lado, se puede hacer un cálculo más exhaustivo del periodo de pitch, calculando el pitch fraccional en el codificador, y generando una mejor excitación en el decodificador, por ejemplo, desarrollando una excitación con memoria que no solapara las muestras entre los tramos de la señal.

## 6. REFERENCIAS


[1] Xiaofeng Ma, Ye Li, Jingsai Jiang, Peng Zhang, Yanhong Fan, Qiuyun Hao, 400bps High-Quality Speech Coding Algorithm, Jinan, China, 2016.

[2] Wai C. Chi, Speech Coding Algrithms, San Jose, California, 2003.

[3] Fréderic Bimbot, Jean-François Bonastre, Corinne Fredouille, Guillaume Gravier, Ivan Magrin-Chagnolleau, Sylvain Meignier, Teva Merlin, Javier Ortega-García, Dijana Petrovska-Delacrétaz, Douglas A. Reynolds, Tutorial on Text-ndependent Speaker Verification.
