# TTPS opción ruby

Para la última entrega, se creó una versión web del polyconsultorio utilizando Ruby On Rails.

Se separó por un lado las entregas pasadas (en el directorio `cmd`) y por otro lado la aplicación rails (en el directorio `polyconsultorio`).


### Decisiones de diseño

Para la verificación de los permisos se utilizó la gema [ActionPolicy](https://github.com/palkan/action_policy), que permite definir reglas de acceso a recursos.

Los ABM básicos para Professional y Appointment se realizaron utilizando `rails generate scaffold`, luego se adaptaron los modelos para asociar los appointments a los profesionales.

No se implementó un reschedule de appointment, porque se consideró que con alcanzaba con el editar un appointment, dónde se permite editar la fecha de los mismos, validando que el professional no tenga otro appointment en esa fecha y hora.

Para la visual se utilizó el framework CSS [Bulma](https://bulma.io/), pero este apartado quedó incompleto.

