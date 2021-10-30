# Entrega 2
En este readme se explican las decisiones que se tomaron, los puntos asumidos y el uso del comando para exportar los `appointmets` en un archivo `.html`.

## Asunsiones
Se asume que el horario de atención es de 8:00 a 20:30, y que los turnos son de 30 minutos, siendo el último turno a las 20:00 hs, se pueden crear turnos fuera de este rango de tiempo, pero no serán mostrados en la grilla.

Para el manejo de horarios no exactos, por ejemplo a las 12:24, se tomará como turno para las 12:00, esto puede provocar que se exporten varios turnos para el mismo horario y profesional. pero se asume que no pasará.

## Resolución
Se utiliza ERB para el templating de la vista, y se crearon dos metodos nuevos en el helper de storage, par leer el template y exportarlo a al archivo `export.html`.

Se agregó el comando export a turnos, el cual recibe como argumento una fecha con el formato `YYYY-MM-DD` y opcionalmente dos opciones --professional, que solo exportara los appointmets de dicho profesional, y --week, que exportará todos los turnos de la semana, iniciando por el dómgino, del día que se pase como argumento.

El template se encuentra en `lib/polycon/templates/export.html.erb`, allí se arma una calendario semanal, iniciando por el domingo del día pasado como argumento al comando y se agregaran cada appointment al día y hora que corresponda. El estilo css del calendario fue extraido del ejemplo en [codepen](https://codepen.io/fbede4/pen/OJVbmVK) y se le realizaron algunas adaptaciones.
