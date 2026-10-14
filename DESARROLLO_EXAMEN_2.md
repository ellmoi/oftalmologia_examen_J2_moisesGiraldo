# Examen 2. Seguimiento y control de presión intraocular

## 1. Planteamiento del problema

El área de glaucoma requiere hacer seguimiento de las mediciones de presión intraocular de los pacientes. Cada paciente puede registrar múltiples mediciones en diferentes consultas, y cada medición debe distinguirse por el ojo evaluado: derecho (`OD`) o izquierdo (`OI`).

La institución necesita:

- identificar valores elevados;
- calcular indicadores estadísticos;
- consultar el historial clínico por paciente y por ojo;
- disponer de consultas reutilizables para análisis comparativo.

> El umbral de `21 mmHg` se usa como criterio académico de filtrado y no representa diagnóstico médico automático.

## 2. Resultados de aprendizaje

Se desarrollan habilidades para:

- relacionar mediciones con pacientes y consultas;
- aplicar funciones agregadas;
- usar filtros y subconsultas;
- construir vistas y funciones reutilizables.

## 3. Desarrollo de las actividades evaluativas

### Actividad 1. Análisis del modelo relacional

La tabla principal del ejercicio es `intraocular_pressures`. Esta tabla está relacionada con `medical_visits`, y a su vez una visita pertenece a una `clinical_history`, la cual está asociada a un `patient`.

```sql
SELECT p.id AS patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS paciente,
       ch.id AS historia_clinica,
       mv.id AS visita_id,
       ip.id AS medicion_id,
       ip.eye,
       ip.pressure,
       ip.measured_at
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
ORDER BY p.id, ip.measured_at;
```

Se concluye que cada medición conserva la referencia al ojo y a la consulta porque permite reconstruir la evolución del paciente con trazabilidad clínica y evitar mezclar valores de `OD` y `OI` en la misma historia.

### Actividad 2. Consultas básicas

#### 2.1. Listar mediciones mostrando valor, fecha y unidad

```sql
SELECT ip.id,
       ip.pressure AS valor_mm_hg,
       ip.measured_at AS fecha_medicion,
       'mmHg' AS unidad
FROM intraocular_pressures ip
ORDER BY ip.measured_at DESC;
```

#### 2.2. Medidas superiores a 21 mmHg

```sql
SELECT ip.id,
       ip.eye,
       ip.pressure,
       ip.measured_at
FROM intraocular_pressures ip
WHERE ip.pressure > 21
ORDER BY ip.pressure DESC;
```

#### 2.3. Mediciones ordenadas de mayor a menor presión

```sql
SELECT ip.id,
       ip.eye,
       ip.pressure,
       ip.measured_at
FROM intraocular_pressures ip
ORDER BY ip.pressure DESC, ip.measured_at DESC;
```

### Actividad 3. Consultas relacionales

#### 3.1. Nombre del paciente, fecha de consulta, ojo y presión registrada

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS paciente,
       mv.visit_date AS fecha_consulta,
       ip.eye AS ojo,
       ip.pressure AS presion_mm_hg
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
ORDER BY mv.visit_date, p.last_name;
```

#### 3.2. Presión intraocular promedio por paciente y ojo con dos decimales

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS paciente,
       ip.eye AS ojo,
       ROUND(AVG(ip.pressure), 2) AS promedio_presion
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
GROUP BY p.id, p.first_name, p.last_name, ip.eye
ORDER BY paciente, ojo;
```

### Actividad 4. Consultas avanzadas

#### 4.1. Pacientes con al menos dos mediciones superiores a 21 mmHg

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS paciente,
       COUNT(ip.id) AS mediciones_altas
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
WHERE ip.pressure > 21
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(ip.id) >= 2
ORDER BY mediciones_altas DESC, paciente;
```

#### 4.2. Mediciones que superan el promedio general

```sql
SELECT CONCAT(p.first_name, ' ', p.last_name) AS paciente,
       ip.eye AS ojo,
       ip.pressure,
       ip.measured_at
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
WHERE ip.pressure > (
    SELECT AVG(pressure)
    FROM intraocular_pressures
)
ORDER BY ip.pressure DESC;
```

### Actividad 5. Creación de la vista `vw_patient_pressure_statistics`

```sql
CREATE OR REPLACE VIEW vw_patient_pressure_statistics AS
SELECT p.id AS patient_id,
       CONCAT(p.first_name, ' ', p.last_name) AS full_name,
       ip.eye AS eye_code,
       MIN(ip.pressure) AS min_pressure,
       MAX(ip.pressure) AS max_pressure,
       ROUND(AVG(ip.pressure), 2) AS avg_pressure,
       COUNT(ip.id) AS total_measurements
FROM intraocular_pressures ip
JOIN medical_visits mv ON mv.id = ip.visit_id
JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
JOIN patients p ON p.id = ch.patient_id
GROUP BY p.id, p.first_name, p.last_name, ip.eye;
```

Consulta de validación:

```sql
SELECT *
FROM vw_patient_pressure_statistics
ORDER BY patient_id, eye_code;
```

### Actividad 6. Función almacenada `fn_pressure_difference`

```sql
DELIMITER $$
CREATE FUNCTION fn_pressure_difference(
    first_pressure DECIMAL(5,2),
    second_pressure DECIMAL(5,2)
)
RETURNS DECIMAL(5,2)
BEGIN
    IF first_pressure IS NULL OR second_pressure IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN second_pressure - first_pressure;
END$$
DELIMITER ;
```

Demostración con dos casos:

```sql
SELECT fn_pressure_difference(18.50, 24.20) AS aumento;
SELECT fn_pressure_difference(24.20, 18.50) AS disminucion;
```

Resultados esperados:

- aumento: `5.70`
- disminucion: `-5.70`

## 4. Evidencia final

El repositorio mantiene la organización requerida para diferenciar:

- la base del taller;
- la guía de apoyo;
- el desarrollo del examen 2 de presión intraocular.

La referencia gráfica del modelo se encuentra en la imagen principal del proyecto y se enlaza desde el README principal.
