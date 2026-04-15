# Semana 2 - Solución del caso "estudiantes"

Análisis del caso
La institución maneja la información académica en hojas de cálculo, lo que genera problemas como datos repetidos, errores en notas, dificultad para consultar información y riesgo de pérdida. Esto sucede porque los archivos planos no son adecuados para grandes volúmenes de datos ni para el trabajo simultáneo. Por eso, es mejor implementar un SGBD.

## Tarea A. Problemas y solución

- **Duplicidad de estudiantes:** se repite la información.  
  **Solución:** usar una sola tabla con identificador único.  

- **Notas inconsistentes:** hay diferencias entre archivos.  
  **Solución:** aplicar reglas que garanticen datos correctos.  

- **Dificultad de consulta:** buscar información es lento.  
  **Solución:** usar consultas SQL para acceder rápido a los datos.  

- **Pérdida de datos:** riesgo por eliminación o errores.  
  **Solución:** copias de seguridad y control de acceso.  

## Tarea B. Discusión

Se debe migrar a un SGBD cuando aumentan los datos, hay errores, duplicidad o dificultad para manejar la información.

El más adecuado es el SGBD relacional, porque organiza los datos en tablas relacionadas y garantiza orden y precisión.
