# Taller resuelto: historias clínicas de Oftalmología y Glaucoma

**[Abrir el modelo completo y ampliar la imagen](modelo_completo.png)**

**Estudiante:** Moisés Giraldo Alzate.  
**Motor probado:** MySQL Community Server 8.0.46.  



## Índice

- [Formulación del problema](#punto-1)
- [2. Situación problema](#punto-2)
- [3. Problema central](#punto-3)
- [4. Pregunta problema](#punto-4)
- [5. Objetivo general](#punto-5)
- [6. Objetivos específicos](#punto-6)
- [7. Alcance del proyecto](#punto-7)
- [8. Alcance funcional de la base de datos](#punto-8)
- [9. Entidades preliminares](#punto-9)
- [10. Modelo conceptual esperado](#punto-10)
- [11. Modelo lógico esperado](#punto-11)
- [12. Diagrama Entidad-Relación](#punto-12)
- [13. Proceso de normalización](#punto-13)
- [14. Datos no normalizados](#punto-14)
- [15. Primera Forma Normal —1FN](#punto-15)
- [16. Segunda Forma Normal —2FN](#punto-16)
- [17. Tercera Forma Normal —3FN](#punto-17)
- [18. Forma Normal de Boyce-Codd —BCNF](#punto-18)
- [19. Cuarta Forma Normal —4FN](#punto-19)
- [20. Ejemplo de aplicación de 4FN en el proyecto](#punto-20)
- [21. Implementación física en MySQL](#punto-21)
- [22. Restricciones](#punto-22)
- [23. Integridad referencial](#punto-23)
- [24. Datos de prueba](#punto-24)
- [25. Consultas básicas](#punto-25)
- [26. Consultas intermedias](#punto-26)
- [27. Consultas avanzadas](#punto-27)
- [28. Subconsultas](#punto-28)
- [29. Funciones agregadas](#punto-29)
- [30. GROUP BY](#punto-30)
- [31. HAVING](#punto-31)
- [32. Procedimientos almacenados](#punto-32)
- [33. Funciones almacenadas](#punto-33)
- [34. Triggers](#punto-34)
- [35. Otros triggers posibles](#punto-35)
- [36. Eventos](#punto-36)
- [37. Vistas](#punto-37)
- [38. Posibles consultas requeridas](#punto-38)
- [39. Preguntas que la base de datos deberá responder](#punto-39)
- [40. Producto final esperado](#punto-40)
- [42. Pregunta orientadora final](#punto-42)
- [Banco de 250 ejercicios MySQL](#banco-original)
- [PARTE I — 50 EJERCICIOS DE CONSULTAS SQL](#parte-1)
- [PARTE II — 50 EJERCICIOS DE SUBCONSULTAS](#parte-2)
- [PARTE III — 50 EJERCICIOS DE PROCEDIMIENTOS ALMACENADOS](#parte-3)
- [PARTE IV — 50 EJERCICIOS DE TRIGGERS](#parte-4)
- [PARTE V — 50 EJERCICIOS DE FUNCIONES ALMACENADAS](#parte-5)

<a id="punto-1"></a>

  # Formulación del problema

## Título

**Diseño e implementación de una base de datos relacional normalizada para la gestión de historias clínicas de pacientes del área de oftalmología y glaucoma.**

## Problema

El área de oftalmología y glaucoma maneja información clínica que posee múltiples relaciones y una alta dependencia del histórico del paciente. Un diseño de datos inadecuado puede generar redundancia, inconsistencias, pérdida de trazabilidad y dificultades para consultar la evolución clínica.

Por esta razón, se requiere construir una base de datos relacional en MySQL que permita organizar correctamente pacientes, historias clínicas, consultas, diagnósticos, antecedentes, exámenes oftalmológicos, tratamientos y controles de glaucoma.

El diseño deberá aplicar técnicas de modelado conceptual, lógico y físico, así como un proceso de normalización hasta la Cuarta Forma Normal. Posteriormente se deberán implementar mecanismos de consulta y procesamiento mediante SQL, incluyendo consultas básicas, intermedias y avanzadas, subconsultas, funciones agregadas, vistas, procedimientos almacenados, funciones, triggers y eventos.

El resultado deberá ser una base de datos íntegra, consistente, escalable y capaz de responder consultas relacionadas con el seguimiento histórico y clínico de los pacientes.

Cada paciente puede asistir a múltiples consultas a lo largo del tiempo y, durante cada atención, pueden generarse diferentes tipos de datos clínicos.

Por ejemplo:

```
Paciente
   |
   +-- Datos personales
   |
   +-- Historia clínica
   |
   +-- Antecedentes
   |
   +-- Consultas
   |      |
   |      +-- Diagnósticos
   |      +-- Examen oftalmológico
   |      +-- Presión intraocular
   |      +-- Tratamientos
   |
   +-- Estudios especializados
          |
          +-- OCT
          +-- Campo visual
          +-- Paquimetría
          +-- Gonioscopía
```

En pacientes con glaucoma, la necesidad de conservar información histórica es aún mayor, debido a que variables como la presión intraocular, el estado del nervio óptico, la paquimetría, los resultados de OCT y los campos visuales deben compararse entre diferentes controles.

Si esta información se almacena de manera desestructurada, pueden aparecer problemas como:

- duplicidad de datos;
- inconsistencias entre registros;
- redundancia;
- dificultad para establecer relaciones entre consultas y resultados;
- pérdida de trazabilidad;
- dificultad para consultar la evolución histórica;
- dificultad para obtener indicadores;
- problemas para generar reportes;
- almacenamiento de información repetida;
- dependencia excesiva de campos de texto libre.

Por esta razón se requiere diseñar una base de datos relacional que permita representar correctamente la información clínica y mantener su integridad.

<a id="punto-2"></a>

# 2. Situación problema

La información de una historia clínica oftalmológica está compuesta por múltiples entidades relacionadas entre sí.

Por ejemplo, un paciente puede presentar:

```
1 paciente
      |
      +-- 1 historia clínica
      |
      +-- N consultas
      |
      +-- N diagnósticos
      |
      +-- N tratamientos
      |
      +-- N mediciones de presión intraocular
      |
      +-- N estudios OCT
      |
      +-- N campos visuales
```

Además, muchas variables deben manejarse separadamente para:

```
OD = ojo derecho
OI = ojo izquierdo
```

Un diseño inadecuado podría conducir a estructuras como:

```
paciente
--------------------------------------------------
id
nombre
diagnostico1
diagnostico2
diagnostico3
medicamento1
medicamento2
presion_od_1
presion_oi_1
presion_od_2
presion_oi_2
oct1
oct2
campo_visual1
campo_visual2
```

Este diseño presenta importantes problemas de normalización.

Entre ellos:

- grupos repetitivos;
- múltiples valores dentro de una misma entidad;
- dificultad para agregar nuevos registros;
- redundancia;
- anomalías de inserción;
- anomalías de actualización;
- anomalías de eliminación.

Por esta razón será necesario aplicar un proceso formal de normalización.

<a id="punto-3"></a>

# 3. Problema central

Se requiere diseñar una base de datos relacional en MySQL que permita gestionar de forma estructurada la información correspondiente a historias clínicas de pacientes atendidos en el área de oftalmología y glaucoma.

El diseño deberá permitir representar adecuadamente las relaciones existentes entre pacientes, historias clínicas, consultas, diagnósticos, antecedentes, medicamentos, tratamientos, estudios oftalmológicos y controles de glaucoma.

La estructura deberá minimizar redundancias y anomalías mediante un proceso de normalización hasta alcanzar la **Cuarta Forma Normal —4FN—**.

Además, la base de datos deberá permitir realizar operaciones de consulta y procesamiento de información utilizando SQL en diferentes niveles de complejidad.

<a id="punto-4"></a>

# 4. Pregunta problema

**¿Cómo diseñar e implementar una base de datos relacional en MySQL, normalizada hasta la Cuarta Forma Normal, que permita almacenar, relacionar, consultar y procesar eficientemente la información de las historias clínicas de pacientes del área de oftalmología y glaucoma?**

<a id="punto-5"></a>

# 5. Objetivo general

Diseñar e implementar una base de datos relacional en MySQL para la gestión de historias clínicas del área de oftalmología y glaucoma, aplicando técnicas de modelado de datos, normalización hasta 4FN, integridad referencial y consultas SQL de diferentes niveles de complejidad.

<a id="punto-6"></a>

# 6. Objetivos específicos

1. Identificar las entidades, atributos y relaciones necesarias para representar la información clínica de pacientes de oftalmología y glaucoma.
2. Construir el modelo conceptual de la base de datos.
3. Diseñar el modelo lógico relacional.
4. Elaborar el Diagrama Entidad-Relación —DER—.
5. Aplicar el proceso de normalización hasta alcanzar la Cuarta Forma Normal.
6. Implementar el modelo físico utilizando MySQL.
7. Definir claves primarias y foráneas.
8. Implementar restricciones de integridad utilizando:

```
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
CHECK
DEFAULT
```

1. Insertar datos de prueba coherentes con el dominio del problema.
2. Construir consultas SQL básicas.
3. Construir consultas SQL de nivel intermedio.
4. Construir consultas SQL avanzadas.
5. Implementar subconsultas.
6. Aplicar funciones agregadas.
7. Utilizar agrupamientos con `GROUP BY` y filtros con `HAVING`.
8. Implementar vistas para facilitar consultas recurrentes.
9. Desarrollar procedimientos almacenados.
10. Implementar funciones almacenadas.
11. Crear disparadores —triggers— para automatizar operaciones y auditoría.
12. Utilizar eventos programados cuando el caso de estudio lo requiera.

<a id="punto-7"></a>

# 7. Alcance del proyecto

El proyecto estará limitado al diseño, implementación y explotación de la base de datos.

No incluirá:

```
Frontend
Aplicación web
Aplicación móvil
API REST
Backend
Interfaces gráficas
```

El producto principal será una base de datos funcional en MySQL.

<a id="punto-8"></a>

# 8. Alcance funcional de la base de datos

La base de datos deberá permitir gestionar información relacionada con:

```
Pacientes
Historias clínicas
Profesionales
Consultas
Antecedentes
Diagnósticos
Especialidades
Exámenes oftalmológicos
Presión intraocular
Paquimetrías
Gonioscopías
OCT
Campos visuales
Tratamientos
Medicamentos
Procedimientos
Controles de glaucoma
Archivos clínicos
Auditoría
```

<a id="punto-9"></a>

# 9. Entidades preliminares

A partir del análisis inicial podrían identificarse entidades como:

```
patients
clinical_histories
medical_visits
healthcare_professionals
specialties
medical_histories
diagnoses
visit_diagnoses
ophthalmologic_exams
intraocular_pressures
pachymetry_exams
gonioscopy_exams
oct_exams
visual_field_exams
glaucoma_records
glaucoma_controls
medications
treatments
procedures
clinical_documents
audit_logs
```

Estas entidades deberán validarse y refinarse durante el modelado.

<a id="punto-10"></a>

# 10. Modelo conceptual esperado

En el modelo conceptual deberán representarse las entidades principales sin depender todavía de detalles específicos del motor MySQL.

Una aproximación inicial podría ser:

```
PACIENTE
   |
   | 1
   |
   | 1
   v
HISTORIA_CLINICA
   |
   | 1
   |
   | N
   v
CONSULTA
   |
   +------------------+
   |                  |
   v                  v
DIAGNOSTICO       EXAMEN_OFTALMOLOGICO
                      |
        +-------------+-------------+
        |             |             |
        v             v             v
       PIO           OCT       CAMPO_VISUAL
```

Además:

```
PACIENTE
   |
   | 1
   |
   | N
   v
TRATAMIENTO
```

y:

```
PACIENTE
   |
   | 1
   |
   | N
   v
CONTROL_GLAUCOMA
```

*Boceto preliminar del enunciado. La respuesta siguiente presenta el modelo corregido.*

**Respuesta / desarrollo:**

### Modelo conceptual completo

```text
[Tipo_de_documento] 1 -------- N [Paciente]
                                      |
                                      +-- 1 -------- 1 [Historia_clinica]
                                      |                    |
                                      |                    +-- 1 -- N [Documento_clinico]
                                      |                    |
                                      |                    +-- 1 -- N [Consulta]
                                      |
                                      +-- 1 -- N [Antecedente]
                                      |
                                      +-- 1 -- N [Registro_de_glaucoma]
                                      |                    |
                                      |                    +-- 1 -- N [Control_de_glaucoma]
                                      |
                                      +-- 1 -- N [Notificacion_interna]

[Especialidad] 1 -- N [Profesional] 1 -- N [Consulta]

[Consulta]
    |
    +-- N -- N [Diagnostico]
    |
    +-- 1 -- N [Examen_oftalmologico]
    +-- 1 -- N [Presion_intraocular]
    +-- 1 -- N [Paquimetria]
    +-- 1 -- N [Gonioscopia]
    +-- 1 -- N [OCT]
    +-- 1 -- N [Campo_visual]
    |
    +-- 1 -- N [Control_de_glaucoma]
    +-- 1 -- N [Procedimiento]
    +-- 1 -- N [Tratamiento] N -- 1 (opcional) [Medicamento]

[Auditoria]: registra cambios en los datos del sistema.
```

<a id="punto-11"></a>

# 11. Modelo lógico esperado

Ejemplo:

```
PATIENTS
-------
id PK
document_type_id FK
document_number
first_name
last_name
birth_date
sex

CLINICAL_HISTORIES
------------------
id PK
patient_id FK

MEDICAL_VISITS
--------------
id PK
clinical_history_id FK
professional_id FK
visit_date
reason
assessment
plan
```

El modelo completo deberá incluir todas las claves y cardinalidades.

**Respuesta / desarrollo:**

### 01 Identidad y atencion

```text
+----------------+
| document_types |
| PK id          |
| UK code        |
| UK name        |
+----------------+

+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+-------------+
| specialties |
| PK id       |
| UK name     |
+-------------+

+--------------------------+
| healthcare_professionals |
| PK id                    |
| FK specialty_id          |
| UK document_number       |
| first_name               |
| last_name                |
| active                   |
+--------------------------+

+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

RELACIONES
[document_types] 1 ------ N [patients]
[specialties] 1 ------ N [healthcare_professionals]
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[healthcare_professionals] 1 ------ N [medical_visits]
```

### 02 Diagnosticos y antecedentes

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+-------------------+
| medical_histories |
| PK id             |
| FK patient_id     |
| history_type      |
| description       |
| recorded_at       |
+-------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+----------------------+
| visit_diagnoses      |
| PK, FK visit_id      |
| PK, FK diagnosis_id  |
| PK eye               |
| is_primary           |
| UK primary_visit_eye |
+----------------------+

+---------------+
| diagnoses     |
| PK id         |
| UK code       |
| name          |
| glaucoma_type |
+---------------+

RELACIONES
[patients] 1 ------ N [medical_histories]
[medical_visits] 1 ====== N [visit_diagnoses]
[diagnoses] 1 ====== N [visit_diagnoses]
```

### 03 Examenes

```text
+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+----------------------+
| ophthalmologic_exams |
| PK id                |
| FK visit_id          |
| exam_date            |
| eye                  |
| visual_acuity        |
| optic_nerve_notes    |
| notes                |
+----------------------+

+-----------------------+
| intraocular_pressures |
| PK id                 |
| FK visit_id           |
| eye                   |
| measured_at           |
| pressure              |
+-----------------------+

+-------------------+
| pachymetry_exams  |
| PK id             |
| FK visit_id       |
| eye               |
| exam_date         |
| corneal_thickness |
+-------------------+

+------------------+
| gonioscopy_exams |
| PK id            |
| FK visit_id      |
| eye              |
| exam_date        |
| result           |
+------------------+

+----------------+
| oct_exams      |
| PK id          |
| FK visit_id    |
| eye            |
| exam_date      |
| rnfl           |
| interpretation |
| validated      |
+----------------+

+--------------------+
| visual_field_exams |
| PK id              |
| FK visit_id        |
| eye                |
| exam_date          |
| md                 |
| psd                |
| vfi                |
| interpretation     |
+--------------------+

RELACIONES
[medical_visits] 1 ------ N [ophthalmologic_exams]
[medical_visits] 1 ------ N [intraocular_pressures]
[medical_visits] 1 ------ N [pachymetry_exams]
[medical_visits] 1 ------ N [gonioscopy_exams]
[medical_visits] 1 ------ N [oct_exams]
[medical_visits] 1 ------ N [visual_field_exams]
```

### 04 Glaucoma

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+------------------+
| glaucoma_records |
| PK id            |
| FK patient_id    |
| eye              |
| opened_at        |
| closed_at        |
+------------------+

+-----------------------+
| glaucoma_controls     |
| PK id                 |
| FK glaucoma_record_id |
| FK visit_id           |
| control_date          |
| glaucoma_type         |
| target_pressure       |
| clinical_status       |
| notes                 |
+-----------------------+

RELACIONES
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[patients] 1 ------ N [glaucoma_records]
[glaucoma_records] 1 ------ N [glaucoma_controls]
[medical_visits] 1 ------ N [glaucoma_controls]
```

### 05 Terapia y archivos

```text
+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+------------------+
| treatments       |
| PK id            |
| FK visit_id      |
| FK medication_id |
| eye              |
| start_date       |
| end_date         |
| active           |
| dose             |
| frequency        |
| notes            |
+------------------+

+-------------+
| medications |
| PK id       |
| UK name     |
| active      |
+-------------+

+----------------+
| procedures     |
| PK id          |
| FK visit_id    |
| eye            |
| procedure_type |
| procedure_date |
| notes          |
+----------------+

+------------------------+
| clinical_documents     |
| PK id                  |
| FK clinical_history_id |
| document_type          |
| file_name              |
| file_uri               |
| created_at             |
+------------------------+

+----------------------+
| audit_logs           |
| PK id                |
| table_name           |
| record_key           |
| action               |
| old_data : Documento |
| new_data : Documento |
| changed_by           |
| changed_at           |
+----------------------+

RELACIONES
[clinical_histories] 1 ------ N [medical_visits]
[medical_visits] 1 ------ N [treatments]
[medications] 1 (opcional) ------ N [treatments]
[medical_visits] 1 ------ N [procedures]
[clinical_histories] 1 ------ N [clinical_documents]
```

### 06 Soporte

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+---------------+
| notifications |
| PK id         |
| FK patient_id |
| message       |
| created_at    |
+---------------+

RELACIONES
[patients] 1 ------ N [notifications]
```

<a id="punto-12"></a>

# 12. Diagrama Entidad-Relación

El DER deberá representar:

- entidades;
- atributos;
- claves primarias;
- claves foráneas;
- relaciones;
- cardinalidades;
- participación;
- entidades asociativas.

Por ejemplo:

```
PATIENT
1
|
|
1
CLINICAL_HISTORY

CLINICAL_HISTORY
1
|
|
N
MEDICAL_VISIT

MEDICAL_VISIT
N
|
|
N
DIAGNOSIS
```

La relación muchos a muchos entre consulta y diagnóstico deberá resolverse mediante una entidad asociativa:

```
VISIT_DIAGNOSES
```

**Respuesta / desarrollo:**

![Modelo completo con entidades, atributos y relaciones](modelo_completo.png)

**[Abrir el modelo completo y ampliar la imagen](modelo_completo.png)**




### 01 Identidad y atencion

```text
+----------------+
| document_types |
| PK id          |
| UK code        |
| UK name        |
+----------------+

+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+-------------+
| specialties |
| PK id       |
| UK name     |
+-------------+

+--------------------------+
| healthcare_professionals |
| PK id                    |
| FK specialty_id          |
| UK document_number       |
| first_name               |
| last_name                |
| active                   |
+--------------------------+

+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

RELACIONES
[document_types] 1 ------ N [patients]
[specialties] 1 ------ N [healthcare_professionals]
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[healthcare_professionals] 1 ------ N [medical_visits]
```

### 02 Diagnosticos y antecedentes

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+-------------------+
| medical_histories |
| PK id             |
| FK patient_id     |
| history_type      |
| description       |
| recorded_at       |
+-------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+----------------------+
| visit_diagnoses      |
| PK, FK visit_id      |
| PK, FK diagnosis_id  |
| PK eye               |
| is_primary           |
| UK primary_visit_eye |
+----------------------+

+---------------+
| diagnoses     |
| PK id         |
| UK code       |
| name          |
| glaucoma_type |
+---------------+

RELACIONES
[patients] 1 ------ N [medical_histories]
[medical_visits] 1 ====== N [visit_diagnoses]
[diagnoses] 1 ====== N [visit_diagnoses]
```

### 03 Examenes

```text
+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+----------------------+
| ophthalmologic_exams |
| PK id                |
| FK visit_id          |
| exam_date            |
| eye                  |
| visual_acuity        |
| optic_nerve_notes    |
| notes                |
+----------------------+

+-----------------------+
| intraocular_pressures |
| PK id                 |
| FK visit_id           |
| eye                   |
| measured_at           |
| pressure              |
+-----------------------+

+-------------------+
| pachymetry_exams  |
| PK id             |
| FK visit_id       |
| eye               |
| exam_date         |
| corneal_thickness |
+-------------------+

+------------------+
| gonioscopy_exams |
| PK id            |
| FK visit_id      |
| eye              |
| exam_date        |
| result           |
+------------------+

+----------------+
| oct_exams      |
| PK id          |
| FK visit_id    |
| eye            |
| exam_date      |
| rnfl           |
| interpretation |
| validated      |
+----------------+

+--------------------+
| visual_field_exams |
| PK id              |
| FK visit_id        |
| eye                |
| exam_date          |
| md                 |
| psd                |
| vfi                |
| interpretation     |
+--------------------+

RELACIONES
[medical_visits] 1 ------ N [ophthalmologic_exams]
[medical_visits] 1 ------ N [intraocular_pressures]
[medical_visits] 1 ------ N [pachymetry_exams]
[medical_visits] 1 ------ N [gonioscopy_exams]
[medical_visits] 1 ------ N [oct_exams]
[medical_visits] 1 ------ N [visual_field_exams]
```

### 04 Glaucoma

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+------------------+
| glaucoma_records |
| PK id            |
| FK patient_id    |
| eye              |
| opened_at        |
| closed_at        |
+------------------+

+-----------------------+
| glaucoma_controls     |
| PK id                 |
| FK glaucoma_record_id |
| FK visit_id           |
| control_date          |
| glaucoma_type         |
| target_pressure       |
| clinical_status       |
| notes                 |
+-----------------------+

RELACIONES
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[patients] 1 ------ N [glaucoma_records]
[glaucoma_records] 1 ------ N [glaucoma_controls]
[medical_visits] 1 ------ N [glaucoma_controls]
```

### 05 Terapia y archivos

```text
+--------------------+
| clinical_histories |
| PK id              |
| FK, UK patient_id  |
| UK history_number  |
| status             |
| created_at         |
+--------------------+

+------------------------+
| medical_visits         |
| PK id                  |
| FK clinical_history_id |
| FK professional_id     |
| visit_date             |
| reason                 |
| assessment             |
| plan                   |
| observations           |
| status                 |
| updated_at             |
+------------------------+

+------------------+
| treatments       |
| PK id            |
| FK visit_id      |
| FK medication_id |
| eye              |
| start_date       |
| end_date         |
| active           |
| dose             |
| frequency        |
| notes            |
+------------------+

+-------------+
| medications |
| PK id       |
| UK name     |
| active      |
+-------------+

+----------------+
| procedures     |
| PK id          |
| FK visit_id    |
| eye            |
| procedure_type |
| procedure_date |
| notes          |
+----------------+

+------------------------+
| clinical_documents     |
| PK id                  |
| FK clinical_history_id |
| document_type          |
| file_name              |
| file_uri               |
| created_at             |
+------------------------+

+----------------------+
| audit_logs           |
| PK id                |
| table_name           |
| record_key           |
| action               |
| old_data : Documento |
| new_data : Documento |
| changed_by           |
| changed_at           |
+----------------------+

RELACIONES
[clinical_histories] 1 ------ N [medical_visits]
[medical_visits] 1 ------ N [treatments]
[medications] 1 (opcional) ------ N [treatments]
[medical_visits] 1 ------ N [procedures]
[clinical_histories] 1 ------ N [clinical_documents]
```

### 06 Soporte

```text
+---------------------+
| patients            |
| PK id               |
| FK document_type_id |
| document_number     |
| first_name          |
| last_name           |
| birth_date          |
| sex                 |
| phone               |
| email               |
| city                |
| created_at          |
| updated_at          |
+---------------------+

+---------------+
| notifications |
| PK id         |
| FK patient_id |
| message       |
| created_at    |
+---------------+

RELACIONES
[patients] 1 ------ N [notifications]
```

### Claves, cardinalidades y participación

La tabla se lee: cada hijo tiene la cantidad indicada de padres; cada padre puede tener la cantidad indicada de hijos. Mínimo 1 = participación total; mínimo 0 = parcial. En conceptual, Consulta–Diagnóstico es N:M (N en ambos extremos). En lógico y DER se resuelve con visit_diagnoses.

| Padre | Hijo | FK | Padres por hijo | Hijos por padre |
|---|---|---|---|---|
| document_types | patients | document_type_id | 1 | N |
| specialties | healthcare_professionals | specialty_id | 1 | N |
| patients | clinical_histories | patient_id | 1 | 1 |
| clinical_histories | medical_visits | clinical_history_id | 1 | N |
| healthcare_professionals | medical_visits | professional_id | 1 | N |
| patients | medical_histories | patient_id | 1 | N |
| medical_visits | visit_diagnoses | visit_id | 1 | N |
| diagnoses | visit_diagnoses | diagnosis_id | 1 | N |
| medical_visits | ophthalmologic_exams | visit_id | 1 | N |
| medical_visits | intraocular_pressures | visit_id | 1 | N |
| medical_visits | pachymetry_exams | visit_id | 1 | N |
| medical_visits | gonioscopy_exams | visit_id | 1 | N |
| medical_visits | oct_exams | visit_id | 1 | N |
| medical_visits | visual_field_exams | visit_id | 1 | N |
| patients | glaucoma_records | patient_id | 1 | N |
| glaucoma_records | glaucoma_controls | glaucoma_record_id | 1 | N |
| medical_visits | glaucoma_controls | visit_id | 1 | N |
| medical_visits | treatments | visit_id | 1 | N |
| medications | treatments | medication_id | 1 (opcional) | N |
| medical_visits | procedures | visit_id | 1 | N |
| clinical_histories | clinical_documents | clinical_history_id | 1 | N |
| patients | notifications | patient_id | 1 | N |

La FK UNIQUE de clinical_histories impone máximo una historia; los triggers de alta y protección aseguran el mínimo de una historia para cada paciente en el flujo normal. No se permite eludirlos mediante TRUNCATE ni operaciones administrativas que rompan las reglas.

<a id="punto-13"></a>

# 13. Proceso de normalización

Uno de los componentes principales del proyecto será demostrar el proceso de normalización.

La normalización deberá desarrollarse progresivamente.

<a id="punto-14"></a>

# 14. Datos no normalizados

Podría partirse de una estructura como:

```
HISTORIA_CLINICA

paciente
documento
telefono
consulta_fecha
diagnosticos
medicamentos
presion_od
presion_oi
oct
campo_visual
```

Ejemplo:

```
Paciente:
Carlos Gómez

Diagnósticos:
Glaucoma, Catarata

Medicamentos:
Latanoprost, Timolol
```

Aquí existen valores multivaluados.

<a id="punto-15"></a>

# 15. Primera Forma Normal —1FN

La 1FN exige:

- atributos atómicos;
- ausencia de grupos repetitivos;
- una celda debe contener un solo valor.

Incorrecto:

```
diagnosticos:
Glaucoma, Catarata
```

Correcto:

```
VISIT_DIAGNOSES

visit_id | diagnosis_id
------------------------
1        | 5
1        | 8
```

<a id="punto-16"></a>

# 16. Segunda Forma Normal —2FN

La 2FN requiere:

- estar en 1FN;
- eliminar dependencias parciales respecto a claves compuestas.

Ejemplo:

```
VISIT_DIAGNOSES

visit_id
diagnosis_id
diagnosis_name
```

Si:

```
diagnosis_name
```

depende únicamente de:

```
diagnosis_id
```

debe trasladarse a:

```
DIAGNOSES
```

<a id="punto-17"></a>

# 17. Tercera Forma Normal —3FN

La 3FN elimina dependencias transitivas.

Ejemplo incorrecto:

```
PATIENTS

patient_id
city_id
city_name
department_name
```

Si:

```
patient_id -> city_id
city_id -> city_name
```

entonces:

```
city_name
```

no debe almacenarse directamente en `patients`.

Se crean catálogos independientes.

<a id="punto-18"></a>

# 18. Forma Normal de Boyce-Codd —BCNF

Cuando sea pertinente, deberán revisarse dependencias funcionales más estrictas.

Toda dependencia funcional:

```
X -> Y
```

deberá tener como determinante una superclave.

<a id="punto-19"></a>

# 19. Cuarta Forma Normal —4FN

La 4FN será especialmente importante en este proyecto debido a la existencia de atributos multivaluados independientes.

Supóngase:

```
PATIENT

patient_id
allergy
family_history
```

Un paciente puede tener:

```
N alergias
```

y también:

```
N antecedentes familiares
```

ambos independientes.

Una única relación podría producir combinaciones artificiales:

```
Alergia A + Antecedente 1
Alergia A + Antecedente 2
Alergia B + Antecedente 1
Alergia B + Antecedente 2
```

Esto representa una dependencia multivaluada.

Para alcanzar 4FN deberían separarse:

```
PATIENT_ALLERGIES
```

y:

```
PATIENT_FAMILY_HISTORIES
```

<a id="punto-20"></a>

# 20. Ejemplo de aplicación de 4FN en el proyecto

Otra situación:

Un paciente puede tener múltiples:

```
medicamentos
```

y múltiples:

```
antecedentes
```

Estos conjuntos no dependen entre sí.

Incorrecto:

```
patient_medications_histories
```

Correcto:

```
PATIENT_MEDICATIONS

patient_id
medication_id
```

y:

```
PATIENT_HISTORIES

patient_id
history_type_id
description
```

<a id="punto-21"></a>

# 21. Implementación física en MySQL

Después de validar el modelo lógico, deberá construirse el modelo físico mediante:

```
CREATE DATABASE
CREATE TABLE
ALTER TABLE
```

Se deberán utilizar tipos apropiados como:

```
BIGINT
INT
VARCHAR
TEXT
DATE
DATETIME
DECIMAL
BOOLEAN
```

**Respuesta / desarrollo:**

### Tablas y tipos MySQL

PK = primaria; FK = foránea; UQ = única; AI = AUTO_INCREMENT. Campos obligatorios salvo NULL.

### document_types

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| code | VARCHAR(10) | UQ |
| name | VARCHAR(50) | UQ |

### specialties

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| name | VARCHAR(100) | UQ |

### patients

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| document_type_id | BIGINT | FK → document_types |
| document_number | VARCHAR(30) | — |
| first_name | VARCHAR(100) | — |
| last_name | VARCHAR(100) | — |
| birth_date | DATE | — |
| sex | VARCHAR(20) | NULL |
| phone | VARCHAR(30) | NULL |
| email | VARCHAR(150) | NULL |
| city | VARCHAR(100) | NULL |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP; actualizado por trigger |


### healthcare_professionals

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| specialty_id | BIGINT | FK → specialties |
| document_number | VARCHAR(30) | UQ |
| first_name | VARCHAR(100) | — |
| last_name | VARCHAR(100) | — |
| active | BOOLEAN | DEFAULT TRUE |

### clinical_histories

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| patient_id | BIGINT | FK → patients; UQ |
| history_number | VARCHAR(30) | UQ |
| status | VARCHAR(20) | DEFAULT 'ACTIVE' |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### medical_visits

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| clinical_history_id | BIGINT | FK → clinical_histories |
| professional_id | BIGINT | FK → healthcare_professionals |
| visit_date | DATETIME | — |
| reason | TEXT | NULL |
| assessment | TEXT | NULL |
| plan | TEXT | NULL |
| observations | TEXT | NULL |
| status | VARCHAR(20) | DEFAULT 'OPEN' |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP; actualizado por trigger |

### medical_histories

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| patient_id | BIGINT | FK → patients |
| history_type | VARCHAR(100) | — |
| description | TEXT | — |
| recorded_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### diagnoses

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| code | VARCHAR(30) | UQ |
| name | VARCHAR(150) | — |
| glaucoma_type | VARCHAR(100) | NULL |

### visit_diagnoses

| Campo | Tipo | Restricciones |
|---|---|---|
| visit_id | BIGINT | PK; FK → medical_visits |
| diagnosis_id | BIGINT | PK; FK → diagnoses |
| eye | CHAR(2) | PK |
| is_primary | BOOLEAN | DEFAULT FALSE |
| primary_visit_eye | VARCHAR(80) | UQ; NULL; Generada y UNIQUE; ver DDL |


### ophthalmologic_exams

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| exam_date | DATETIME | — |
| eye | CHAR(2) | — |
| visual_acuity | VARCHAR(30) | NULL |
| optic_nerve_notes | TEXT | NULL |
| notes | TEXT | NULL |


### intraocular_pressures

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| measured_at | DATETIME | — |
| pressure | DECIMAL(5,2) | — |


### pachymetry_exams

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| exam_date | DATETIME | — |
| corneal_thickness | DECIMAL(7,2) | — |


### gonioscopy_exams

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| exam_date | DATETIME | — |
| result | TEXT | NULL |


### oct_exams

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| exam_date | DATETIME | — |
| rnfl | DECIMAL(7,2) | NULL |
| interpretation | TEXT | NULL |
| validated | BOOLEAN | DEFAULT FALSE |


### visual_field_exams

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| exam_date | DATETIME | — |
| md | DECIMAL(7,2) | NULL |
| psd | DECIMAL(7,2) | NULL |
| vfi | DECIMAL(5,2) | NULL |
| interpretation | TEXT | NULL |


### glaucoma_records

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| patient_id | BIGINT | FK → patients |
| eye | CHAR(2) | — |
| opened_at | DATETIME | — |
| closed_at | DATETIME | NULL |


### glaucoma_controls

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| glaucoma_record_id | BIGINT | FK → glaucoma_records |
| visit_id | BIGINT | FK → medical_visits |
| control_date | DATETIME | — |
| glaucoma_type | VARCHAR(100) | NULL |
| target_pressure | DECIMAL(5,2) | NULL |
| clinical_status | VARCHAR(100) | NULL |
| notes | TEXT | NULL |


### medications

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| name | VARCHAR(150) | UQ |
| active | BOOLEAN | DEFAULT TRUE |

### treatments

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| medication_id | BIGINT | FK → medications; NULL |
| eye | CHAR(2) | — |
| start_date | DATE | — |
| end_date | DATE | NULL |
| active | BOOLEAN | DEFAULT TRUE |
| dose | VARCHAR(100) | NULL |
| frequency | VARCHAR(100) | NULL |
| notes | TEXT | NULL |


### procedures

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| visit_id | BIGINT | FK → medical_visits |
| eye | CHAR(2) | — |
| procedure_type | VARCHAR(150) | — |
| procedure_date | DATETIME | — |
| notes | TEXT | NULL |


### clinical_documents

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| clinical_history_id | BIGINT | FK → clinical_histories |
| document_type | VARCHAR(100) | — |
| file_name | VARCHAR(255) | — |
| file_uri | VARCHAR(500) | — |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### audit_logs

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| table_name | VARCHAR(100) | — |
| record_key | VARCHAR(150) | — |
| action | VARCHAR(20) | — |
| old_data | JSON | NULL |
| new_data | JSON | NULL |
| changed_by | VARCHAR(100) | — |
| changed_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |


### notifications

| Campo | Tipo | Restricciones |
|---|---|---|
| id | BIGINT | PK; AI |
| patient_id | BIGINT | FK → patients |
| message | VARCHAR(255) | — |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

El modelo lógico convierte las entidades en tablas y define sus campos y conexiones. Por ejemplo, Historia_clinica se convierte en clinical_histories, y patient_id la conecta con patients. Las siguientes vistas muestran las tablas por grupos para facilitar su lectura.

### 01 Identidad y atencion

```text
+-----------------------+
| document_types        |
| PK id : BIGINT        |
| UK code : VARCHAR_10_ |
| UK name : VARCHAR_50_ |
+-----------------------+

+-------------------------------+
| patients                      |
| PK id : BIGINT                |
| FK document_type_id : BIGINT  |
| document_number : VARCHAR_30_ |
| first_name : VARCHAR_100_     |
| last_name : VARCHAR_100_      |
| birth_date : DATE             |
| sex : VARCHAR_20_             |
| phone : VARCHAR_30_           |
| email : VARCHAR_150_          |
| city : VARCHAR_100_           |
| created_at : DATETIME         |
| updated_at : DATETIME         |
+-------------------------------+

+------------------------+
| specialties            |
| PK id : BIGINT         |
| UK name : VARCHAR_100_ |
+------------------------+

+----------------------------------+
| healthcare_professionals         |
| PK id : BIGINT                   |
| FK specialty_id : BIGINT         |
| UK document_number : VARCHAR_30_ |
| first_name : VARCHAR_100_        |
| last_name : VARCHAR_100_         |
| active : BOOLEAN                 |
+----------------------------------+

+---------------------------------+
| clinical_histories              |
| PK id : BIGINT                  |
| FK, UK patient_id : BIGINT      |
| UK history_number : VARCHAR_30_ |
| status : VARCHAR_20_            |
| created_at : DATETIME           |
+---------------------------------+

+---------------------------------+
| medical_visits                  |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| FK professional_id : BIGINT     |
| visit_date : DATETIME           |
| reason : TEXT                   |
| assessment : TEXT               |
| plan : TEXT                     |
| observations : TEXT             |
| status : VARCHAR_20_            |
| updated_at : DATETIME           |
+---------------------------------+

RELACIONES
[document_types] 1 ------ N [patients]
[specialties] 1 ------ N [healthcare_professionals]
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[healthcare_professionals] 1 ------ N [medical_visits]
```

### 02 Diagnosticos y antecedentes

```text
+-------------------------------+
| patients                      |
| PK id : BIGINT                |
| FK document_type_id : BIGINT  |
| document_number : VARCHAR_30_ |
| first_name : VARCHAR_100_     |
| last_name : VARCHAR_100_      |
| birth_date : DATE             |
| sex : VARCHAR_20_             |
| phone : VARCHAR_30_           |
| email : VARCHAR_150_          |
| city : VARCHAR_100_           |
| created_at : DATETIME         |
| updated_at : DATETIME         |
+-------------------------------+

+-----------------------------+
| medical_histories           |
| PK id : BIGINT              |
| FK patient_id : BIGINT      |
| history_type : VARCHAR_100_ |
| description : TEXT          |
| recorded_at : DATETIME      |
+-----------------------------+

+---------------------------------+
| medical_visits                  |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| FK professional_id : BIGINT     |
| visit_date : DATETIME           |
| reason : TEXT                   |
| assessment : TEXT               |
| plan : TEXT                     |
| observations : TEXT             |
| status : VARCHAR_20_            |
| updated_at : DATETIME           |
+---------------------------------+

+------------------------------------+
| visit_diagnoses                    |
| PK, FK visit_id : BIGINT           |
| PK, FK diagnosis_id : BIGINT       |
| PK eye : CHAR_2_                   |
| is_primary : BOOLEAN               |
| UK primary_visit_eye : VARCHAR_80_ |
+------------------------------------+

+------------------------------+
| diagnoses                    |
| PK id : BIGINT               |
| UK code : VARCHAR_30_        |
| name : VARCHAR_150_          |
| glaucoma_type : VARCHAR_100_ |
+------------------------------+

RELACIONES
[patients] 1 ------ N [medical_histories]
[medical_visits] 1 ====== N [visit_diagnoses]
[diagnoses] 1 ====== N [visit_diagnoses]
```

### 03 Examenes

```text
+---------------------------------+
| medical_visits                  |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| FK professional_id : BIGINT     |
| visit_date : DATETIME           |
| reason : TEXT                   |
| assessment : TEXT               |
| plan : TEXT                     |
| observations : TEXT             |
| status : VARCHAR_20_            |
| updated_at : DATETIME           |
+---------------------------------+

+-----------------------------+
| ophthalmologic_exams        |
| PK id : BIGINT              |
| FK visit_id : BIGINT        |
| exam_date : DATETIME        |
| eye : CHAR_2_               |
| visual_acuity : VARCHAR_30_ |
| optic_nerve_notes : TEXT    |
| notes : TEXT                |
+-----------------------------+

+-------------------------+
| intraocular_pressures   |
| PK id : BIGINT          |
| FK visit_id : BIGINT    |
| eye : CHAR_2_           |
| measured_at : DATETIME  |
| pressure : DECIMAL_5_2_ |
+-------------------------+

+----------------------------------+
| pachymetry_exams                 |
| PK id : BIGINT                   |
| FK visit_id : BIGINT             |
| eye : CHAR_2_                    |
| exam_date : DATETIME             |
| corneal_thickness : DECIMAL_7_2_ |
+----------------------------------+

+----------------------+
| gonioscopy_exams     |
| PK id : BIGINT       |
| FK visit_id : BIGINT |
| eye : CHAR_2_        |
| exam_date : DATETIME |
| result : TEXT        |
+----------------------+

+-----------------------+
| oct_exams             |
| PK id : BIGINT        |
| FK visit_id : BIGINT  |
| eye : CHAR_2_         |
| exam_date : DATETIME  |
| rnfl : DECIMAL_7_2_   |
| interpretation : TEXT |
| validated : BOOLEAN   |
+-----------------------+

+-----------------------+
| visual_field_exams    |
| PK id : BIGINT        |
| FK visit_id : BIGINT  |
| eye : CHAR_2_         |
| exam_date : DATETIME  |
| md : DECIMAL_7_2_     |
| psd : DECIMAL_7_2_    |
| vfi : DECIMAL_5_2_    |
| interpretation : TEXT |
+-----------------------+

RELACIONES
[medical_visits] 1 ------ N [ophthalmologic_exams]
[medical_visits] 1 ------ N [intraocular_pressures]
[medical_visits] 1 ------ N [pachymetry_exams]
[medical_visits] 1 ------ N [gonioscopy_exams]
[medical_visits] 1 ------ N [oct_exams]
[medical_visits] 1 ------ N [visual_field_exams]
```

### 04 Glaucoma

```text
+-------------------------------+
| patients                      |
| PK id : BIGINT                |
| FK document_type_id : BIGINT  |
| document_number : VARCHAR_30_ |
| first_name : VARCHAR_100_     |
| last_name : VARCHAR_100_      |
| birth_date : DATE             |
| sex : VARCHAR_20_             |
| phone : VARCHAR_30_           |
| email : VARCHAR_150_          |
| city : VARCHAR_100_           |
| created_at : DATETIME         |
| updated_at : DATETIME         |
+-------------------------------+

+---------------------------------+
| clinical_histories              |
| PK id : BIGINT                  |
| FK, UK patient_id : BIGINT      |
| UK history_number : VARCHAR_30_ |
| status : VARCHAR_20_            |
| created_at : DATETIME           |
+---------------------------------+

+---------------------------------+
| medical_visits                  |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| FK professional_id : BIGINT     |
| visit_date : DATETIME           |
| reason : TEXT                   |
| assessment : TEXT               |
| plan : TEXT                     |
| observations : TEXT             |
| status : VARCHAR_20_            |
| updated_at : DATETIME           |
+---------------------------------+

+------------------------+
| glaucoma_records       |
| PK id : BIGINT         |
| FK patient_id : BIGINT |
| eye : CHAR_2_          |
| opened_at : DATETIME   |
| closed_at : DATETIME   |
+------------------------+

+--------------------------------+
| glaucoma_controls              |
| PK id : BIGINT                 |
| FK glaucoma_record_id : BIGINT |
| FK visit_id : BIGINT           |
| control_date : DATETIME        |
| glaucoma_type : VARCHAR_100_   |
| target_pressure : DECIMAL_5_2_ |
| clinical_status : VARCHAR_100_ |
| notes : TEXT                   |
+--------------------------------+

RELACIONES
[patients] 1 ------ 1 [clinical_histories]
[clinical_histories] 1 ------ N [medical_visits]
[patients] 1 ------ N [glaucoma_records]
[glaucoma_records] 1 ------ N [glaucoma_controls]
[medical_visits] 1 ------ N [glaucoma_controls]
```

### 05 Terapia y archivos

```text
+---------------------------------+
| clinical_histories              |
| PK id : BIGINT                  |
| FK, UK patient_id : BIGINT      |
| UK history_number : VARCHAR_30_ |
| status : VARCHAR_20_            |
| created_at : DATETIME           |
+---------------------------------+

+---------------------------------+
| medical_visits                  |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| FK professional_id : BIGINT     |
| visit_date : DATETIME           |
| reason : TEXT                   |
| assessment : TEXT               |
| plan : TEXT                     |
| observations : TEXT             |
| status : VARCHAR_20_            |
| updated_at : DATETIME           |
+---------------------------------+

+---------------------------+
| treatments                |
| PK id : BIGINT            |
| FK visit_id : BIGINT      |
| FK medication_id : BIGINT |
| eye : CHAR_2_             |
| start_date : DATE         |
| end_date : DATE           |
| active : BOOLEAN          |
| dose : VARCHAR_100_       |
| frequency : VARCHAR_100_  |
| notes : TEXT              |
+---------------------------+

+------------------------+
| medications            |
| PK id : BIGINT         |
| UK name : VARCHAR_150_ |
| active : BOOLEAN       |
+------------------------+

+-------------------------------+
| procedures                    |
| PK id : BIGINT                |
| FK visit_id : BIGINT          |
| eye : CHAR_2_                 |
| procedure_type : VARCHAR_150_ |
| procedure_date : DATETIME     |
| notes : TEXT                  |
+-------------------------------+

+---------------------------------+
| clinical_documents              |
| PK id : BIGINT                  |
| FK clinical_history_id : BIGINT |
| document_type : VARCHAR_100_    |
| file_name : VARCHAR_255_        |
| file_uri : VARCHAR_500_         |
| created_at : DATETIME           |
+---------------------------------+

+---------------------------+
| audit_logs                |
| PK id : BIGINT            |
| table_name : VARCHAR_100_ |
| record_key : VARCHAR_150_ |
| action : VARCHAR_20_      |
| old_data : JSON           |
| new_data : JSON           |
| changed_by : VARCHAR_100_ |
| changed_at : DATETIME     |
+---------------------------+

RELACIONES
[clinical_histories] 1 ------ N [medical_visits]
[medical_visits] 1 ------ N [treatments]
[medications] 1 (opcional) ------ N [treatments]
[medical_visits] 1 ------ N [procedures]
[clinical_histories] 1 ------ N [clinical_documents]
```

### 06 Soporte

```text
+-------------------------------+
| patients                      |
| PK id : BIGINT                |
| FK document_type_id : BIGINT  |
| document_number : VARCHAR_30_ |
| first_name : VARCHAR_100_     |
| last_name : VARCHAR_100_      |
| birth_date : DATE             |
| sex : VARCHAR_20_             |
| phone : VARCHAR_30_           |
| email : VARCHAR_150_          |
| city : VARCHAR_100_           |
| created_at : DATETIME         |
| updated_at : DATETIME         |
+-------------------------------+

+------------------------+
| notifications          |
| PK id : BIGINT         |
| FK patient_id : BIGINT |
| message : VARCHAR_255_ |
| created_at : DATETIME  |
+------------------------+

RELACIONES
[patients] 1 ------ N [notifications]
```

### DDL ejecutado

El script DDL completo está en el bloque siguiente. Ejecutar en una base nueva de práctica; no mezclar con los scripts antiguos.

```sql
-- Fuente física definitiva para esta entrega de modelos. MySQL 8.4.
-- No ejecutar sobre la base del borrador.
CREATE DATABASE IF NOT EXISTS ophthalmology_modelo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ophthalmology_modelo;

CREATE TABLE `document_types` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(10) NOT NULL UNIQUE,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `specialties` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `patients` (
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `document_type_id` BIGINT NOT NULL,
  `document_number` VARCHAR(30) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `birth_date` DATE NOT NULL,
  `sex` VARCHAR(20) NULL,
  `phone` VARCHAR(30) NULL,
  `email` VARCHAR(150) NULL,
  `city` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`document_type_id`) REFERENCES `document_types`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_document_type_id (document_type_id),
  UNIQUE(document_type_id, document_number)
) ENGINE=InnoDB;

CREATE TABLE `healthcare_professionals` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `specialty_id` BIGINT NOT NULL,
  `document_number` VARCHAR(30) NOT NULL UNIQUE,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`specialty_id`) REFERENCES `specialties`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_specialty_id (specialty_id)
) ENGINE=InnoDB;

CREATE TABLE `clinical_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL UNIQUE,
  `history_number` VARCHAR(30) NOT NULL UNIQUE,
  `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `medical_visits` (
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `clinical_history_id` BIGINT NOT NULL,
  `professional_id` BIGINT NOT NULL,
  `visit_date` DATETIME NOT NULL,
  `reason` TEXT NULL,
  `assessment` TEXT NULL,
  `plan` TEXT NULL,
  `observations` TEXT NULL,
  `status` VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`clinical_history_id`) REFERENCES `clinical_histories`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_clinical_history_id (clinical_history_id),
  FOREIGN KEY (`professional_id`) REFERENCES `healthcare_professionals`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_professional_id (professional_id)
) ENGINE=InnoDB;

CREATE TABLE `medical_histories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `history_type` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `recorded_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_patient_id (patient_id)
) ENGINE=InnoDB;

CREATE TABLE `diagnoses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(30) NOT NULL UNIQUE,
  `name` VARCHAR(150) NOT NULL,
  `glaucoma_type` VARCHAR(100) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `visit_diagnoses` (
  `visit_id` BIGINT NOT NULL,
  `diagnosis_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`visit_id`, `diagnosis_id`, `eye`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  FOREIGN KEY (`diagnosis_id`) REFERENCES `diagnoses`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CHECK(eye IN ('OD','OI','NA')),
  CHECK(is_primary IN (0,1)),
  primary_visit_eye VARCHAR(80) GENERATED ALWAYS AS (CASE WHEN is_primary = 1 THEN CONCAT(visit_id, ':', eye) ELSE NULL END) STORED,
  UNIQUE(primary_visit_eye)
) ENGINE=InnoDB;

CREATE TABLE `ophthalmologic_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `visual_acuity` VARCHAR(30) NULL,
  `optic_nerve_notes` TEXT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI'))
) ENGINE=InnoDB;

CREATE TABLE `intraocular_pressures` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `measured_at` DATETIME NOT NULL,
  `pressure` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(pressure >= 0)
) ENGINE=InnoDB;

CREATE TABLE `pachymetry_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `corneal_thickness` DECIMAL(7,2) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(corneal_thickness > 0)
) ENGINE=InnoDB;

CREATE TABLE `gonioscopy_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `result` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI'))
) ENGINE=InnoDB;

CREATE TABLE `oct_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `rnfl` DECIMAL(7,2) NULL,
  `interpretation` TEXT NULL,
  `validated` BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(rnfl IS NULL OR rnfl >= 0)
) ENGINE=InnoDB;

CREATE TABLE `visual_field_exams` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `exam_date` DATETIME NOT NULL,
  `md` DECIMAL(7,2) NULL,
  `psd` DECIMAL(7,2) NULL,
  `vfi` DECIMAL(5,2) NULL,
  `interpretation` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(vfi BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE `glaucoma_records` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES `patients`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_patient_id (patient_id),
  CHECK(eye IN ('OD','OI')),
  CHECK(closed_at IS NULL OR closed_at >= opened_at),
  UNIQUE(patient_id, eye, opened_at)
) ENGINE=InnoDB;

CREATE TABLE `glaucoma_controls` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `glaucoma_record_id` BIGINT NOT NULL,
  `visit_id` BIGINT NOT NULL,
  `control_date` DATETIME NOT NULL,
  `glaucoma_type` VARCHAR(100) NULL,
  `target_pressure` DECIMAL(5,2) NULL,
  `clinical_status` VARCHAR(100) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`glaucoma_record_id`) REFERENCES `glaucoma_records`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_glaucoma_record_id (glaucoma_record_id),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(target_pressure IS NULL OR target_pressure > 0)
) ENGINE=InnoDB;

CREATE TABLE `medications` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL UNIQUE,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE `treatments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `medication_id` BIGINT NULL,
  `eye` CHAR(2) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `dose` VARCHAR(100) NULL,
  `frequency` VARCHAR(100) NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  FOREIGN KEY (`medication_id`) REFERENCES `medications`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_medication_id (medication_id),
  CHECK(eye IN ('OD','OI','AO','NA')),
  CHECK(end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

CREATE TABLE `procedures` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `eye` CHAR(2) NOT NULL,
  `procedure_type` VARCHAR(150) NOT NULL,
  `procedure_date` DATETIME NOT NULL,
  `notes` TEXT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`visit_id`) REFERENCES `medical_visits`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_visit_id (visit_id),
  CHECK(eye IN ('OD','OI','AO','NA'))
) ENGINE=InnoDB;

CREATE TABLE `clinical_documents` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `clinical_history_id` BIGINT NOT NULL,
  `document_type` VARCHAR(100) NOT NULL,
  `file_name` VARCHAR(255) NOT NULL,
  `file_uri` VARCHAR(500) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`clinical_history_id`) REFERENCES `clinical_histories`(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  INDEX ix_clinical_history_id (clinical_history_id)
) ENGINE=InnoDB;

CREATE TABLE `audit_logs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(100) NOT NULL,
  `record_key` VARCHAR(150) NOT NULL,
  `action` VARCHAR(20) NOT NULL,
  `old_data` JSON NULL,
  `new_data` JSON NULL,
  `changed_by` VARCHAR(100) NOT NULL,
  `changed_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CHECK(action IN ('INSERT','UPDATE','DELETE'))
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER patients_create_history AFTER INSERT ON patients FOR EACH ROW
BEGIN
 INSERT INTO clinical_histories(patient_id, history_number) VALUES(NEW.id, CONCAT('HC-', NEW.id));
END$$
CREATE TRIGGER history_no_delete BEFORE DELETE ON clinical_histories FOR EACH ROW
BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Conservar historia; cerrar mediante status'; END$$
CREATE TRIGGER history_owner_immutable BEFORE UPDATE ON clinical_histories FOR EACH ROW
BEGIN IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Propietario de historia inmutable'; END IF; END$$
CREATE TRIGGER control_patient_insert BEFORE INSERT ON glaucoma_controls FOR EACH ROW
BEGIN
 IF (SELECT patient_id FROM glaucoma_records WHERE id=NEW.glaucoma_record_id) <>
 (SELECT ch.patient_id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=NEW.visit_id)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Control y consulta pertenecen a pacientes diferentes'; END IF;
END$$
CREATE TRIGGER control_patient_update BEFORE UPDATE ON glaucoma_controls FOR EACH ROW
BEGIN
 IF (SELECT patient_id FROM glaucoma_records WHERE id=NEW.glaucoma_record_id) <>
 (SELECT ch.patient_id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=NEW.visit_id)
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Control y consulta pertenecen a pacientes diferentes'; END IF;
END$$
CREATE TRIGGER medical_visits_owner_immutable BEFORE UPDATE ON medical_visits FOR EACH ROW BEGIN IF NEW.clinical_history_id <> OLD.clinical_history_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vinculo de paciente inmutable'; END IF; END$$
CREATE TRIGGER glaucoma_records_owner_immutable BEFORE UPDATE ON glaucoma_records FOR EACH ROW BEGIN IF NEW.patient_id <> OLD.patient_id THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Vinculo de paciente inmutable'; END IF; END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER glaucoma_eye_immutable BEFORE UPDATE ON glaucoma_records FOR EACH ROW
BEGIN IF NEW.eye <> OLD.eye THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo del episodio inmutable'; END IF; END$$

DELIMITER ;

CREATE TABLE notifications (id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, patient_id BIGINT NOT NULL, message VARCHAR(255) NOT NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(patient_id) REFERENCES patients(id));
```

<a id="punto-22"></a>

# 22. Restricciones

El proyecto deberá implementar restricciones.

Ejemplo:

```
CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,

    CONSTRAINT uq_patient_document
        UNIQUE(document_number)
);
```

<a id="punto-23"></a>

# 23. Integridad referencial

Ejemplo:

```
CREATE TABLE clinical_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,

    CONSTRAINT uq_history_patient
        UNIQUE(patient_id),

    CONSTRAINT fk_history_patient
        FOREIGN KEY(patient_id)
        REFERENCES patients(id)
);
```

<a id="punto-24"></a>

# 24. Datos de prueba

El proyecto deberá incluir información suficiente para validar las consultas.

Por ejemplo:

```
20 pacientes
5 profesionales
10 tipos de diagnósticos
30 consultas
50 mediciones PIO
20 OCT
20 campos visuales
15 tratamientos
```

Los datos deberán ser coherentes con las relaciones definidas.

**Respuesta / desarrollo:**

### Datos ficticios cargados

Carga inicial: 20 pacientes y sus 20 historias automáticas, cinco profesionales, diez diagnósticos, 30 consultas, 50 PIO, 20 OCT, 20 campos visuales, 15 paquimetrías y 15 tratamientos, además de casos de antecedentes, glaucoma, procedimientos y documentos. Son datos inventados para el taller, con pacientes sin consultas, catálogos sin uso y valores NULL. Las llamadas de prueba agregan registros después; el resumen real distingue ese estado de la carga inicial.

```sql
USE ophthalmology_modelo;
INSERT INTO document_types(code,name) VALUES('CC','Cédula'),('TI','Tarjeta');
INSERT INTO specialties(name) VALUES('Oftalmología'),('Glaucoma');
INSERT INTO healthcare_professionals(specialty_id,document_number,first_name,last_name,active) VALUES(2,'PRO1','Profesional1','Prueba',TRUE);
INSERT INTO healthcare_professionals(specialty_id,document_number,first_name,last_name,active) VALUES(1,'PRO2','Profesional2','Prueba',TRUE);
INSERT INTO healthcare_professionals(specialty_id,document_number,first_name,last_name,active) VALUES(2,'PRO3','Profesional3','Prueba',TRUE);
INSERT INTO healthcare_professionals(specialty_id,document_number,first_name,last_name,active) VALUES(1,'PRO4','Profesional4','Prueba',TRUE);
INSERT INTO healthcare_professionals(specialty_id,document_number,first_name,last_name,active) VALUES(2,'PRO5','Profesional5','Prueba',FALSE);
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101001','Paciente1','Gómez','1951-01-01','F','3000001','paciente1@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101002','Paciente2','Prueba','1952-01-01','M','3000002','paciente2@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101003','Paciente3','Gómez','1953-01-01','F','3000003','paciente3@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101004','Paciente4','Prueba','1954-01-01','M','3000004',NULL,'Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101005','Paciente5','Gómez','1955-01-01','F','3000005','paciente5@gmail.com',NULL);
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101006','Paciente6','Prueba','1956-01-01','M','3000006','paciente6@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101007','Paciente7','Gómez','1957-01-01','F','3000007','paciente7@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101008','Paciente8','Prueba','1958-01-01','M','3000008',NULL,'Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101009','Paciente9','Gómez','1959-01-01','F','3000009','paciente9@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101010','Paciente10','Prueba','1960-01-01','M','30000010','paciente10@gmail.com',NULL);
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101011','Paciente11','Gómez','1961-01-01','F','30000011','paciente11@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101012','Paciente12','Prueba','1962-01-01','M','30000012',NULL,'Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101013','Paciente13','Gómez','1963-01-01','F','30000013','paciente13@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101014','Paciente14','Prueba','1964-01-01','M','30000014','paciente14@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101015','Paciente15','Gómez','1965-01-01','F','30000015','paciente15@gmail.com',NULL);
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101016','Paciente16','Prueba','1966-01-01','M','30000016',NULL,'Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101017','Paciente17','Gómez','1967-01-01','F','30000017','paciente17@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101018','Paciente18','Prueba','1968-01-01','M','30000018','paciente18@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(2,'101019','Paciente19','Gómez','1969-01-01','F','30000019','paciente19@gmail.com','Bogotá');
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,sex,phone,email,city) VALUES(1,'101020','Paciente20','Prueba','1970-01-01','M','30000020',NULL,NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D1','Glaucoma 1','Tipo1');
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D2','Glaucoma 2','Tipo2');
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D3','Glaucoma 3','Tipo3');
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D4','Diagnóstico 4',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D5','Diagnóstico 5',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D6','Diagnóstico 6',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D7','Diagnóstico 7',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D8','Diagnóstico 8',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D9','Diagnóstico 9',NULL);
INSERT INTO diagnoses(code,name,glaucoma_type) VALUES('D10','Diagnóstico 10',NULL);
INSERT INTO medications(name) VALUES('Medicamento académico 1');
INSERT INTO medications(name) VALUES('Medicamento académico 2');
INSERT INTO medications(name) VALUES('Medicamento académico 3');
INSERT INTO medications(name) VALUES('Medicamento académico 4');
INSERT INTO medications(name) VALUES('Medicamento académico 5');
INSERT INTO medications(name) VALUES('Medicamento académico 6');
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(1,1,'2026-09-01 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(1,1,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(2,2,'2026-09-02 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(2,2,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(3,3,'2026-09-03 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(3,3,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(4,4,'2026-09-04 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(4,4,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(5,1,'2026-09-05 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(5,5,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(6,2,'2026-09-06 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(6,6,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(7,3,'2026-09-07 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(7,7,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(8,4,'2026-09-08 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(8,8,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(9,1,'2026-09-09 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(9,9,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(10,2,'2026-09-10 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(10,1,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(11,3,'2026-09-11 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(11,2,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(12,4,'2026-09-12 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(12,3,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(13,1,'2026-09-13 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(13,4,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(14,2,'2026-09-14 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(14,5,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(15,3,'2026-09-15 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(15,6,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(1,4,'2026-09-16 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(16,7,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(2,1,'2026-09-17 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(17,8,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(3,2,'2026-09-18 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(18,9,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(4,3,'2026-09-19 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(19,1,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(5,4,'2026-09-20 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(20,2,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(6,1,'2026-09-21 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(21,3,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(7,2,'2026-09-22 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(22,4,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(8,3,'2026-09-23 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(23,5,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(9,4,'2026-09-24 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(24,6,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(10,1,'2026-09-25 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(25,7,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(11,2,'2026-09-26 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(26,8,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(12,3,'2026-09-27 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(27,9,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(13,4,'2026-09-01 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(28,1,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(14,1,'2026-09-02 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(29,2,'OD',TRUE);
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(15,2,'2026-09-03 10:00:00','Seguimiento ficticio');
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(30,3,'OD',TRUE);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-01 11:00:00',13);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(2,'OI','2026-09-02 11:00:00',14);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(3,'OD','2026-09-03 11:00:00',15);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(4,'OI','2026-09-04 11:00:00',16);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(5,'OD','2026-09-05 11:00:00',17);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(6,'OI','2026-09-06 11:00:00',18);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(7,'OD','2026-09-07 11:00:00',19);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(8,'OI','2026-09-08 11:00:00',20);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(9,'OD','2026-09-09 11:00:00',21);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(10,'OI','2026-09-10 11:00:00',22);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(11,'OD','2026-09-11 11:00:00',23);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(12,'OI','2026-09-12 11:00:00',24);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(13,'OD','2026-09-13 11:00:00',25);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(14,'OI','2026-09-14 11:00:00',26);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(15,'OD','2026-09-15 11:00:00',27);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(16,'OI','2026-09-16 11:00:00',28);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(17,'OD','2026-09-17 11:00:00',29);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(18,'OI','2026-09-18 11:00:00',12);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(19,'OD','2026-09-19 11:00:00',13);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(20,'OI','2026-09-20 11:00:00',14);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(21,'OD','2026-09-21 11:00:00',15);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(22,'OI','2026-09-22 11:00:00',16);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(23,'OD','2026-09-23 11:00:00',17);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(24,'OI','2026-09-24 11:00:00',18);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(25,'OD','2026-09-25 11:00:00',19);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(26,'OI','2026-09-26 11:00:00',20);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(27,'OD','2026-09-27 11:00:00',21);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(28,'OI','2026-09-01 11:00:00',22);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(29,'OD','2026-09-02 11:00:00',23);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(30,'OI','2026-09-03 11:00:00',24);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-04 11:00:00',25);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(2,'OI','2026-09-05 11:00:00',26);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(3,'OD','2026-09-06 11:00:00',27);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(4,'OI','2026-09-07 11:00:00',28);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(5,'OD','2026-09-08 11:00:00',29);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(6,'OI','2026-09-09 11:00:00',12);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(7,'OD','2026-09-10 11:00:00',13);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(8,'OI','2026-09-11 11:00:00',14);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(9,'OD','2026-09-12 11:00:00',15);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(10,'OI','2026-09-13 11:00:00',16);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(11,'OD','2026-09-14 11:00:00',17);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(12,'OI','2026-09-15 11:00:00',18);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(13,'OD','2026-09-16 11:00:00',19);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(14,'OI','2026-09-17 11:00:00',20);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(15,'OD','2026-09-18 11:00:00',21);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(16,'OI','2026-09-19 11:00:00',22);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(17,'OD','2026-09-20 11:00:00',23);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(18,'OI','2026-09-21 11:00:00',24);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(19,'OD','2026-09-22 11:00:00',25);
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(20,'OI','2026-09-23 11:00:00',26);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(1,'OD','2026-09-25',66,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(1,'OI','2026-09-25',-2,2,71);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(2,'OD','2026-09-25',67,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(2,'OI','2026-09-25',-2,2,72);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(3,'OD','2026-09-25',68,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(3,'OI','2026-09-25',-2,2,73);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(4,'OD','2026-09-25',69,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(4,'OI','2026-09-25',-2,2,74);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(5,'OD','2026-09-25',70,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(5,'OI','2026-09-25',-2,2,75);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(6,'OD','2026-09-25',71,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(6,'OI','2026-09-25',-2,2,76);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(7,'OD','2026-09-25',72,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(7,'OI','2026-09-25',-2,2,77);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(8,'OD','2026-09-25',73,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(8,'OI','2026-09-25',-2,2,78);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(9,'OD','2026-09-25',74,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(9,'OI','2026-09-25',-2,2,79);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(10,'OD','2026-09-25',75,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(10,'OI','2026-09-25',-2,2,80);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(11,'OD','2026-09-25',76,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(11,'OI','2026-09-25',-2,2,81);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(12,'OD','2026-09-25',77,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(12,'OI','2026-09-25',-2,2,82);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(13,'OD','2026-09-25',78,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(13,'OI','2026-09-25',-2,2,83);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(14,'OD','2026-09-25',79,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(14,'OI','2026-09-25',-2,2,84);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(15,'OD','2026-09-25',80,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(15,'OI','2026-09-25',-2,2,85);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(16,'OD','2026-09-25',81,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(16,'OI','2026-09-25',-2,2,86);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(17,'OD','2026-09-25',82,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(17,'OI','2026-09-25',-2,2,87);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(18,'OD','2026-09-25',83,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(18,'OI','2026-09-25',-2,2,88);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(19,'OD','2026-09-25',84,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(19,'OI','2026-09-25',-2,2,89);
INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl,interpretation) VALUES(20,'OD','2026-09-25',85,'Ficticio');
INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(20,'OI','2026-09-25',-2,2,90);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(1,'OD','2026-09-25',501);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(1,2,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(2,'OD','2026-09-25',502);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(2,3,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(3,'OD','2026-09-25',503);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(3,4,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(4,'OD','2026-09-25',504);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(4,5,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(5,'OD','2026-09-25',505);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(5,1,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(6,'OD','2026-09-25',506);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(6,2,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(7,'OD','2026-09-25',507);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(7,3,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(8,'OD','2026-09-25',508);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(8,4,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(9,'OD','2026-09-25',509);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(9,5,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(10,'OD','2026-09-25',510);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(10,1,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(11,'OD','2026-09-25',511);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(11,2,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(12,'OD','2026-09-25',512);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(12,3,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(13,'OD','2026-09-25',513);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(13,4,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(14,'OD','2026-09-25',514);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(14,5,'AO','2026-09-25',TRUE);
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(15,'OD','2026-09-25',515);
INSERT INTO treatments(visit_id,medication_id,eye,start_date,active) VALUES(15,1,'AO','2026-09-25',TRUE);
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(1,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(1,1,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(2,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(2,2,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(3,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(3,3,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(4,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(4,4,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(5,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(5,5,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO glaucoma_records(patient_id,eye,opened_at) VALUES(6,'OD','2026-09-01');
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,target_pressure,clinical_status) VALUES(6,6,'2026-09-20',18,'Seguimiento ficticio');
INSERT INTO ophthalmologic_exams(visit_id,eye,exam_date,visual_acuity,optic_nerve_notes) VALUES(1,'OD','2026-09-20','20/20','Descripción ficticia');
INSERT INTO gonioscopy_exams(visit_id,eye,exam_date,result) VALUES(1,'OD','2026-09-20','Descripción ficticia');
INSERT INTO procedures(visit_id,eye,procedure_type,procedure_date) VALUES(1,'OD','QUIRURGICO:Ejemplo académico','2026-09-21');
INSERT INTO clinical_documents(clinical_history_id,document_type,file_name,file_uri) VALUES(1,'Informe','ejemplo.txt','pruebas/ejemplo.txt');
INSERT INTO medical_histories(patient_id,history_type,description) VALUES(1,'ALERGIA','Sustancia ficticia A'),(1,'FAMILIAR','Antecedente ficticio B');
```

<a id="punto-25"></a>

# 25. Consultas básicas

Deberán desarrollarse consultas como:

```
SELECT *
FROM patients;
```

Buscar por identificación:

```
SELECT *
FROM patients
WHERE document_number = '1098123456';
```

Ordenar:

```
SELECT *
FROM patients
ORDER BY last_name;
```

<a id="punto-26"></a>

# 26. Consultas intermedias

Deberán utilizarse:

```
JOIN
ORDER BY
GROUP BY
HAVING
DISTINCT
CASE
```

Ejemplo:

```
SELECT
    p.first_name,
    p.last_name,
    mv.visit_date
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id;
```

<a id="punto-27"></a>

# 27. Consultas avanzadas

Ejemplo:

Obtener cada paciente con su última consulta:

```
SELECT
    p.id,
    p.first_name,
    p.last_name,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id
GROUP BY
    p.id,
    p.first_name,
    p.last_name;
```

<a id="punto-28"></a>

# 28. Subconsultas

Ejemplo:

Obtener pacientes con más consultas que el promedio:

```
SELECT
    patient_id,
    total_visits
FROM (
    SELECT
        ch.patient_id,
        COUNT(*) AS total_visits
    FROM clinical_histories ch
    INNER JOIN medical_visits mv
        ON ch.id = mv.clinical_history_id
    GROUP BY ch.patient_id
) x
WHERE total_visits > (
    SELECT AVG(total_visits)
    FROM (
        SELECT
            COUNT(*) AS total_visits
        FROM clinical_histories ch
        INNER JOIN medical_visits mv
            ON ch.id = mv.clinical_history_id
        GROUP BY ch.patient_id
    ) y
);
```

<a id="punto-29"></a>

# 29. Funciones agregadas

El proyecto deberá utilizar:

```
COUNT
SUM
AVG
MIN
MAX
```

Ejemplo:

```
SELECT
    AVG(pressure) AS average_pressure,
    MIN(pressure) AS minimum_pressure,
    MAX(pressure) AS maximum_pressure
FROM intraocular_pressures;
```

<a id="punto-30"></a>

# 30. GROUP BY

Ejemplo:

```
SELECT
    eye,
    AVG(pressure) AS average_pressure
FROM intraocular_pressures
GROUP BY eye;
```

<a id="punto-31"></a>

# 31. HAVING

Ejemplo:

```
SELECT
    patient_id,
    COUNT(*) AS controls
FROM glaucoma_controls
GROUP BY patient_id
HAVING COUNT(*) >= 3;
```

<a id="punto-32"></a>

# 32. Procedimientos almacenados

Deberán implementarse procedimientos que representen operaciones del dominio.

Ejemplo conceptual:

```
sp_create_medical_visit
sp_register_intraocular_pressure
sp_register_diagnosis
sp_get_patient_history
```

Ejemplo:

```
DELIMITER $$

CREATE PROCEDURE sp_get_patient_visits(
    IN p_patient_id BIGINT
)
BEGIN

    SELECT
        mv.id,
        mv.visit_date,
        mv.reason
    FROM clinical_histories ch
    INNER JOIN medical_visits mv
        ON ch.id = mv.clinical_history_id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date DESC;

END $$

DELIMITER ;
```

<a id="punto-33"></a>

# 33. Funciones almacenadas

Ejemplo:

Calcular edad del paciente:

```
DELIMITER $$

CREATE FUNCTION fn_patient_age(
    p_birth_date DATE
)
RETURNS INT
DETERMINISTIC
BEGIN

    RETURN TIMESTAMPDIFF(
        YEAR,
        p_birth_date,
        CURDATE()
    );

END $$

DELIMITER ;
```

Consulta:

```
SELECT
    first_name,
    last_name,
    fn_patient_age(birth_date) AS age
FROM patients;
```

<a id="punto-34"></a>

# 34. Triggers

Se deberán utilizar triggers cuando exista una justificación clara.

Ejemplo:

Crear auditoría automática de cambios.

```
CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100),
    record_id BIGINT,
    action VARCHAR(20),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Trigger:

```
DELIMITER $$

CREATE TRIGGER trg_patient_after_update
AFTER UPDATE
ON patients
FOR EACH ROW
BEGIN

    INSERT INTO audit_logs(
        table_name,
        record_id,
        action
    )
    VALUES(
        'patients',
        NEW.id,
        'UPDATE'
    );

END $$

DELIMITER ;
```

<a id="punto-35"></a>

# 35. Otros triggers posibles

```
Auditar cambios en consultas
Auditar tratamientos
Registrar cambios de diagnóstico
Registrar eliminación lógica
Actualizar fechas de modificación
```

<a id="punto-36"></a>

# 36. Eventos

Si se desea incorporar eventos MySQL, podrían utilizarse para tareas como:

```
limpieza periódica de registros temporales
generación de resúmenes
actualización de tablas de indicadores
```

Ejemplo:

```
CREATE EVENT ev_daily_statistics
ON SCHEDULE EVERY 1 DAY
DO
    CALL sp_generate_daily_statistics();
```

<a id="punto-37"></a>

# 37. Vistas

También deberían incorporarse vistas.

Por ejemplo:

```
CREATE VIEW vw_patient_last_visit AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch
    ON p.id = ch.patient_id
INNER JOIN medical_visits mv
    ON ch.id = mv.clinical_history_id
GROUP BY
    p.id,
    p.first_name,
    p.last_name;
```

<a id="punto-38"></a>

# 38. Posibles consultas requeridas

El proyecto podría exigir al estudiante construir al menos:

```
10 consultas básicas
10 consultas intermedias
10 consultas avanzadas
5 subconsultas
5 consultas con funciones agregadas
3 vistas
3 procedimientos almacenados
3 funciones
3 triggers
1 evento programado
```

<a id="punto-39"></a>

# 39. Preguntas que la base de datos deberá responder

Algunos ejemplos:

1. ¿Cuántos pacientes se encuentran registrados?
2. ¿Cuántas consultas ha tenido cada paciente?
3. ¿Cuál fue la última consulta de un paciente?
4. ¿Qué pacientes tienen diagnóstico de glaucoma?
5. ¿Cuántos pacientes existen por tipo de glaucoma?
6. ¿Cuál es la presión intraocular promedio por ojo?
7. ¿Cuál es la presión máxima registrada por paciente?
8. ¿Qué pacientes tienen más de tres controles de glaucoma?
9. ¿Qué profesionales han atendido más pacientes?
10. ¿Qué medicamentos son utilizados con mayor frecuencia?
11. ¿Cuántos estudios OCT se realizaron por mes?
12. ¿Qué pacientes no han tenido consulta durante determinado período?
13. ¿Cuál es la evolución de la presión intraocular de un paciente?
14. ¿Qué pacientes presentan valores de PIO superiores a determinado umbral?
15. ¿Cuántos procedimientos se realizaron por tipo?

<a id="punto-40"></a>

# 40. Producto final esperado

El proyecto deberá entregar:

```
1. Formulación del problema
2. Identificación de entidades
3. Diccionario preliminar de datos
4. Modelo conceptual
5. DER
6. Modelo lógico
7. Evidencia de normalización:
   - 1FN
   - 2FN
   - 3FN
   - BCNF cuando aplique
   - 4FN
8. Modelo físico MySQL
9. Script DDL
10. Script de datos de prueba
11. Banco de 250 ejercicios MySQL
12. Evidencias de ejecución
```

**Respuesta / desarrollo:**

## Evidencia de normalización

| Etapa | Estructura inicial | Resultado aplicado |
|---|---|---|
| Sin normalizar | Una ficha con diagnostico1, diagnostico2, presion_od_1 y presion_od_2. | Los datos repetidos se separan en registros de consultas, diagnósticos y mediciones. |
| 1FN | Listas de diagnósticos y varias mediciones en una fila. | Cada diagnóstico asociado y cada medición ocupa una fila; cada medición corresponde a un ojo y una fecha. |
| 2FN | visit_diagnoses con clave (visit_id, diagnosis_id, eye) y diagnosis_name.<br>El nombre depende solo de diagnosis_id. | El nombre queda en diagnoses; visit_diagnoses conserva la asociación con la consulta. |
| 3FN | Una medición guarda visit_id y patient_id, aunque la consulta ya permite identificar al paciente. | La medición guarda visit_id; el paciente se obtiene mediante medical_visits y clinical_histories. |
| BCNF | Se revisan las dependencias funcionales de las tablas. | Los determinantes declarados son claves: id, claves alternativas UNIQUE no nulas y la clave compuesta de visit_diagnoses. |
| 4FN | Una fila combina alergias y antecedentes familiares independientes, o medicamentos y antecedentes independientes. | Los antecedentes se registran por separado en medical_histories y las prescripciones en treatments, sin guardar combinaciones entre esos conjuntos. |

### Comprobación de 4FN

Ejemplo de un paciente con dos alergias y dos antecedentes familiares independientes:

| Combinaciones de la estructura inicial | Alergias separadas | Antecedentes familiares separados |
|---|---|---|
| Alergia A / Familiar 1 | Alergia A | Familiar 1 |
| Alergia A / Familiar 2 | Alergia B | Familiar 2 |
| Alergia B / Familiar 1 | | |
| Alergia B / Familiar 2 | | |

En medical_histories se guardan cuatro registros: dos de tipo ALERGIA y dos de tipo FAMILIAR. Cada registro contiene un solo antecedente; no se almacena una fila por cada combinación.

## Vistas SQL

```sql
USE ophthalmology_modelo;
CREATE OR REPLACE VIEW v_intraocular_pressures AS SELECT x.*, ch.patient_id FROM intraocular_pressures x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_pachymetry_exams AS SELECT x.*, ch.patient_id FROM pachymetry_exams x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_gonioscopy_exams AS SELECT x.*, ch.patient_id FROM gonioscopy_exams x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_oct_exams AS SELECT x.*, ch.patient_id FROM oct_exams x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_visual_field_exams AS SELECT x.*, ch.patient_id FROM visual_field_exams x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_treatments AS SELECT x.*, ch.patient_id FROM treatments x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_procedures AS SELECT x.*, ch.patient_id FROM procedures x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_glaucoma_controls AS SELECT x.*, ch.patient_id FROM glaucoma_controls x JOIN medical_visits mv ON mv.id=x.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id;
CREATE OR REPLACE VIEW v_glaucoma_records AS SELECT r.*, (SELECT c.target_pressure FROM glaucoma_controls c WHERE c.glaucoma_record_id=r.id ORDER BY c.control_date DESC,c.id DESC LIMIT 1) target_pressure, (SELECT c.clinical_status FROM glaucoma_controls c WHERE c.glaucoma_record_id=r.id ORDER BY c.control_date DESC,c.id DESC LIMIT 1) clinical_status FROM glaucoma_records r;
CREATE OR REPLACE VIEW vw_patient_visit_count AS SELECT p.id patient_id,COUNT(mv.id) visit_count FROM patients p LEFT JOIN clinical_histories ch ON ch.patient_id=p.id LEFT JOIN medical_visits mv ON mv.clinical_history_id=ch.id GROUP BY p.id;
CREATE OR REPLACE VIEW vw_patient_last_visit AS SELECT p.id patient_id,MAX(mv.visit_date) last_visit FROM patients p LEFT JOIN clinical_histories ch ON ch.patient_id=p.id LEFT JOIN medical_visits mv ON mv.clinical_history_id=ch.id GROUP BY p.id;
CREATE OR REPLACE VIEW vw_active_treatments AS SELECT t.*,m.name medication FROM v_treatments t LEFT JOIN medications m ON m.id=t.medication_id WHERE t.active=TRUE;
```

### Evidencias reales

Se utilizó una instancia aislada de MySQL 8.0.46 en localhost:3308, con datos ubicados en el workspace. No se conectó a bases existentes. Los registros de la prueba están en [evidencias integradas](#evidencias-integradas). Docker no estaba activo y no se presenta como probado.

| Comprobación | Resultado real | Evidencia |
|---|---|---|
| DDL, vistas, rutinas, triggers y datos | Instalados sin errores | [Instalación](#e-instalacion) |
| 50 consultas + 50 subconsultas | 100 ejecuciones sin error | [Consultas](#e-consultas) |
| 50 procedimientos | 49 llamadas exitosas y rechazo esperado de historia duplicada en III.36 | [Procedimientos](#e-procedimientos) |
| 50 funciones | 50 llamadas exitosas | [Funciones](#e-funciones) |
| Triggers y restricciones | 56 escenarios con resultado esperado | [Escenarios](#e-triggers-y-restricciones) |
| Transacciones III.49–50 | Error de PIO revierte consulta/control | [ROLLBACK](#e-transacciones) |
| Modelo físico contra servidor | 23 tablas; nombres, tipos, NULL y PK coinciden sin diferencias | [Comparación](#e-coherencia-modelo-sql) |
| Lectura del .mdj en StarUML 7.1.1 | CLI cargó y exportó 24 diagramas | Registro de validación previa y [registro](#e-staruml) |

Se guardan también las [columnas reales](#e-columnas-reales) y el [resumen de MySQL](#e-resumen-mysql). Las pruebas comprueban los casos registrados; no constituyen una demostración de corrección ante todas las entradas ni pruebas de concurrencia/carga. La copia previa de un paciente no persiste cuando el borrado se rechaza: es una consecuencia de transacciones InnoDB, no una evidencia de eliminación realizada.

### Matriz de cumplimiento del producto esperado (§40)

| Producto | Solución en este documento | Estado |
|---|---|---|
| Formulación del problema | §1 | Incluida |
| Entidades y diccionario | §8–9 | Incluidos |
| Conceptual, lógico y DER | §10–12: diagramas incluidos | Lectura/exportación verificadas |
| Normalización 1FN–4FN y BCNF | §13–20 | Dependencias y supuestos explícitos |
| Modelo físico y DDL | §21–23 | Instalado y contrastado con modelo |
| Datos de prueba | §24 | Cargados |
| Banco de 250 ejercicios | Banco de 250 ejercicios | 250 enunciados y respuestas; evidencias de casos ejecutados |
| Evidencias de ejecución | §40: evidencias integradas | Registros reales, sin capturas inventadas |

### Pendientes y límites

No se realizaron pruebas de concurrencia ni carga. La comprobación previa de StarUML fue mediante su CLI. Los diagramas incluidos son representaciones textuales y corresponden al mismo esquema SQL.


### Código para generar evidencias del esquema

Para reproducir las evidencias, instalar el DDL del punto 21, las vistas SQL del punto 40, las funciones de la Parte V, los procedimientos de la Parte III, los triggers de la Parte IV y los datos del punto 24, en ese orden. Las llamadas y pruebas están junto a cada ejercicio.

```sql
USE ophthalmology_modelo;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SELECT VERSION() AS version_mysql;
SHOW TABLES;
SHOW CREATE TABLE patients;
SHOW CREATE TABLE clinical_histories;
SHOW CREATE TABLE visit_diagnoses;
SHOW CREATE TABLE glaucoma_controls;
SHOW INDEX FROM patients;
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT, EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA='ophthalmology_modelo'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
SELECT TABLE_TYPE, COUNT(*) AS total
FROM information_schema.TABLES WHERE TABLE_SCHEMA='ophthalmology_modelo' GROUP BY TABLE_TYPE;
SELECT ROUTINE_TYPE, COUNT(*) AS total
FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA='ophthalmology_modelo' GROUP BY ROUTINE_TYPE;
SELECT COUNT(*) AS total_triggers FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='ophthalmology_modelo';
SELECT COUNT(*) AS pacientes FROM patients;
SELECT COUNT(*) AS historias FROM clinical_histories;
SELECT COUNT(*) AS consultas FROM medical_visits;
SELECT * FROM audit_logs ORDER BY id DESC LIMIT 20;
SELECT * FROM notifications ORDER BY id DESC LIMIT 20;
```

<a id="evidencias-integradas"></a>

### Registros reales de la validación previa

Se conservan íntegros, dentro del mismo taller. No son resultados de una nueva ejecución.

<a id="e-coherencia-modelo-sql"></a>

#### coherencia-modelo-sql.json

<details>
<summary>Ver registro completo</summary>

```json
{
  "baseTables": 23,
  "physicalEntities": 23,
  "mismatches": []
}
```

</details>

<a id="e-columnas-reales"></a>

#### columnas-reales.tsv

<details>
<summary>Ver registro completo</summary>

```text
TABLE_NAME	COLUMN_NAME	COLUMN_TYPE	IS_NULLABLE	COLUMN_KEY	COLUMN_DEFAULT	EXTRA
audit_logs	id	bigint	NO	PRI	NULL	auto_increment
audit_logs	table_name	varchar(100)	NO		NULL	
audit_logs	record_key	varchar(150)	NO		NULL	
audit_logs	action	varchar(20)	NO		NULL	
audit_logs	old_data	json	YES		NULL	
audit_logs	new_data	json	YES		NULL	
audit_logs	changed_by	varchar(100)	NO		NULL	
audit_logs	changed_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
clinical_documents	id	bigint	NO	PRI	NULL	auto_increment
clinical_documents	clinical_history_id	bigint	NO	MUL	NULL	
clinical_documents	document_type	varchar(100)	NO		NULL	
clinical_documents	file_name	varchar(255)	NO		NULL	
clinical_documents	file_uri	varchar(500)	NO		NULL	
clinical_documents	created_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
clinical_histories	id	bigint	NO	PRI	NULL	auto_increment
clinical_histories	patient_id	bigint	NO	UNI	NULL	
clinical_histories	history_number	varchar(30)	NO	UNI	NULL	
clinical_histories	status	varchar(20)	NO		ACTIVE	
clinical_histories	created_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
diagnoses	id	bigint	NO	PRI	NULL	auto_increment
diagnoses	code	varchar(30)	NO	UNI	NULL	
diagnoses	name	varchar(150)	NO		NULL	
diagnoses	glaucoma_type	varchar(100)	YES		NULL	
document_types	id	bigint	NO	PRI	NULL	auto_increment
document_types	code	varchar(10)	NO	UNI	NULL	
document_types	name	varchar(50)	NO	UNI	NULL	
glaucoma_controls	id	bigint	NO	PRI	NULL	auto_increment
glaucoma_controls	glaucoma_record_id	bigint	NO	MUL	NULL	
glaucoma_controls	visit_id	bigint	NO	MUL	NULL	
glaucoma_controls	control_date	datetime	NO		NULL	
glaucoma_controls	glaucoma_type	varchar(100)	YES		NULL	
glaucoma_controls	target_pressure	decimal(5,2)	YES		NULL	
glaucoma_controls	clinical_status	varchar(100)	YES		NULL	
glaucoma_controls	notes	text	YES		NULL	
glaucoma_records	id	bigint	NO	PRI	NULL	auto_increment
glaucoma_records	patient_id	bigint	NO	MUL	NULL	
glaucoma_records	eye	char(2)	NO		NULL	
glaucoma_records	opened_at	datetime	NO		NULL	
glaucoma_records	closed_at	datetime	YES		NULL	
gonioscopy_exams	id	bigint	NO	PRI	NULL	auto_increment
gonioscopy_exams	visit_id	bigint	NO	MUL	NULL	
gonioscopy_exams	eye	char(2)	NO		NULL	
gonioscopy_exams	exam_date	datetime	NO		NULL	
gonioscopy_exams	result	text	YES		NULL	
healthcare_professionals	id	bigint	NO	PRI	NULL	auto_increment
healthcare_professionals	specialty_id	bigint	NO	MUL	NULL	
healthcare_professionals	document_number	varchar(30)	NO	UNI	NULL	
healthcare_professionals	first_name	varchar(100)	NO		NULL	
healthcare_professionals	last_name	varchar(100)	NO		NULL	
healthcare_professionals	active	tinyint(1)	NO		1	
intraocular_pressures	id	bigint	NO	PRI	NULL	auto_increment
intraocular_pressures	visit_id	bigint	NO	MUL	NULL	
intraocular_pressures	eye	char(2)	NO		NULL	
intraocular_pressures	measured_at	datetime	NO		NULL	
intraocular_pressures	pressure	decimal(5,2)	NO		NULL	
medical_histories	id	bigint	NO	PRI	NULL	auto_increment
medical_histories	patient_id	bigint	NO	MUL	NULL	
medical_histories	history_type	varchar(100)	NO		NULL	
medical_histories	description	text	NO		NULL	
medical_histories	recorded_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
medical_visits	updated_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
medical_visits	id	bigint	NO	PRI	NULL	auto_increment
medical_visits	clinical_history_id	bigint	NO	MUL	NULL	
medical_visits	professional_id	bigint	NO	MUL	NULL	
medical_visits	visit_date	datetime	NO		NULL	
medical_visits	reason	text	YES		NULL	
medical_visits	assessment	text	YES		NULL	
medical_visits	plan	text	YES		NULL	
medical_visits	observations	text	YES		NULL	
medical_visits	status	varchar(20)	NO		OPEN	
medications	id	bigint	NO	PRI	NULL	auto_increment
medications	name	varchar(150)	NO	UNI	NULL	
medications	active	tinyint(1)	NO		1	
notifications	id	bigint	NO	PRI	NULL	auto_increment
notifications	patient_id	bigint	NO	MUL	NULL	
notifications	message	varchar(255)	NO		NULL	
notifications	created_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
oct_exams	id	bigint	NO	PRI	NULL	auto_increment
oct_exams	visit_id	bigint	NO	MUL	NULL	
oct_exams	eye	char(2)	NO		NULL	
oct_exams	exam_date	datetime	NO		NULL	
oct_exams	rnfl	decimal(7,2)	YES		NULL	
oct_exams	interpretation	text	YES		NULL	
oct_exams	validated	tinyint(1)	NO		0	
ophthalmologic_exams	id	bigint	NO	PRI	NULL	auto_increment
ophthalmologic_exams	visit_id	bigint	NO	MUL	NULL	
ophthalmologic_exams	exam_date	datetime	NO		NULL	
ophthalmologic_exams	eye	char(2)	NO		NULL	
ophthalmologic_exams	visual_acuity	varchar(30)	YES		NULL	
ophthalmologic_exams	optic_nerve_notes	text	YES		NULL	
ophthalmologic_exams	notes	text	YES		NULL	
pachymetry_exams	id	bigint	NO	PRI	NULL	auto_increment
pachymetry_exams	visit_id	bigint	NO	MUL	NULL	
pachymetry_exams	eye	char(2)	NO		NULL	
pachymetry_exams	exam_date	datetime	NO		NULL	
pachymetry_exams	corneal_thickness	decimal(7,2)	NO		NULL	
patients	updated_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
patients	id	bigint	NO	PRI	NULL	auto_increment
patients	document_type_id	bigint	NO	MUL	NULL	
patients	document_number	varchar(30)	NO		NULL	
patients	first_name	varchar(100)	NO		NULL	
patients	last_name	varchar(100)	NO		NULL	
patients	birth_date	date	NO		NULL	
patients	sex	varchar(20)	YES		NULL	
patients	phone	varchar(30)	YES		NULL	
patients	email	varchar(150)	YES		NULL	
patients	city	varchar(100)	YES		NULL	
patients	created_at	datetime	NO		CURRENT_TIMESTAMP	DEFAULT_GENERATED
procedures	id	bigint	NO	PRI	NULL	auto_increment
procedures	visit_id	bigint	NO	MUL	NULL	
procedures	eye	char(2)	NO		NULL	
procedures	procedure_type	varchar(150)	NO		NULL	
procedures	procedure_date	datetime	NO		NULL	
procedures	notes	text	YES		NULL	
specialties	id	bigint	NO	PRI	NULL	auto_increment
specialties	name	varchar(100)	NO	UNI	NULL	
treatments	id	bigint	NO	PRI	NULL	auto_increment
treatments	visit_id	bigint	NO	MUL	NULL	
treatments	medication_id	bigint	YES	MUL	NULL	
treatments	eye	char(2)	NO		NULL	
treatments	start_date	date	NO		NULL	
treatments	end_date	date	YES		NULL	
treatments	active	tinyint(1)	NO		1	
treatments	dose	varchar(100)	YES		NULL	
treatments	frequency	varchar(100)	YES		NULL	
treatments	notes	text	YES		NULL	
v_glaucoma_controls	id	bigint	NO		0	
v_glaucoma_controls	glaucoma_record_id	bigint	NO		NULL	
v_glaucoma_controls	visit_id	bigint	NO		NULL	
v_glaucoma_controls	control_date	datetime	NO		NULL	
v_glaucoma_controls	glaucoma_type	varchar(100)	YES		NULL	
v_glaucoma_controls	target_pressure	decimal(5,2)	YES		NULL	
v_glaucoma_controls	clinical_status	varchar(100)	YES		NULL	
v_glaucoma_controls	notes	text	YES		NULL	
v_glaucoma_controls	patient_id	bigint	NO		NULL	
v_glaucoma_records	id	bigint	NO		0	
v_glaucoma_records	patient_id	bigint	NO		NULL	
v_glaucoma_records	eye	char(2)	NO		NULL	
v_glaucoma_records	opened_at	datetime	NO		NULL	
v_glaucoma_records	closed_at	datetime	YES		NULL	
v_glaucoma_records	target_pressure	decimal(5,2)	YES		NULL	
v_glaucoma_records	clinical_status	varchar(100)	YES		NULL	
v_gonioscopy_exams	id	bigint	NO		0	
v_gonioscopy_exams	visit_id	bigint	NO		NULL	
v_gonioscopy_exams	eye	char(2)	NO		NULL	
v_gonioscopy_exams	exam_date	datetime	NO		NULL	
v_gonioscopy_exams	result	text	YES		NULL	
v_gonioscopy_exams	patient_id	bigint	NO		NULL	
v_intraocular_pressures	id	bigint	NO		0	
v_intraocular_pressures	visit_id	bigint	NO		NULL	
v_intraocular_pressures	eye	char(2)	NO		NULL	
v_intraocular_pressures	measured_at	datetime	NO		NULL	
v_intraocular_pressures	pressure	decimal(5,2)	NO		NULL	
v_intraocular_pressures	patient_id	bigint	NO		NULL	
v_oct_exams	id	bigint	NO		0	
v_oct_exams	visit_id	bigint	NO		NULL	
v_oct_exams	eye	char(2)	NO		NULL	
v_oct_exams	exam_date	datetime	NO		NULL	
v_oct_exams	rnfl	decimal(7,2)	YES		NULL	
v_oct_exams	interpretation	text	YES		NULL	
v_oct_exams	validated	tinyint(1)	NO		0	
v_oct_exams	patient_id	bigint	NO		NULL	
v_pachymetry_exams	id	bigint	NO		0	
v_pachymetry_exams	visit_id	bigint	NO		NULL	
v_pachymetry_exams	eye	char(2)	NO		NULL	
v_pachymetry_exams	exam_date	datetime	NO		NULL	
v_pachymetry_exams	corneal_thickness	decimal(7,2)	NO		NULL	
v_pachymetry_exams	patient_id	bigint	NO		NULL	
v_procedures	id	bigint	NO		0	
v_procedures	visit_id	bigint	NO		NULL	
v_procedures	eye	char(2)	NO		NULL	
v_procedures	procedure_type	varchar(150)	NO		NULL	
v_procedures	procedure_date	datetime	NO		NULL	
v_procedures	notes	text	YES		NULL	
v_procedures	patient_id	bigint	NO		NULL	
v_treatments	id	bigint	NO		0	
v_treatments	visit_id	bigint	NO		NULL	
v_treatments	medication_id	bigint	YES		NULL	
v_treatments	eye	char(2)	NO		NULL	
v_treatments	start_date	date	NO		NULL	
v_treatments	end_date	date	YES		NULL	
v_treatments	active	tinyint(1)	NO		1	
v_treatments	dose	varchar(100)	YES		NULL	
v_treatments	frequency	varchar(100)	YES		NULL	
v_treatments	notes	text	YES		NULL	
v_treatments	patient_id	bigint	NO		NULL	
v_visual_field_exams	id	bigint	NO		0	
v_visual_field_exams	visit_id	bigint	NO		NULL	
v_visual_field_exams	eye	char(2)	NO		NULL	
v_visual_field_exams	exam_date	datetime	NO		NULL	
v_visual_field_exams	md	decimal(7,2)	YES		NULL	
v_visual_field_exams	psd	decimal(7,2)	YES		NULL	
v_visual_field_exams	vfi	decimal(5,2)	YES		NULL	
v_visual_field_exams	interpretation	text	YES		NULL	
v_visual_field_exams	patient_id	bigint	NO		NULL	
visit_diagnoses	visit_id	bigint	NO	PRI	NULL	
visit_diagnoses	diagnosis_id	bigint	NO	PRI	NULL	
visit_diagnoses	eye	char(2)	NO	PRI	NULL	
visit_diagnoses	is_primary	tinyint(1)	NO		0	
visit_diagnoses	primary_visit_eye	varchar(80)	YES	UNI	NULL	STORED GENERATED
visual_field_exams	id	bigint	NO	PRI	NULL	auto_increment
visual_field_exams	visit_id	bigint	NO	MUL	NULL	
visual_field_exams	eye	char(2)	NO		NULL	
visual_field_exams	exam_date	datetime	NO		NULL	
visual_field_exams	md	decimal(7,2)	YES		NULL	
visual_field_exams	psd	decimal(7,2)	YES		NULL	
visual_field_exams	vfi	decimal(5,2)	YES		NULL	
visual_field_exams	interpretation	text	YES		NULL	
vw_active_treatments	id	bigint	NO		0	
vw_active_treatments	visit_id	bigint	NO		NULL	
vw_active_treatments	medication_id	bigint	YES		NULL	
vw_active_treatments	eye	char(2)	NO		NULL	
vw_active_treatments	start_date	date	NO		NULL	
vw_active_treatments	end_date	date	YES		NULL	
vw_active_treatments	active	tinyint(1)	NO		1	
vw_active_treatments	dose	varchar(100)	YES		NULL	
vw_active_treatments	frequency	varchar(100)	YES		NULL	
vw_active_treatments	notes	text	YES		NULL	
vw_active_treatments	patient_id	bigint	NO		NULL	
vw_active_treatments	medication	varchar(150)	YES		NULL	
vw_patient_last_visit	patient_id	bigint	NO		0	
vw_patient_last_visit	last_visit	datetime	YES		NULL	
vw_patient_visit_count	patient_id	bigint	NO		0	
vw_patient_visit_count	visit_count	bigint	NO		0
```

</details>

<a id="e-consultas"></a>

#### consultas.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "parte": 1,
    "n": 1,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 2,
    "status": 0,
    "stdout": "document_number\tfirst_name\tlast_name\r\n101001\tPaciente1\tGómez\r\n101002\tPaciente2\tPrueba\r\n101003\tPaciente3\tGómez\r\n101004\tPaciente4\tPrueba\r\n101005\tPaciente5\tGómez\r\n101006\tPaciente6\tPrueba\r\n101007\tPaciente7\tGómez\r\n101008\tPaciente8\tPrueba\r\n101009\tPaciente9\tGómez\r\n101010\tPaciente10\tPrueba\r\n101011\tPaciente11\tGómez\r\n101012\tPaciente12\tPrueba\r\n101013\tPaciente13\tGómez\r\n101014\tPaciente14\tPrueba\r\n101015\tPaciente15\tGómez\r\n101016\tPaciente16\tPrueba\r\n101017\tPaciente17\tGómez\r\n101018\tPaciente18\tPrueba\r\n101019\tPaciente19\tGómez\r\n101020\tPaciente20\tPrueba\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 3,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n1\t2\tPRO1\tProfesional1\tPrueba\t1\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n3\t2\tPRO3\tProfesional3\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n5\t2\tPRO5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 4,
    "status": 0,
    "stdout": "id\tcode\tname\tglaucoma_type\r\n1\tD1\tGlaucoma 1\tTipo1\r\n2\tD2\tGlaucoma 2\tTipo2\r\n3\tD3\tGlaucoma 3\tTipo3\r\n4\tD4\tDiagnóstico 4\tNULL\r\n5\tD5\tDiagnóstico 5\tNULL\r\n6\tD6\tDiagnóstico 6\tNULL\r\n7\tD7\tDiagnóstico 7\tNULL\r\n8\tD8\tDiagnóstico 8\tNULL\r\n9\tD9\tDiagnóstico 9\tNULL\r\n10\tD10\tDiagnóstico 10\tNULL\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 5,
    "status": 0,
    "stdout": "id\tpatient_id\thistory_number\tstatus\tcreated_at\r\n1\t1\tHC-1\tACTIVE\t2026-10-08 20:55:28\r\n2\t2\tHC-2\tACTIVE\t2026-10-08 20:55:28\r\n3\t3\tHC-3\tACTIVE\t2026-10-08 20:55:28\r\n4\t4\tHC-4\tACTIVE\t2026-10-08 20:55:28\r\n5\t5\tHC-5\tACTIVE\t2026-10-08 20:55:28\r\n6\t6\tHC-6\tACTIVE\t2026-10-08 20:55:28\r\n7\t7\tHC-7\tACTIVE\t2026-10-08 20:55:28\r\n8\t8\tHC-8\tACTIVE\t2026-10-08 20:55:28\r\n9\t9\tHC-9\tACTIVE\t2026-10-08 20:55:28\r\n10\t10\tHC-10\tACTIVE\t2026-10-08 20:55:28\r\n11\t11\tHC-11\tACTIVE\t2026-10-08 20:55:28\r\n12\t12\tHC-12\tACTIVE\t2026-10-08 20:55:28\r\n13\t13\tHC-13\tACTIVE\t2026-10-08 20:55:28\r\n14\t14\tHC-14\tACTIVE\t2026-10-08 20:55:28\r\n15\t15\tHC-15\tACTIVE\t2026-10-08 20:55:28\r\n16\t16\tHC-16\tACTIVE\t2026-10-08 20:55:28\r\n17\t17\tHC-17\tACTIVE\t2026-10-08 20:55:28\r\n18\t18\tHC-18\tACTIVE\t2026-10-08 20:55:28\r\n19\t19\tHC-19\tACTIVE\t2026-10-08 20:55:28\r\n20\t20\tHC-20\tACTIVE\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 6,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 7,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 8,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 9,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 10,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 11,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 12,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 13,
    "status": 0,
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\r\n2026-10-08 20:55:28\t1\t1\t1\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t2\t2\t2\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t3\t3\t3\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t4\t4\t4\t2026-09-04 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t5\t5\t1\t2026-09-05 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t6\t6\t2\t2026-09-06 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t7\t7\t3\t2026-09-07 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t8\t8\t4\t2026-09-08 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t9\t9\t1\t2026-09-09 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t10\t10\t2\t2026-09-10 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t11\t11\t3\t2026-09-11 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t12\t12\t4\t2026-09-12 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t13\t13\t1\t2026-09-13 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t14\t14\t2\t2026-09-14 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t15\t15\t3\t2026-09-15 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t17\t2\t1\t2026-09-17 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t18\t3\t2\t2026-09-18 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t19\t4\t3\t2026-09-19 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t20\t5\t4\t2026-09-20 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t21\t6\t1\t2026-09-21 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t22\t7\t2\t2026-09-22 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t23\t8\t3\t2026-09-23 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t24\t9\t4\t2026-09-24 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t25\t10\t1\t2026-09-25 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t26\t11\t2\t2026-09-26 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t27\t12\t3\t2026-09-27 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t28\t13\t4\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t29\t14\t1\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t30\t15\t2\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 14,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 15,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n9\t9\tOD\t2026-09-09 11:00:00\t21.00\t9\r\n10\t10\tOI\t2026-09-10 11:00:00\t22.00\t10\r\n11\t11\tOD\t2026-09-11 11:00:00\t23.00\t11\r\n12\t12\tOI\t2026-09-12 11:00:00\t24.00\t12\r\n13\t13\tOD\t2026-09-13 11:00:00\t25.00\t13\r\n14\t14\tOI\t2026-09-14 11:00:00\t26.00\t14\r\n15\t15\tOD\t2026-09-15 11:00:00\t27.00\t15\r\n16\t16\tOI\t2026-09-16 11:00:00\t28.00\t1\r\n17\t17\tOD\t2026-09-17 11:00:00\t29.00\t2\r\n27\t27\tOD\t2026-09-27 11:00:00\t21.00\t12\r\n28\t28\tOI\t2026-09-01 11:00:00\t22.00\t13\r\n29\t29\tOD\t2026-09-02 11:00:00\t23.00\t14\r\n30\t30\tOI\t2026-09-03 11:00:00\t24.00\t15\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n32\t2\tOI\t2026-09-05 11:00:00\t26.00\t2\r\n33\t3\tOD\t2026-09-06 11:00:00\t27.00\t3\r\n34\t4\tOI\t2026-09-07 11:00:00\t28.00\t4\r\n35\t5\tOD\t2026-09-08 11:00:00\t29.00\t5\r\n45\t15\tOD\t2026-09-18 11:00:00\t21.00\t15\r\n46\t16\tOI\t2026-09-19 11:00:00\t22.00\t1\r\n47\t17\tOD\t2026-09-20 11:00:00\t23.00\t2\r\n48\t18\tOI\t2026-09-21 11:00:00\t24.00\t3\r\n49\t19\tOD\t2026-09-22 11:00:00\t25.00\t4\r\n50\t20\tOI\t2026-09-23 11:00:00\t26.00\t5\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 16,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n1\t1\tOD\t2026-09-01 11:00:00\t13.00\t1\r\n3\t3\tOD\t2026-09-03 11:00:00\t15.00\t3\r\n5\t5\tOD\t2026-09-05 11:00:00\t17.00\t5\r\n7\t7\tOD\t2026-09-07 11:00:00\t19.00\t7\r\n9\t9\tOD\t2026-09-09 11:00:00\t21.00\t9\r\n11\t11\tOD\t2026-09-11 11:00:00\t23.00\t11\r\n13\t13\tOD\t2026-09-13 11:00:00\t25.00\t13\r\n15\t15\tOD\t2026-09-15 11:00:00\t27.00\t15\r\n17\t17\tOD\t2026-09-17 11:00:00\t29.00\t2\r\n19\t19\tOD\t2026-09-19 11:00:00\t13.00\t4\r\n21\t21\tOD\t2026-09-21 11:00:00\t15.00\t6\r\n23\t23\tOD\t2026-09-23 11:00:00\t17.00\t8\r\n25\t25\tOD\t2026-09-25 11:00:00\t19.00\t10\r\n27\t27\tOD\t2026-09-27 11:00:00\t21.00\t12\r\n29\t29\tOD\t2026-09-02 11:00:00\t23.00\t14\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n33\t3\tOD\t2026-09-06 11:00:00\t27.00\t3\r\n35\t5\tOD\t2026-09-08 11:00:00\t29.00\t5\r\n37\t7\tOD\t2026-09-10 11:00:00\t13.00\t7\r\n39\t9\tOD\t2026-09-12 11:00:00\t15.00\t9\r\n41\t11\tOD\t2026-09-14 11:00:00\t17.00\t11\r\n43\t13\tOD\t2026-09-16 11:00:00\t19.00\t13\r\n45\t15\tOD\t2026-09-18 11:00:00\t21.00\t15\r\n47\t17\tOD\t2026-09-20 11:00:00\t23.00\t2\r\n49\t19\tOD\t2026-09-22 11:00:00\t25.00\t4\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 17,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n2\t2\tOI\t2026-09-02 11:00:00\t14.00\t2\r\n4\t4\tOI\t2026-09-04 11:00:00\t16.00\t4\r\n6\t6\tOI\t2026-09-06 11:00:00\t18.00\t6\r\n8\t8\tOI\t2026-09-08 11:00:00\t20.00\t8\r\n10\t10\tOI\t2026-09-10 11:00:00\t22.00\t10\r\n12\t12\tOI\t2026-09-12 11:00:00\t24.00\t12\r\n14\t14\tOI\t2026-09-14 11:00:00\t26.00\t14\r\n16\t16\tOI\t2026-09-16 11:00:00\t28.00\t1\r\n18\t18\tOI\t2026-09-18 11:00:00\t12.00\t3\r\n20\t20\tOI\t2026-09-20 11:00:00\t14.00\t5\r\n22\t22\tOI\t2026-09-22 11:00:00\t16.00\t7\r\n24\t24\tOI\t2026-09-24 11:00:00\t18.00\t9\r\n26\t26\tOI\t2026-09-26 11:00:00\t20.00\t11\r\n28\t28\tOI\t2026-09-01 11:00:00\t22.00\t13\r\n30\t30\tOI\t2026-09-03 11:00:00\t24.00\t15\r\n32\t2\tOI\t2026-09-05 11:00:00\t26.00\t2\r\n34\t4\tOI\t2026-09-07 11:00:00\t28.00\t4\r\n36\t6\tOI\t2026-09-09 11:00:00\t12.00\t6\r\n38\t8\tOI\t2026-09-11 11:00:00\t14.00\t8\r\n40\t10\tOI\t2026-09-13 11:00:00\t16.00\t10\r\n42\t12\tOI\t2026-09-15 11:00:00\t18.00\t12\r\n44\t14\tOI\t2026-09-17 11:00:00\t20.00\t14\r\n46\t16\tOI\t2026-09-19 11:00:00\t22.00\t1\r\n48\t18\tOI\t2026-09-21 11:00:00\t24.00\t3\r\n50\t20\tOI\t2026-09-23 11:00:00\t26.00\t5\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 18,
    "status": 0,
    "stdout": "id\tvisit_id\tmedication_id\teye\tstart_date\tend_date\tactive\tdose\tfrequency\tnotes\tpatient_id\r\n1\t1\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t1\r\n2\t2\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t2\r\n3\t3\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t3\r\n4\t4\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t4\r\n5\t5\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t5\r\n6\t6\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t6\r\n7\t7\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t7\r\n8\t8\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t8\r\n9\t9\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t9\r\n10\t10\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t10\r\n11\t11\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t11\r\n12\t12\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t12\r\n13\t13\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t13\r\n14\t14\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t14\r\n15\t15\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 19,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 20,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tprocedure_type\tprocedure_date\tnotes\tpatient_id\r\n1\t1\tOD\tQUIRURGICO:Ejemplo académico\t2026-09-21 00:00:00\tNULL\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 21,
    "status": 0,
    "stdout": "first_name\tlast_name\thistory_number\r\nPaciente1\tGómez\tHC-1\r\nPaciente2\tPrueba\tHC-2\r\nPaciente3\tGómez\tHC-3\r\nPaciente4\tPrueba\tHC-4\r\nPaciente5\tGómez\tHC-5\r\nPaciente6\tPrueba\tHC-6\r\nPaciente7\tGómez\tHC-7\r\nPaciente8\tPrueba\tHC-8\r\nPaciente9\tGómez\tHC-9\r\nPaciente10\tPrueba\tHC-10\r\nPaciente11\tGómez\tHC-11\r\nPaciente12\tPrueba\tHC-12\r\nPaciente13\tGómez\tHC-13\r\nPaciente14\tPrueba\tHC-14\r\nPaciente15\tGómez\tHC-15\r\nPaciente16\tPrueba\tHC-16\r\nPaciente17\tGómez\tHC-17\r\nPaciente18\tPrueba\tHC-18\r\nPaciente19\tGómez\tHC-19\r\nPaciente20\tPrueba\tHC-20\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 22,
    "status": 0,
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\tpatient\r\n2026-10-08 20:55:28\t1\t1\t1\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente1 Gómez\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente1 Gómez\r\n2026-10-08 20:55:28\t2\t2\t2\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente2 Prueba\r\n2026-10-08 20:55:28\t17\t2\t1\t2026-09-17 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente2 Prueba\r\n2026-10-08 20:55:28\t3\t3\t3\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente3 Gómez\r\n2026-10-08 20:55:28\t18\t3\t2\t2026-09-18 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente3 Gómez\r\n2026-10-08 20:55:28\t4\t4\t4\t2026-09-04 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente4 Prueba\r\n2026-10-08 20:55:28\t19\t4\t3\t2026-09-19 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente4 Prueba\r\n2026-10-08 20:55:28\t5\t5\t1\t2026-09-05 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente5 Gómez\r\n2026-10-08 20:55:28\t20\t5\t4\t2026-09-20 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente5 Gómez\r\n2026-10-08 20:55:28\t6\t6\t2\t2026-09-06 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente6 Prueba\r\n2026-10-08 20:55:28\t21\t6\t1\t2026-09-21 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente6 Prueba\r\n2026-10-08 20:55:28\t7\t7\t3\t2026-09-07 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente7 Gómez\r\n2026-10-08 20:55:28\t22\t7\t2\t2026-09-22 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente7 Gómez\r\n2026-10-08 20:55:28\t8\t8\t4\t2026-09-08 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente8 Prueba\r\n2026-10-08 20:55:28\t23\t8\t3\t2026-09-23 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente8 Prueba\r\n2026-10-08 20:55:28\t9\t9\t1\t2026-09-09 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente9 Gómez\r\n2026-10-08 20:55:28\t24\t9\t4\t2026-09-24 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente9 Gómez\r\n2026-10-08 20:55:28\t10\t10\t2\t2026-09-10 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente10 Prueba\r\n2026-10-08 20:55:28\t25\t10\t1\t2026-09-25 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente10 Prueba\r\n2026-10-08 20:55:28\t11\t11\t3\t2026-09-11 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente11 Gómez\r\n2026-10-08 20:55:28\t26\t11\t2\t2026-09-26 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente11 Gómez\r\n2026-10-08 20:55:28\t12\t12\t4\t2026-09-12 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente12 Prueba\r\n2026-10-08 20:55:28\t27\t12\t3\t2026-09-27 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente12 Prueba\r\n2026-10-08 20:55:28\t13\t13\t1\t2026-09-13 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente13 Gómez\r\n2026-10-08 20:55:28\t28\t13\t4\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente13 Gómez\r\n2026-10-08 20:55:28\t14\t14\t2\t2026-09-14 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente14 Prueba\r\n2026-10-08 20:55:28\t29\t14\t1\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente14 Prueba\r\n2026-10-08 20:55:28\t15\t15\t3\t2026-09-15 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente15 Gómez\r\n2026-10-08 20:55:28\t30\t15\t2\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tPaciente15 Gómez\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 23,
    "status": 0,
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\tprofessional\r\n2026-10-08 20:55:28\t1\t1\t1\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t5\t5\t1\t2026-09-05 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t9\t9\t1\t2026-09-09 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t13\t13\t1\t2026-09-13 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t17\t2\t1\t2026-09-17 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t21\t6\t1\t2026-09-21 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t25\t10\t1\t2026-09-25 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t29\t14\t1\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional1 Prueba\r\n2026-10-08 20:55:28\t2\t2\t2\t2026-09-02 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t6\t6\t2\t2026-09-06 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t10\t10\t2\t2026-09-10 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t14\t14\t2\t2026-09-14 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t18\t3\t2\t2026-09-18 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t22\t7\t2\t2026-09-22 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t26\t11\t2\t2026-09-26 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t30\t15\t2\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional2 Prueba\r\n2026-10-08 20:55:28\t3\t3\t3\t2026-09-03 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t7\t7\t3\t2026-09-07 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t11\t11\t3\t2026-09-11 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t15\t15\t3\t2026-09-15 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t19\t4\t3\t2026-09-19 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t23\t8\t3\t2026-09-23 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t27\t12\t3\t2026-09-27 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional3 Prueba\r\n2026-10-08 20:55:28\t4\t4\t4\t2026-09-04 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t8\t8\t4\t2026-09-08 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t12\t12\t4\t2026-09-12 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t20\t5\t4\t2026-09-20 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t24\t9\t4\t2026-09-24 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n2026-10-08 20:55:28\t28\t13\t4\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\tProfesional4 Prueba\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 24,
    "status": 0,
    "stdout": "first_name\tlast_name\tvisit_date\r\nPaciente1\tGómez\t2026-09-01 10:00:00\r\nPaciente1\tGómez\t2026-09-16 10:00:00\r\nPaciente2\tPrueba\t2026-09-02 10:00:00\r\nPaciente2\tPrueba\t2026-09-17 10:00:00\r\nPaciente3\tGómez\t2026-09-03 10:00:00\r\nPaciente3\tGómez\t2026-09-18 10:00:00\r\nPaciente4\tPrueba\t2026-09-04 10:00:00\r\nPaciente4\tPrueba\t2026-09-19 10:00:00\r\nPaciente5\tGómez\t2026-09-05 10:00:00\r\nPaciente5\tGómez\t2026-09-20 10:00:00\r\nPaciente6\tPrueba\t2026-09-06 10:00:00\r\nPaciente6\tPrueba\t2026-09-21 10:00:00\r\nPaciente7\tGómez\t2026-09-07 10:00:00\r\nPaciente7\tGómez\t2026-09-22 10:00:00\r\nPaciente8\tPrueba\t2026-09-08 10:00:00\r\nPaciente8\tPrueba\t2026-09-23 10:00:00\r\nPaciente9\tGómez\t2026-09-09 10:00:00\r\nPaciente9\tGómez\t2026-09-24 10:00:00\r\nPaciente10\tPrueba\t2026-09-10 10:00:00\r\nPaciente10\tPrueba\t2026-09-25 10:00:00\r\nPaciente11\tGómez\t2026-09-11 10:00:00\r\nPaciente11\tGómez\t2026-09-26 10:00:00\r\nPaciente12\tPrueba\t2026-09-12 10:00:00\r\nPaciente12\tPrueba\t2026-09-27 10:00:00\r\nPaciente13\tGómez\t2026-09-13 10:00:00\r\nPaciente13\tGómez\t2026-09-01 10:00:00\r\nPaciente14\tPrueba\t2026-09-14 10:00:00\r\nPaciente14\tPrueba\t2026-09-02 10:00:00\r\nPaciente15\tGómez\t2026-09-15 10:00:00\r\nPaciente15\tGómez\t2026-09-03 10:00:00\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 25,
    "status": 0,
    "stdout": "id\tvisit_date\tcode\tname\r\n1\t2026-09-01 10:00:00\tD1\tGlaucoma 1\r\n10\t2026-09-10 10:00:00\tD1\tGlaucoma 1\r\n19\t2026-09-19 10:00:00\tD1\tGlaucoma 1\r\n28\t2026-09-01 10:00:00\tD1\tGlaucoma 1\r\n2\t2026-09-02 10:00:00\tD2\tGlaucoma 2\r\n11\t2026-09-11 10:00:00\tD2\tGlaucoma 2\r\n20\t2026-09-20 10:00:00\tD2\tGlaucoma 2\r\n29\t2026-09-02 10:00:00\tD2\tGlaucoma 2\r\n3\t2026-09-03 10:00:00\tD3\tGlaucoma 3\r\n12\t2026-09-12 10:00:00\tD3\tGlaucoma 3\r\n21\t2026-09-21 10:00:00\tD3\tGlaucoma 3\r\n30\t2026-09-03 10:00:00\tD3\tGlaucoma 3\r\n4\t2026-09-04 10:00:00\tD4\tDiagnóstico 4\r\n13\t2026-09-13 10:00:00\tD4\tDiagnóstico 4\r\n22\t2026-09-22 10:00:00\tD4\tDiagnóstico 4\r\n5\t2026-09-05 10:00:00\tD5\tDiagnóstico 5\r\n14\t2026-09-14 10:00:00\tD5\tDiagnóstico 5\r\n23\t2026-09-23 10:00:00\tD5\tDiagnóstico 5\r\n6\t2026-09-06 10:00:00\tD6\tDiagnóstico 6\r\n15\t2026-09-15 10:00:00\tD6\tDiagnóstico 6\r\n24\t2026-09-24 10:00:00\tD6\tDiagnóstico 6\r\n7\t2026-09-07 10:00:00\tD7\tDiagnóstico 7\r\n16\t2026-09-16 10:00:00\tD7\tDiagnóstico 7\r\n25\t2026-09-25 10:00:00\tD7\tDiagnóstico 7\r\n8\t2026-09-08 10:00:00\tD8\tDiagnóstico 8\r\n17\t2026-09-17 10:00:00\tD8\tDiagnóstico 8\r\n26\t2026-09-26 10:00:00\tD8\tDiagnóstico 8\r\n9\t2026-09-09 10:00:00\tD9\tDiagnóstico 9\r\n18\t2026-09-18 10:00:00\tD9\tDiagnóstico 9\r\n27\t2026-09-27 10:00:00\tD9\tDiagnóstico 9\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 26,
    "status": 0,
    "stdout": "patient\tvisit_date\tdiagnosis\r\nPaciente1 Gómez\t2026-09-01 10:00:00\tGlaucoma 1\r\nPaciente10 Prueba\t2026-09-10 10:00:00\tGlaucoma 1\r\nPaciente4 Prueba\t2026-09-19 10:00:00\tGlaucoma 1\r\nPaciente13 Gómez\t2026-09-01 10:00:00\tGlaucoma 1\r\nPaciente2 Prueba\t2026-09-02 10:00:00\tGlaucoma 2\r\nPaciente11 Gómez\t2026-09-11 10:00:00\tGlaucoma 2\r\nPaciente5 Gómez\t2026-09-20 10:00:00\tGlaucoma 2\r\nPaciente14 Prueba\t2026-09-02 10:00:00\tGlaucoma 2\r\nPaciente3 Gómez\t2026-09-03 10:00:00\tGlaucoma 3\r\nPaciente12 Prueba\t2026-09-12 10:00:00\tGlaucoma 3\r\nPaciente6 Prueba\t2026-09-21 10:00:00\tGlaucoma 3\r\nPaciente15 Gómez\t2026-09-03 10:00:00\tGlaucoma 3\r\nPaciente4 Prueba\t2026-09-04 10:00:00\tDiagnóstico 4\r\nPaciente13 Gómez\t2026-09-13 10:00:00\tDiagnóstico 4\r\nPaciente7 Gómez\t2026-09-22 10:00:00\tDiagnóstico 4\r\nPaciente5 Gómez\t2026-09-05 10:00:00\tDiagnóstico 5\r\nPaciente14 Prueba\t2026-09-14 10:00:00\tDiagnóstico 5\r\nPaciente8 Prueba\t2026-09-23 10:00:00\tDiagnóstico 5\r\nPaciente6 Prueba\t2026-09-06 10:00:00\tDiagnóstico 6\r\nPaciente15 Gómez\t2026-09-15 10:00:00\tDiagnóstico 6\r\nPaciente9 Gómez\t2026-09-24 10:00:00\tDiagnóstico 6\r\nPaciente7 Gómez\t2026-09-07 10:00:00\tDiagnóstico 7\r\nPaciente1 Gómez\t2026-09-16 10:00:00\tDiagnóstico 7\r\nPaciente10 Prueba\t2026-09-25 10:00:00\tDiagnóstico 7\r\nPaciente8 Prueba\t2026-09-08 10:00:00\tDiagnóstico 8\r\nPaciente2 Prueba\t2026-09-17 10:00:00\tDiagnóstico 8\r\nPaciente11 Gómez\t2026-09-26 10:00:00\tDiagnóstico 8\r\nPaciente9 Gómez\t2026-09-09 10:00:00\tDiagnóstico 9\r\nPaciente3 Gómez\t2026-09-18 10:00:00\tDiagnóstico 9\r\nPaciente12 Prueba\t2026-09-27 10:00:00\tDiagnóstico 9\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 27,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 28,
    "status": 0,
    "stdout": "id\tglaucoma_record_id\tvisit_id\tcontrol_date\tglaucoma_type\ttarget_pressure\tclinical_status\tnotes\tpatient_id\tpatient\r\n1\t1\t1\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t1\tPaciente1 Gómez\r\n2\t2\t2\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t2\tPaciente2 Prueba\r\n3\t3\t3\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t3\tPaciente3 Gómez\r\n4\t4\t4\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t4\tPaciente4 Prueba\r\n5\t5\t5\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t5\tPaciente5 Gómez\r\n6\t6\t6\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t6\tPaciente6 Prueba\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 29,
    "status": 0,
    "stdout": "pressure\tmeasured_at\teye\tpatient\r\n13.00\t2026-09-01 11:00:00\tOD\tPaciente1 Gómez\r\n25.00\t2026-09-04 11:00:00\tOD\tPaciente1 Gómez\r\n28.00\t2026-09-16 11:00:00\tOI\tPaciente1 Gómez\r\n22.00\t2026-09-19 11:00:00\tOI\tPaciente1 Gómez\r\n14.00\t2026-09-02 11:00:00\tOI\tPaciente2 Prueba\r\n26.00\t2026-09-05 11:00:00\tOI\tPaciente2 Prueba\r\n29.00\t2026-09-17 11:00:00\tOD\tPaciente2 Prueba\r\n23.00\t2026-09-20 11:00:00\tOD\tPaciente2 Prueba\r\n15.00\t2026-09-03 11:00:00\tOD\tPaciente3 Gómez\r\n27.00\t2026-09-06 11:00:00\tOD\tPaciente3 Gómez\r\n12.00\t2026-09-18 11:00:00\tOI\tPaciente3 Gómez\r\n24.00\t2026-09-21 11:00:00\tOI\tPaciente3 Gómez\r\n16.00\t2026-09-04 11:00:00\tOI\tPaciente4 Prueba\r\n28.00\t2026-09-07 11:00:00\tOI\tPaciente4 Prueba\r\n13.00\t2026-09-19 11:00:00\tOD\tPaciente4 Prueba\r\n25.00\t2026-09-22 11:00:00\tOD\tPaciente4 Prueba\r\n17.00\t2026-09-05 11:00:00\tOD\tPaciente5 Gómez\r\n29.00\t2026-09-08 11:00:00\tOD\tPaciente5 Gómez\r\n14.00\t2026-09-20 11:00:00\tOI\tPaciente5 Gómez\r\n26.00\t2026-09-23 11:00:00\tOI\tPaciente5 Gómez\r\n18.00\t2026-09-06 11:00:00\tOI\tPaciente6 Prueba\r\n12.00\t2026-09-09 11:00:00\tOI\tPaciente6 Prueba\r\n15.00\t2026-09-21 11:00:00\tOD\tPaciente6 Prueba\r\n19.00\t2026-09-07 11:00:00\tOD\tPaciente7 Gómez\r\n13.00\t2026-09-10 11:00:00\tOD\tPaciente7 Gómez\r\n16.00\t2026-09-22 11:00:00\tOI\tPaciente7 Gómez\r\n20.00\t2026-09-08 11:00:00\tOI\tPaciente8 Prueba\r\n14.00\t2026-09-11 11:00:00\tOI\tPaciente8 Prueba\r\n17.00\t2026-09-23 11:00:00\tOD\tPaciente8 Prueba\r\n21.00\t2026-09-09 11:00:00\tOD\tPaciente9 Gómez\r\n15.00\t2026-09-12 11:00:00\tOD\tPaciente9 Gómez\r\n18.00\t2026-09-24 11:00:00\tOI\tPaciente9 Gómez\r\n22.00\t2026-09-10 11:00:00\tOI\tPaciente10 Prueba\r\n16.00\t2026-09-13 11:00:00\tOI\tPaciente10 Prueba\r\n19.00\t2026-09-25 11:00:00\tOD\tPaciente10 Prueba\r\n23.00\t2026-09-11 11:00:00\tOD\tPaciente11 Gómez\r\n17.00\t2026-09-14 11:00:00\tOD\tPaciente11 Gómez\r\n20.00\t2026-09-26 11:00:00\tOI\tPaciente11 Gómez\r\n24.00\t2026-09-12 11:00:00\tOI\tPaciente12 Prueba\r\n18.00\t2026-09-15 11:00:00\tOI\tPaciente12 Prueba\r\n21.00\t2026-09-27 11:00:00\tOD\tPaciente12 Prueba\r\n25.00\t2026-09-13 11:00:00\tOD\tPaciente13 Gómez\r\n19.00\t2026-09-16 11:00:00\tOD\tPaciente13 Gómez\r\n22.00\t2026-09-01 11:00:00\tOI\tPaciente13 Gómez\r\n26.00\t2026-09-14 11:00:00\tOI\tPaciente14 Prueba\r\n20.00\t2026-09-17 11:00:00\tOI\tPaciente14 Prueba\r\n23.00\t2026-09-02 11:00:00\tOD\tPaciente14 Prueba\r\n27.00\t2026-09-15 11:00:00\tOD\tPaciente15 Gómez\r\n21.00\t2026-09-18 11:00:00\tOD\tPaciente15 Gómez\r\n24.00\t2026-09-03 11:00:00\tOI\tPaciente15 Gómez\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 30,
    "status": 0,
    "stdout": "exam_date\teye\trnfl\tpatient\r\n2026-09-25 00:00:00\tOD\t66.00\tPaciente1 Gómez\r\n2026-09-25 00:00:00\tOD\t67.00\tPaciente2 Prueba\r\n2026-09-25 00:00:00\tOD\t68.00\tPaciente3 Gómez\r\n2026-09-25 00:00:00\tOD\t69.00\tPaciente4 Prueba\r\n2026-09-25 00:00:00\tOD\t70.00\tPaciente5 Gómez\r\n2026-09-25 00:00:00\tOD\t71.00\tPaciente6 Prueba\r\n2026-09-25 00:00:00\tOD\t72.00\tPaciente7 Gómez\r\n2026-09-25 00:00:00\tOD\t73.00\tPaciente8 Prueba\r\n2026-09-25 00:00:00\tOD\t74.00\tPaciente9 Gómez\r\n2026-09-25 00:00:00\tOD\t75.00\tPaciente10 Prueba\r\n2026-09-25 00:00:00\tOD\t76.00\tPaciente11 Gómez\r\n2026-09-25 00:00:00\tOD\t77.00\tPaciente12 Prueba\r\n2026-09-25 00:00:00\tOD\t78.00\tPaciente13 Gómez\r\n2026-09-25 00:00:00\tOD\t79.00\tPaciente14 Prueba\r\n2026-09-25 00:00:00\tOD\t80.00\tPaciente15 Gómez\r\n2026-09-25 00:00:00\tOD\t81.00\tPaciente1 Gómez\r\n2026-09-25 00:00:00\tOD\t82.00\tPaciente2 Prueba\r\n2026-09-25 00:00:00\tOD\t83.00\tPaciente3 Gómez\r\n2026-09-25 00:00:00\tOD\t84.00\tPaciente4 Prueba\r\n2026-09-25 00:00:00\tOD\t85.00\tPaciente5 Gómez\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 31,
    "status": 0,
    "stdout": "exam_date\teye\tmd\tpsd\tvfi\tpatient\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t71.00\tPaciente1 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t72.00\tPaciente2 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t73.00\tPaciente3 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t74.00\tPaciente4 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t75.00\tPaciente5 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t76.00\tPaciente6 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t77.00\tPaciente7 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t78.00\tPaciente8 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t79.00\tPaciente9 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t80.00\tPaciente10 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t81.00\tPaciente11 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t82.00\tPaciente12 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t83.00\tPaciente13 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t84.00\tPaciente14 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t85.00\tPaciente15 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t86.00\tPaciente1 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t87.00\tPaciente2 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t88.00\tPaciente3 Gómez\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t89.00\tPaciente4 Prueba\r\n2026-09-25 00:00:00\tOI\t-2.00\t2.00\t90.00\tPaciente5 Gómez\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 32,
    "status": 0,
    "stdout": "exam_date\teye\tcorneal_thickness\tpatient\r\n2026-09-25 00:00:00\tOD\t501.00\tPaciente1 Gómez\r\n2026-09-25 00:00:00\tOD\t502.00\tPaciente2 Prueba\r\n2026-09-25 00:00:00\tOD\t503.00\tPaciente3 Gómez\r\n2026-09-25 00:00:00\tOD\t504.00\tPaciente4 Prueba\r\n2026-09-25 00:00:00\tOD\t505.00\tPaciente5 Gómez\r\n2026-09-25 00:00:00\tOD\t506.00\tPaciente6 Prueba\r\n2026-09-25 00:00:00\tOD\t507.00\tPaciente7 Gómez\r\n2026-09-25 00:00:00\tOD\t508.00\tPaciente8 Prueba\r\n2026-09-25 00:00:00\tOD\t509.00\tPaciente9 Gómez\r\n2026-09-25 00:00:00\tOD\t510.00\tPaciente10 Prueba\r\n2026-09-25 00:00:00\tOD\t511.00\tPaciente11 Gómez\r\n2026-09-25 00:00:00\tOD\t512.00\tPaciente12 Prueba\r\n2026-09-25 00:00:00\tOD\t513.00\tPaciente13 Gómez\r\n2026-09-25 00:00:00\tOD\t514.00\tPaciente14 Prueba\r\n2026-09-25 00:00:00\tOD\t515.00\tPaciente15 Gómez\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 33,
    "status": 0,
    "stdout": "id\tvisit_id\tmedication_id\teye\tstart_date\tend_date\tactive\tdose\tfrequency\tnotes\tpatient_id\tpatient\tmedication\r\n1\t1\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t1\tPaciente1 Gómez\tMedicamento académico 2\r\n2\t2\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t2\tPaciente2 Prueba\tMedicamento académico 3\r\n3\t3\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t3\tPaciente3 Gómez\tMedicamento académico 4\r\n4\t4\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t4\tPaciente4 Prueba\tMedicamento académico 5\r\n5\t5\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t5\tPaciente5 Gómez\tMedicamento académico 1\r\n6\t6\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t6\tPaciente6 Prueba\tMedicamento académico 2\r\n7\t7\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t7\tPaciente7 Gómez\tMedicamento académico 3\r\n8\t8\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t8\tPaciente8 Prueba\tMedicamento académico 4\r\n9\t9\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t9\tPaciente9 Gómez\tMedicamento académico 5\r\n10\t10\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t10\tPaciente10 Prueba\tMedicamento académico 1\r\n11\t11\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t11\tPaciente11 Gómez\tMedicamento académico 2\r\n12\t12\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t12\tPaciente12 Prueba\tMedicamento académico 3\r\n13\t13\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t13\tPaciente13 Gómez\tMedicamento académico 4\r\n14\t14\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t14\tPaciente14 Prueba\tMedicamento académico 5\r\n15\t15\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t15\tPaciente15 Gómez\tMedicamento académico 1\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 34,
    "status": 0,
    "stdout": "id\tname\ttreatment_count\r\n1\tMedicamento académico 1\t3\r\n2\tMedicamento académico 2\t3\r\n3\tMedicamento académico 3\t3\r\n4\tMedicamento académico 4\t3\r\n5\tMedicamento académico 5\t3\r\n6\tMedicamento académico 6\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 35,
    "status": 0,
    "stdout": "total_patients\r\n20\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 36,
    "status": 0,
    "stdout": "total_visits\r\n30\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 37,
    "status": 0,
    "stdout": "sex\ttotal\r\nF\t10\r\nM\t10\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 38,
    "status": 0,
    "stdout": "id\tfirst_name\tlast_name\tpatients_seen\r\n1\tProfesional1\tPrueba\t8\r\n2\tProfesional2\tPrueba\t8\r\n3\tProfesional3\tPrueba\t7\r\n4\tProfesional4\tPrueba\t7\r\n5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 39,
    "status": 0,
    "stdout": "average_pressure\r\n20.220000\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 40,
    "status": 0,
    "stdout": "minimum_pressure\tmaximum_pressure\r\n12.00\t29.00\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 41,
    "status": 0,
    "stdout": "eye\taverage_pressure\r\nOD\t20.440000\r\nOI\t20.000000\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 42,
    "status": 0,
    "stdout": "id\tfirst_name\tlast_name\tvisit_count\r\n1\tPaciente1\tGómez\t2\r\n2\tPaciente2\tPrueba\t2\r\n3\tPaciente3\tGómez\t2\r\n4\tPaciente4\tPrueba\t2\r\n5\tPaciente5\tGómez\t2\r\n6\tPaciente6\tPrueba\t2\r\n7\tPaciente7\tGómez\t2\r\n8\tPaciente8\tPrueba\t2\r\n9\tPaciente9\tGómez\t2\r\n10\tPaciente10\tPrueba\t2\r\n11\tPaciente11\tGómez\t2\r\n12\tPaciente12\tPrueba\t2\r\n13\tPaciente13\tGómez\t2\r\n14\tPaciente14\tPrueba\t2\r\n15\tPaciente15\tGómez\t2\r\n16\tPaciente16\tPrueba\t0\r\n17\tPaciente17\tGómez\t0\r\n18\tPaciente18\tPrueba\t0\r\n19\tPaciente19\tGómez\t0\r\n20\tPaciente20\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 43,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 44,
    "status": 0,
    "stdout": "id\tfirst_name\tlast_name\tvisit_count\r\n1\tProfesional1\tPrueba\t8\r\n2\tProfesional2\tPrueba\t8\r\n3\tProfesional3\tPrueba\t7\r\n4\tProfesional4\tPrueba\t7\r\n5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 45,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 46,
    "status": 0,
    "stdout": "id\tname\ttotal\r\n1\tGlaucoma 1\t4\r\n2\tGlaucoma 2\t4\r\n3\tGlaucoma 3\t4\r\n4\tDiagnóstico 4\t3\r\n5\tDiagnóstico 5\t3\r\n6\tDiagnóstico 6\t3\r\n7\tDiagnóstico 7\t3\r\n8\tDiagnóstico 8\t3\r\n9\tDiagnóstico 9\t3\r\n10\tDiagnóstico 10\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 47,
    "status": 0,
    "stdout": "id\tname\tfrequency\r\n1\tGlaucoma 1\t4\r\n2\tGlaucoma 2\t4\r\n3\tGlaucoma 3\t4\r\n4\tDiagnóstico 4\t3\r\n5\tDiagnóstico 5\t3\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 48,
    "status": 0,
    "stdout": "month\ttotal\r\n2026-09\t20\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 49,
    "status": 0,
    "stdout": "year\ttotal\r\n2026\t20\r\n",
    "stderr": ""
  },
  {
    "parte": 1,
    "n": 50,
    "status": 0,
    "stdout": "id\tpatient\tvisits\tglaucoma_controls\taverage_iop\tlast_visit\r\n1\tPaciente1 Gómez\t2\t1\t22.000000\t2026-09-16 10:00:00\r\n2\tPaciente2 Prueba\t2\t1\t23.000000\t2026-09-17 10:00:00\r\n3\tPaciente3 Gómez\t2\t1\t19.500000\t2026-09-18 10:00:00\r\n4\tPaciente4 Prueba\t2\t1\t20.500000\t2026-09-19 10:00:00\r\n5\tPaciente5 Gómez\t2\t1\t21.500000\t2026-09-20 10:00:00\r\n6\tPaciente6 Prueba\t2\t1\t15.000000\t2026-09-21 10:00:00\r\n7\tPaciente7 Gómez\t2\t0\t16.000000\t2026-09-22 10:00:00\r\n8\tPaciente8 Prueba\t2\t0\t17.000000\t2026-09-23 10:00:00\r\n9\tPaciente9 Gómez\t2\t0\t18.000000\t2026-09-24 10:00:00\r\n10\tPaciente10 Prueba\t2\t0\t19.000000\t2026-09-25 10:00:00\r\n11\tPaciente11 Gómez\t2\t0\t20.000000\t2026-09-26 10:00:00\r\n12\tPaciente12 Prueba\t2\t0\t21.000000\t2026-09-27 10:00:00\r\n13\tPaciente13 Gómez\t2\t0\t22.000000\t2026-09-13 10:00:00\r\n14\tPaciente14 Prueba\t2\t0\t23.000000\t2026-09-14 10:00:00\r\n15\tPaciente15 Gómez\t2\t0\t24.000000\t2026-09-15 10:00:00\r\n16\tPaciente16 Prueba\t0\t0\tNULL\tNULL\r\n17\tPaciente17 Gómez\t0\t0\tNULL\tNULL\r\n18\tPaciente18 Prueba\t0\t0\tNULL\tNULL\r\n19\tPaciente19 Gómez\t0\t0\tNULL\tNULL\r\n20\tPaciente20 Prueba\t0\t0\tNULL\tNULL\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 1,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 2,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 3,
    "status": 0,
    "stdout": "maximum_pressure\r\n29.00\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 4,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n17\t17\tOD\t2026-09-17 11:00:00\t29.00\t2\r\n35\t5\tOD\t2026-09-08 11:00:00\t29.00\t5\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 5,
    "status": 0,
    "stdout": "minimum_pressure\r\n12.00\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 6,
    "status": 0,
    "stdout": "id\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n1\t1\tOD\t2026-09-25 00:00:00\t66.00\tFicticio\t0\t1\r\n2\t2\tOD\t2026-09-25 00:00:00\t67.00\tFicticio\t0\t2\r\n3\t3\tOD\t2026-09-25 00:00:00\t68.00\tFicticio\t0\t3\r\n4\t4\tOD\t2026-09-25 00:00:00\t69.00\tFicticio\t0\t4\r\n5\t5\tOD\t2026-09-25 00:00:00\t70.00\tFicticio\t0\t5\r\n6\t6\tOD\t2026-09-25 00:00:00\t71.00\tFicticio\t0\t6\r\n7\t7\tOD\t2026-09-25 00:00:00\t72.00\tFicticio\t0\t7\r\n8\t8\tOD\t2026-09-25 00:00:00\t73.00\tFicticio\t0\t8\r\n9\t9\tOD\t2026-09-25 00:00:00\t74.00\tFicticio\t0\t9\r\n10\t10\tOD\t2026-09-25 00:00:00\t75.00\tFicticio\t0\t10\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 7,
    "status": 0,
    "stdout": "id\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n11\t11\tOD\t2026-09-25 00:00:00\t76.00\tFicticio\t0\t11\r\n12\t12\tOD\t2026-09-25 00:00:00\t77.00\tFicticio\t0\t12\r\n13\t13\tOD\t2026-09-25 00:00:00\t78.00\tFicticio\t0\t13\r\n14\t14\tOD\t2026-09-25 00:00:00\t79.00\tFicticio\t0\t14\r\n15\t15\tOD\t2026-09-25 00:00:00\t80.00\tFicticio\t0\t15\r\n16\t16\tOD\t2026-09-25 00:00:00\t81.00\tFicticio\t0\t1\r\n17\t17\tOD\t2026-09-25 00:00:00\t82.00\tFicticio\t0\t2\r\n18\t18\tOD\t2026-09-25 00:00:00\t83.00\tFicticio\t0\t3\r\n19\t19\tOD\t2026-09-25 00:00:00\t84.00\tFicticio\t0\t4\r\n20\t20\tOD\t2026-09-25 00:00:00\t85.00\tFicticio\t0\t5\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 8,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 9,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n1\t2\tPRO1\tProfesional1\tPrueba\t1\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n3\t2\tPRO3\tProfesional3\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 10,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 11,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 12,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 13,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 14,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 15,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 16,
    "status": 0,
    "stdout": "id\tname\tactive\r\n1\tMedicamento académico 1\t1\r\n2\tMedicamento académico 2\t1\r\n3\tMedicamento académico 3\t1\r\n4\tMedicamento académico 4\t1\r\n5\tMedicamento académico 5\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 17,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n1\t2\tPRO1\tProfesional1\tPrueba\t1\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n3\t2\tPRO3\tProfesional3\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 18,
    "status": 0,
    "stdout": "id\tcode\tname\tglaucoma_type\r\n1\tD1\tGlaucoma 1\tTipo1\r\n2\tD2\tGlaucoma 2\tTipo2\r\n3\tD3\tGlaucoma 3\tTipo3\r\n4\tD4\tDiagnóstico 4\tNULL\r\n5\tD5\tDiagnóstico 5\tNULL\r\n6\tD6\tDiagnóstico 6\tNULL\r\n7\tD7\tDiagnóstico 7\tNULL\r\n8\tD8\tDiagnóstico 8\tNULL\r\n9\tD9\tDiagnóstico 9\tNULL\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 19,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 20,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 21,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 22,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 23,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 24,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 25,
    "status": 0,
    "stdout": "id\tname\tactive\r\n6\tMedicamento académico 6\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 26,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n5\t2\tPRO5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 27,
    "status": 0,
    "stdout": "id\tcode\tname\tglaucoma_type\r\n10\tD10\tDiagnóstico 10\tNULL\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 28,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 29,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 30,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 31,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n16\t16\tOI\t2026-09-16 11:00:00\t28.00\t1\r\n32\t2\tOI\t2026-09-05 11:00:00\t26.00\t2\r\n17\t17\tOD\t2026-09-17 11:00:00\t29.00\t2\r\n33\t3\tOD\t2026-09-06 11:00:00\t27.00\t3\r\n48\t18\tOI\t2026-09-21 11:00:00\t24.00\t3\r\n34\t4\tOI\t2026-09-07 11:00:00\t28.00\t4\r\n49\t19\tOD\t2026-09-22 11:00:00\t25.00\t4\r\n35\t5\tOD\t2026-09-08 11:00:00\t29.00\t5\r\n50\t20\tOI\t2026-09-23 11:00:00\t26.00\t5\r\n6\t6\tOI\t2026-09-06 11:00:00\t18.00\t6\r\n7\t7\tOD\t2026-09-07 11:00:00\t19.00\t7\r\n8\t8\tOI\t2026-09-08 11:00:00\t20.00\t8\r\n9\t9\tOD\t2026-09-09 11:00:00\t21.00\t9\r\n10\t10\tOI\t2026-09-10 11:00:00\t22.00\t10\r\n11\t11\tOD\t2026-09-11 11:00:00\t23.00\t11\r\n12\t12\tOI\t2026-09-12 11:00:00\t24.00\t12\r\n13\t13\tOD\t2026-09-13 11:00:00\t25.00\t13\r\n14\t14\tOI\t2026-09-14 11:00:00\t26.00\t14\r\n15\t15\tOD\t2026-09-15 11:00:00\t27.00\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 32,
    "status": 0,
    "stdout": "id\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n1\t1\tOD\t2026-09-25 00:00:00\t66.00\tFicticio\t0\t1\r\n2\t2\tOD\t2026-09-25 00:00:00\t67.00\tFicticio\t0\t2\r\n3\t3\tOD\t2026-09-25 00:00:00\t68.00\tFicticio\t0\t3\r\n4\t4\tOD\t2026-09-25 00:00:00\t69.00\tFicticio\t0\t4\r\n5\t5\tOD\t2026-09-25 00:00:00\t70.00\tFicticio\t0\t5\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 33,
    "status": 0,
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\r\n2026-10-08 20:55:28\t13\t13\t1\t2026-09-13 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t14\t14\t2\t2026-09-14 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t15\t15\t3\t2026-09-15 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t17\t2\t1\t2026-09-17 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t18\t3\t2\t2026-09-18 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t19\t4\t3\t2026-09-19 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t20\t5\t4\t2026-09-20 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t21\t6\t1\t2026-09-21 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t22\t7\t2\t2026-09-22 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t23\t8\t3\t2026-09-23 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t24\t9\t4\t2026-09-24 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t25\t10\t1\t2026-09-25 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t26\t11\t2\t2026-09-26 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t27\t12\t3\t2026-09-27 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 34,
    "status": 0,
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t17\t2\t1\t2026-09-17 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t18\t3\t2\t2026-09-18 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t19\t4\t3\t2026-09-19 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t20\t5\t4\t2026-09-20 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t21\t6\t1\t2026-09-21 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t22\t7\t2\t2026-09-22 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t23\t8\t3\t2026-09-23 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t24\t9\t4\t2026-09-24 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t25\t10\t1\t2026-09-25 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t26\t11\t2\t2026-09-26 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t27\t12\t3\t2026-09-27 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t13\t13\t1\t2026-09-13 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t14\t14\t2\t2026-09-14 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t15\t15\t3\t2026-09-15 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 35,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n1\t1\tOD\t2026-09-01 11:00:00\t13.00\t1\r\n2\t2\tOI\t2026-09-02 11:00:00\t14.00\t2\r\n3\t3\tOD\t2026-09-03 11:00:00\t15.00\t3\r\n4\t4\tOI\t2026-09-04 11:00:00\t16.00\t4\r\n5\t5\tOD\t2026-09-05 11:00:00\t17.00\t5\r\n6\t6\tOI\t2026-09-06 11:00:00\t18.00\t6\r\n7\t7\tOD\t2026-09-07 11:00:00\t19.00\t7\r\n8\t8\tOI\t2026-09-08 11:00:00\t20.00\t8\r\n9\t9\tOD\t2026-09-09 11:00:00\t21.00\t9\r\n10\t10\tOI\t2026-09-10 11:00:00\t22.00\t10\r\n11\t11\tOD\t2026-09-11 11:00:00\t23.00\t11\r\n12\t12\tOI\t2026-09-12 11:00:00\t24.00\t12\r\n28\t28\tOI\t2026-09-01 11:00:00\t22.00\t13\r\n29\t29\tOD\t2026-09-02 11:00:00\t23.00\t14\r\n30\t30\tOI\t2026-09-03 11:00:00\t24.00\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 36,
    "status": 0,
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n46\t16\tOI\t2026-09-19 11:00:00\t22.00\t1\r\n32\t2\tOI\t2026-09-05 11:00:00\t26.00\t2\r\n47\t17\tOD\t2026-09-20 11:00:00\t23.00\t2\r\n33\t3\tOD\t2026-09-06 11:00:00\t27.00\t3\r\n48\t18\tOI\t2026-09-21 11:00:00\t24.00\t3\r\n34\t4\tOI\t2026-09-07 11:00:00\t28.00\t4\r\n49\t19\tOD\t2026-09-22 11:00:00\t25.00\t4\r\n35\t5\tOD\t2026-09-08 11:00:00\t29.00\t5\r\n50\t20\tOI\t2026-09-23 11:00:00\t26.00\t5\r\n36\t6\tOI\t2026-09-09 11:00:00\t12.00\t6\r\n21\t21\tOD\t2026-09-21 11:00:00\t15.00\t6\r\n37\t7\tOD\t2026-09-10 11:00:00\t13.00\t7\r\n22\t22\tOI\t2026-09-22 11:00:00\t16.00\t7\r\n38\t8\tOI\t2026-09-11 11:00:00\t14.00\t8\r\n23\t23\tOD\t2026-09-23 11:00:00\t17.00\t8\r\n39\t9\tOD\t2026-09-12 11:00:00\t15.00\t9\r\n24\t24\tOI\t2026-09-24 11:00:00\t18.00\t9\r\n40\t10\tOI\t2026-09-13 11:00:00\t16.00\t10\r\n25\t25\tOD\t2026-09-25 11:00:00\t19.00\t10\r\n41\t11\tOD\t2026-09-14 11:00:00\t17.00\t11\r\n26\t26\tOI\t2026-09-26 11:00:00\t20.00\t11\r\n42\t12\tOI\t2026-09-15 11:00:00\t18.00\t12\r\n27\t27\tOD\t2026-09-27 11:00:00\t21.00\t12\r\n43\t13\tOD\t2026-09-16 11:00:00\t19.00\t13\r\n28\t28\tOI\t2026-09-01 11:00:00\t22.00\t13\r\n44\t14\tOI\t2026-09-17 11:00:00\t20.00\t14\r\n29\t29\tOD\t2026-09-02 11:00:00\t23.00\t14\r\n45\t15\tOD\t2026-09-18 11:00:00\t21.00\t15\r\n30\t30\tOI\t2026-09-03 11:00:00\t24.00\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 37,
    "status": 0,
    "stdout": "id\tvisit_id\tmedication_id\teye\tstart_date\tend_date\tactive\tdose\tfrequency\tnotes\tpatient_id\r\n1\t1\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t1\r\n2\t2\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t2\r\n3\t3\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t3\r\n4\t4\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t4\r\n5\t5\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t5\r\n6\t6\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t6\r\n7\t7\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t7\r\n8\t8\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t8\r\n9\t9\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t9\r\n10\t10\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t10\r\n11\t11\t2\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t11\r\n12\t12\t3\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t12\r\n13\t13\t4\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t13\r\n14\t14\t5\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t14\r\n15\t15\t1\tAO\t2026-09-25\tNULL\t1\tNULL\tNULL\tNULL\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 38,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 39,
    "status": 0,
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n1\t2\tPRO1\tProfesional1\tPrueba\t1\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n3\t2\tPRO3\tProfesional3\tPrueba\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 40,
    "status": 0,
    "stdout": "id\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n16\t16\tOD\t2026-09-25 00:00:00\t81.00\tFicticio\t0\t1\r\n17\t17\tOD\t2026-09-25 00:00:00\t82.00\tFicticio\t0\t2\r\n18\t18\tOD\t2026-09-25 00:00:00\t83.00\tFicticio\t0\t3\r\n19\t19\tOD\t2026-09-25 00:00:00\t84.00\tFicticio\t0\t4\r\n20\t20\tOD\t2026-09-25 00:00:00\t85.00\tFicticio\t0\t5\r\n6\t6\tOD\t2026-09-25 00:00:00\t71.00\tFicticio\t0\t6\r\n7\t7\tOD\t2026-09-25 00:00:00\t72.00\tFicticio\t0\t7\r\n8\t8\tOD\t2026-09-25 00:00:00\t73.00\tFicticio\t0\t8\r\n9\t9\tOD\t2026-09-25 00:00:00\t74.00\tFicticio\t0\t9\r\n10\t10\tOD\t2026-09-25 00:00:00\t75.00\tFicticio\t0\t10\r\n11\t11\tOD\t2026-09-25 00:00:00\t76.00\tFicticio\t0\t11\r\n12\t12\tOD\t2026-09-25 00:00:00\t77.00\tFicticio\t0\t12\r\n13\t13\tOD\t2026-09-25 00:00:00\t78.00\tFicticio\t0\t13\r\n14\t14\tOD\t2026-09-25 00:00:00\t79.00\tFicticio\t0\t14\r\n15\t15\tOD\t2026-09-25 00:00:00\t80.00\tFicticio\t0\t15\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 41,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 42,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 43,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 44,
    "status": 0,
    "stdout": "id\tname\tactive\r\n1\tMedicamento académico 1\t1\r\n2\tMedicamento académico 2\t1\r\n3\tMedicamento académico 3\t1\r\n4\tMedicamento académico 4\t1\r\n5\tMedicamento académico 5\t1\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 45,
    "status": 0,
    "stdout": "id\tcode\tname\tglaucoma_type\r\n1\tD1\tGlaucoma 1\tTipo1\r\n2\tD2\tGlaucoma 2\tTipo2\r\n3\tD3\tGlaucoma 3\tTipo3\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 46,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 47,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 48,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 49,
    "status": 0,
    "stdout": "",
    "stderr": ""
  },
  {
    "parte": 2,
    "n": 50,
    "status": 0,
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  }
]
```

</details>

<a id="e-funciones"></a>

#### funciones.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "n": 1,
    "query": "fn_patient_age('1970-01-01')",
    "status": 0,
    "stdout": "result\r\n56\r\n",
    "stderr": ""
  },
  {
    "n": 2,
    "query": "fn_full_name('A','B')",
    "status": 0,
    "stdout": "result\r\nA B\r\n",
    "stderr": ""
  },
  {
    "n": 3,
    "query": "fn_patient_document(1)",
    "status": 0,
    "stdout": "result\r\n101001\r\n",
    "stderr": ""
  },
  {
    "n": 4,
    "query": "fn_patient_age_by_id(1)",
    "status": 0,
    "stdout": "result\r\n75\r\n",
    "stderr": ""
  },
  {
    "n": 5,
    "query": "fn_visit_date(1)",
    "status": 0,
    "stdout": "result\r\n2026-09-01 10:00:00\r\n",
    "stderr": ""
  },
  {
    "n": 6,
    "query": "fn_years_since('2000-01-01')",
    "status": 0,
    "stdout": "result\r\n26\r\n",
    "stderr": ""
  },
  {
    "n": 7,
    "query": "fn_iop_description(18)",
    "status": 0,
    "stdout": "result\r\nPIO registrada: 18.00 mmHg\r\n",
    "stderr": ""
  },
  {
    "n": 8,
    "query": "fn_eye_name('OD')",
    "status": 0,
    "stdout": "result\r\nOjo derecho\r\n",
    "stderr": ""
  },
  {
    "n": 9,
    "query": "fn_boolean_status(TRUE)",
    "status": 0,
    "stdout": "result\r\nActivo\r\n",
    "stderr": ""
  },
  {
    "n": 10,
    "query": "fn_format_history(1)",
    "status": 0,
    "stdout": "result\r\nHC-000001\r\n",
    "stderr": ""
  },
  {
    "n": 11,
    "query": "fn_patient_visit_count(1)",
    "status": 0,
    "stdout": "result\r\n6\r\n",
    "stderr": ""
  },
  {
    "n": 12,
    "query": "fn_patient_diagnosis_count(1)",
    "status": 0,
    "stdout": "result\r\n5\r\n",
    "stderr": ""
  },
  {
    "n": 13,
    "query": "fn_glaucoma_control_count(1)",
    "status": 0,
    "stdout": "result\r\n3\r\n",
    "stderr": ""
  },
  {
    "n": 14,
    "query": "fn_last_visit(1)",
    "status": 0,
    "stdout": "result\r\n2026-09-28 00:00:00\r\n",
    "stderr": ""
  },
  {
    "n": 15,
    "query": "fn_first_visit(1)",
    "status": 0,
    "stdout": "result\r\n2026-09-01 10:00:00\r\n",
    "stderr": ""
  },
  {
    "n": 16,
    "query": "fn_avg_iop(1)",
    "status": 0,
    "stdout": "result\r\n20.20\r\n",
    "stderr": ""
  },
  {
    "n": 17,
    "query": "fn_avg_iop_od(1)",
    "status": 0,
    "stdout": "result\r\n19.00\r\n",
    "stderr": ""
  },
  {
    "n": 18,
    "query": "fn_avg_iop_oi(1)",
    "status": 0,
    "stdout": "result\r\n25.00\r\n",
    "stderr": ""
  },
  {
    "n": 19,
    "query": "fn_max_iop(1)",
    "status": 0,
    "stdout": "result\r\n28.00\r\n",
    "stderr": ""
  },
  {
    "n": 20,
    "query": "fn_min_iop(1)",
    "status": 0,
    "stdout": "result\r\n13.00\r\n",
    "stderr": ""
  },
  {
    "n": 21,
    "query": "fn_iop_academic_range(18)",
    "status": 0,
    "stdout": "result\r\nRango B\r\n",
    "stderr": ""
  },
  {
    "n": 22,
    "query": "fn_iop_above_target(19,18)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 23,
    "query": "fn_has_glaucoma(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 24,
    "query": "fn_has_active_treatment(1)",
    "status": 0,
    "stdout": "result\r\n0\r\n",
    "stderr": ""
  },
  {
    "n": 25,
    "query": "fn_has_oct(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 26,
    "query": "fn_has_visual_field(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 27,
    "query": "fn_has_pachymetry(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 28,
    "query": "fn_control_pending(1,3)",
    "status": 0,
    "stdout": "result\r\n0\r\n",
    "stderr": ""
  },
  {
    "n": 29,
    "query": "fn_patient_frequency(1)",
    "status": 0,
    "stdout": "result\r\nFrecuente\r\n",
    "stderr": ""
  },
  {
    "n": 30,
    "query": "fn_exam_set_status(1)",
    "status": 0,
    "stdout": "result\r\nCompleto\r\n",
    "stderr": ""
  },
  {
    "n": 31,
    "query": "fn_avg_iop_between(1,'2026-01-01','2026-10-01')",
    "status": 0,
    "stdout": "result\r\n20.20\r\n",
    "stderr": ""
  },
  {
    "n": 32,
    "query": "fn_first_last_iop_diff(1,'OD')",
    "status": 0,
    "stdout": "result\r\n6.00\r\n",
    "stderr": ""
  },
  {
    "n": 33,
    "query": "fn_days_since_last_visit(1)",
    "status": 0,
    "stdout": "result\r\n10\r\n",
    "stderr": ""
  },
  {
    "n": 34,
    "query": "fn_months_since_last_oct(1)",
    "status": 0,
    "stdout": "result\r\n0\r\n",
    "stderr": ""
  },
  {
    "n": 35,
    "query": "fn_months_since_last_visual_field(1)",
    "status": 0,
    "stdout": "result\r\n0\r\n",
    "stderr": ""
  },
  {
    "n": 36,
    "query": "fn_avg_rnfl(1)",
    "status": 0,
    "stdout": "result\r\n75.67\r\n",
    "stderr": ""
  },
  {
    "n": 37,
    "query": "fn_latest_rnfl(1)",
    "status": 0,
    "stdout": "result\r\n80.00\r\n",
    "stderr": ""
  },
  {
    "n": 38,
    "query": "fn_avg_vfi(1)",
    "status": 0,
    "stdout": "result\r\n84.25\r\n",
    "stderr": ""
  },
  {
    "n": 39,
    "query": "fn_treatment_history_count(1)",
    "status": 0,
    "stdout": "result\r\n3\r\n",
    "stderr": ""
  },
  {
    "n": 40,
    "query": "fn_distinct_medications(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 41,
    "query": "fn_last_iop_eye(1,'OD')",
    "status": 0,
    "stdout": "result\r\n19.00\r\n",
    "stderr": ""
  },
  {
    "n": 42,
    "query": "fn_avg_iop_eye(1,'OI')",
    "status": 0,
    "stdout": "result\r\n25.00\r\n",
    "stderr": ""
  },
  {
    "n": 43,
    "query": "fn_iop_trend(1,'OD')",
    "status": 0,
    "stdout": "result\r\nMayor\r\n",
    "stderr": ""
  },
  {
    "n": 44,
    "query": "fn_iop_percent_change(1,'OD')",
    "status": 0,
    "stdout": "result\r\n46.15\r\n",
    "stderr": ""
  },
  {
    "n": 45,
    "query": "fn_latest_primary_diagnosis(1)",
    "status": 0,
    "stdout": "result\r\nDiagnóstico 7\r\n",
    "stderr": ""
  },
  {
    "n": 46,
    "query": "fn_latest_active_medication(1)",
    "status": 0,
    "stdout": "result\r\nNULL\r\n",
    "stderr": ""
  },
  {
    "n": 47,
    "query": "fn_procedure_count(1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 48,
    "query": "fn_professional_saw_patient(1,1)",
    "status": 0,
    "stdout": "result\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 49,
    "query": "fn_special_exam_count(1)",
    "status": 0,
    "stdout": "result\r\n11\r\n",
    "stderr": ""
  },
  {
    "n": 50,
    "query": "fn_patient_summary(1)",
    "status": 0,
    "stdout": "result\r\nPaciente: Paciente1 Gómez | Consultas: 6 | Controles glaucoma: 3 | Última PIO OD: 19.00 | Última PIO OI: 22.00 | Tratamientos activos: 0\r\n",
    "stderr": ""
  }
]
```

</details>

<a id="e-instalacion"></a>

#### instalacion.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "file": "01-esquema",
    "status": 0,
    "stderr": "",
    "stdout": ""
  },
  {
    "file": "02-vistas",
    "status": 0,
    "stderr": "",
    "stdout": ""
  },
  {
    "file": "08-funciones",
    "status": 0,
    "stderr": "",
    "stdout": ""
  },
  {
    "file": "06-procedimientos",
    "status": 0,
    "stderr": "",
    "stdout": ""
  },
  {
    "file": "07-triggers",
    "status": 0,
    "stderr": "",
    "stdout": ""
  },
  {
    "file": "03-datos",
    "status": 0,
    "stderr": "",
    "stdout": ""
  }
]
```

</details>

<a id="e-procedimientos"></a>

#### procedimientos.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "n": 1,
    "name": "sp_list_patients",
    "query": "CALL sp_list_patients();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t2\t1\t101002\tPaciente2\tPrueba\t1952-01-01\tM\t3000002\tpaciente2@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t3\t2\t101003\tPaciente3\tGómez\t1953-01-01\tF\t3000003\tpaciente3@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t4\t1\t101004\tPaciente4\tPrueba\t1954-01-01\tM\t3000004\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t5\t2\t101005\tPaciente5\tGómez\t1955-01-01\tF\t3000005\tpaciente5@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t6\t1\t101006\tPaciente6\tPrueba\t1956-01-01\tM\t3000006\tpaciente6@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t7\t2\t101007\tPaciente7\tGómez\t1957-01-01\tF\t3000007\tpaciente7@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t8\t1\t101008\tPaciente8\tPrueba\t1958-01-01\tM\t3000008\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t9\t2\t101009\tPaciente9\tGómez\t1959-01-01\tF\t3000009\tpaciente9@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t10\t1\t101010\tPaciente10\tPrueba\t1960-01-01\tM\t30000010\tpaciente10@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t11\t2\t101011\tPaciente11\tGómez\t1961-01-01\tF\t30000011\tpaciente11@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t12\t1\t101012\tPaciente12\tPrueba\t1962-01-01\tM\t30000012\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t13\t2\t101013\tPaciente13\tGómez\t1963-01-01\tF\t30000013\tpaciente13@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t14\t1\t101014\tPaciente14\tPrueba\t1964-01-01\tM\t30000014\tpaciente14@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t15\t2\t101015\tPaciente15\tGómez\t1965-01-01\tF\t30000015\tpaciente15@gmail.com\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "n": 2,
    "name": "sp_get_patient",
    "query": "CALL sp_get_patient(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "n": 3,
    "name": "sp_find_patient_document",
    "query": "CALL sp_find_patient_document('101001');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\t3000001\tpaciente1@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n",
    "stderr": ""
  },
  {
    "n": 4,
    "name": "sp_patient_visits",
    "query": "CALL sp_patient_visits(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\r\n2026-10-08 20:55:28\t1\t1\t1\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n",
    "stderr": ""
  },
  {
    "n": 5,
    "name": "sp_list_professionals",
    "query": "CALL sp_list_professionals();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n1\t2\tPRO1\tProfesional1\tPrueba\t1\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n3\t2\tPRO3\tProfesional3\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n5\t2\tPRO5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "n": 6,
    "name": "sp_professionals_by_specialty",
    "query": "CALL sp_professionals_by_specialty('Oftalmología');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tspecialty_id\tdocument_number\tfirst_name\tlast_name\tactive\r\n2\t1\tPRO2\tProfesional2\tPrueba\t1\r\n4\t1\tPRO4\tProfesional4\tPrueba\t1\r\n",
    "stderr": ""
  },
  {
    "n": 7,
    "name": "sp_list_diagnoses",
    "query": "CALL sp_list_diagnoses();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tcode\tname\tglaucoma_type\r\n1\tD1\tGlaucoma 1\tTipo1\r\n2\tD2\tGlaucoma 2\tTipo2\r\n3\tD3\tGlaucoma 3\tTipo3\r\n4\tD4\tDiagnóstico 4\tNULL\r\n5\tD5\tDiagnóstico 5\tNULL\r\n6\tD6\tDiagnóstico 6\tNULL\r\n7\tD7\tDiagnóstico 7\tNULL\r\n8\tD8\tDiagnóstico 8\tNULL\r\n9\tD9\tDiagnóstico 9\tNULL\r\n10\tD10\tDiagnóstico 10\tNULL\r\n",
    "stderr": ""
  },
  {
    "n": 8,
    "name": "sp_active_medications",
    "query": "CALL sp_active_medications();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tname\tactive\r\n1\tMedicamento académico 1\t1\r\n2\tMedicamento académico 2\t1\r\n3\tMedicamento académico 3\t1\r\n4\tMedicamento académico 4\t1\r\n5\tMedicamento académico 5\t1\r\n6\tMedicamento académico 6\t1\r\n",
    "stderr": ""
  },
  {
    "n": 9,
    "name": "sp_patient_procedures",
    "query": "CALL sp_patient_procedures(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tvisit_id\teye\tprocedure_type\tprocedure_date\tnotes\tpatient_id\r\n1\t1\tOD\tQUIRURGICO:Ejemplo académico\t2026-09-21 00:00:00\tNULL\t1\r\n",
    "stderr": ""
  },
  {
    "n": 10,
    "name": "sp_patient_glaucoma_controls",
    "query": "CALL sp_patient_glaucoma_controls(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tglaucoma_record_id\tvisit_id\tcontrol_date\tglaucoma_type\ttarget_pressure\tclinical_status\tnotes\tpatient_id\r\n1\t1\t1\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t1\r\n",
    "stderr": ""
  },
  {
    "n": 11,
    "name": "sp_create_patient",
    "query": "CALL sp_create_patient(1,'NUEVO901','Nuevo','Prueba','1970-01-01','Prueba académica','Prueba académica','Prueba académica','Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 12,
    "name": "sp_create_history",
    "query": "CALL sp_create_history(1,'HC-1');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 13,
    "name": "sp_create_visit",
    "query": "CALL sp_create_visit(1,1,'2026-09-28','Prueba académica','Prueba académica','Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 14,
    "name": "sp_register_diagnosis",
    "query": "CALL sp_register_diagnosis(1,2,'OI');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 15,
    "name": "sp_register_iop",
    "query": "CALL sp_register_iop(1,'2026-09-28','OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 16,
    "name": "sp_register_glaucoma_control",
    "query": "CALL sp_register_glaucoma_control(1,1,'2026-09-28','Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 17,
    "name": "sp_register_oct",
    "query": "CALL sp_register_oct(1,'2026-09-28','OD',80,'Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 18,
    "name": "sp_register_visual_field",
    "query": "CALL sp_register_visual_field(1,'2026-09-28','OD',-2,2,90);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 19,
    "name": "sp_register_pachymetry",
    "query": "CALL sp_register_pachymetry(1,'2026-09-28','OD',510);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 20,
    "name": "sp_register_treatment",
    "query": "CALL sp_register_treatment(1,2,'OD','2026-09-26','2026-10-01','Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 21,
    "name": "sp_update_patient_contact",
    "query": "CALL sp_update_patient_contact(1,'Prueba académica','Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 22,
    "name": "sp_update_history_status",
    "query": "CALL sp_update_history_status(1,'ACTIVE');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 23,
    "name": "sp_update_visit_observations",
    "query": "CALL sp_update_visit_observations(1,'Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 24,
    "name": "sp_update_target_pressure",
    "query": "CALL sp_update_target_pressure(1,'OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 25,
    "name": "sp_finish_treatment",
    "query": "CALL sp_finish_treatment(1,'2026-10-01');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 26,
    "name": "sp_change_treatment_medication",
    "query": "CALL sp_change_treatment_medication(1,2);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 27,
    "name": "sp_update_glaucoma_status",
    "query": "CALL sp_update_glaucoma_status(1,'OD','ACTIVE');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 28,
    "name": "sp_update_professional",
    "query": "CALL sp_update_professional(1,'Prueba','Paciente',TRUE);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 29,
    "name": "sp_update_oct_interpretation",
    "query": "CALL sp_update_oct_interpretation(1,'Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 30,
    "name": "sp_update_visual_field_interpretation",
    "query": "CALL sp_update_visual_field_interpretation(1,'Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 31,
    "name": "sp_safe_iop",
    "query": "CALL sp_safe_iop(1,1,'2026-09-28','OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 32,
    "name": "sp_safe_visit",
    "query": "CALL sp_safe_visit(1,1,'2026-09-28');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 33,
    "name": "sp_safe_treatment",
    "query": "CALL sp_safe_treatment(1,2,'OD','2026-09-26','2026-10-01');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 34,
    "name": "sp_safe_iop_nonnegative",
    "query": "CALL sp_safe_iop_nonnegative(1,'2026-09-28','OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 35,
    "name": "sp_safe_eye",
    "query": "CALL sp_safe_eye(1,'2026-09-28','OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 36,
    "name": "sp_unique_history",
    "query": "CALL sp_unique_history(1,'HC-1');",
    "status": 1,
    "expected": "REJECT_DUPLICATE",
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: El paciente ya tiene historia\r\n"
  },
  {
    "n": 37,
    "name": "sp_safe_diagnosis",
    "query": "CALL sp_safe_diagnosis(1,3,'OI');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 38,
    "name": "sp_visit_active_professional",
    "query": "CALL sp_visit_active_professional(1,1,'2026-09-28');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 39,
    "name": "sp_safe_visual_field",
    "query": "CALL sp_safe_visual_field(1,'2026-09-28','OD',90);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 40,
    "name": "sp_safe_pachymetry",
    "query": "CALL sp_safe_pachymetry(1,'2026-09-28','OD',510);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 41,
    "name": "sp_patient_history_summary",
    "query": "CALL sp_patient_history_summary(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:36\t1\t2\t101001\tPaciente1\tGómez\t1951-01-01\tF\tPrueba académica\tPrueba académica\tBogotá\t2026-10-08 20:55:28\r\nid\tpatient_id\thistory_type\tdescription\trecorded_at\r\n1\t1\tALERGIA\tSustancia ficticia A\t2026-10-08 20:55:29\r\n2\t1\tFAMILIAR\tAntecedente ficticio B\t2026-10-08 20:55:29\r\nupdated_at\tid\tclinical_history_id\tprofessional_id\tvisit_date\treason\tassessment\tplan\tobservations\tstatus\r\n2026-10-08 20:55:36\t1\t1\t1\t2026-09-01 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tPrueba académica\tOPEN\r\n2026-10-08 20:55:28\t16\t1\t4\t2026-09-16 10:00:00\tSeguimiento ficticio\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:35\t31\t1\t1\t2026-09-28 00:00:00\tPrueba académica\tPrueba académica\tPrueba académica\tNULL\tOPEN\r\n2026-10-08 20:55:37\t32\t1\t1\t2026-09-28 00:00:00\tNULL\tNULL\tNULL\tNULL\tOPEN\r\n2026-10-08 20:55:38\t33\t1\t1\t2026-09-28 00:00:00\tNULL\tNULL\tNULL\tNULL\tOPEN\r\nid\tpatient_id\thistory_number\tstatus\tcreated_at\r\n1\t1\tHC-1\tACTIVE\t2026-10-08 20:55:28\r\nvisit_id\tdiagnosis_id\teye\tis_primary\tprimary_visit_eye\r\n1\t1\tOD\t1\t1:OD\r\n1\t2\tOI\t0\tNULL\r\n1\t3\tOI\t0\tNULL\r\n16\t7\tOD\t1\t16:OD\r\nid\tvisit_id\texam_date\teye\tvisual_acuity\toptic_nerve_notes\tnotes\r\n1\t1\t2026-09-20 00:00:00\tOD\t20/20\tDescripción ficticia\tNULL\r\nid\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n1\t1\tOD\t2026-09-01 11:00:00\t13.00\t1\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n51\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n52\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n53\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n54\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n16\t16\tOI\t2026-09-16 11:00:00\t28.00\t1\r\n46\t16\tOI\t2026-09-19 11:00:00\t22.00\t1\r\nid\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n1\t1\tOD\t2026-09-25 00:00:00\t66.00\tPrueba académica\t0\t1\r\n16\t16\tOD\t2026-09-25 00:00:00\t81.00\tFicticio\t0\t1\r\n21\t1\tOD\t2026-09-28 00:00:00\t80.00\tPrueba académica\t0\t1\r\nid\tvisit_id\teye\texam_date\tmd\tpsd\tvfi\tinterpretation\tpatient_id\r\n1\t1\tOI\t2026-09-25 00:00:00\t-2.00\t2.00\t71.00\tPrueba académica\t1\r\n16\t16\tOI\t2026-09-25 00:00:00\t-2.00\t2.00\t86.00\tNULL\t1\r\n21\t1\tOD\t2026-09-28 00:00:00\t-2.00\t2.00\t90.00\tNULL\t1\r\n22\t1\tOD\t2026-09-28 00:00:00\tNULL\tNULL\t90.00\tNULL\t1\r\nid\tvisit_id\teye\texam_date\tcorneal_thickness\tpatient_id\r\n1\t1\tOD\t2026-09-25 00:00:00\t501.00\t1\r\n16\t1\tOD\t2026-09-28 00:00:00\t510.00\t1\r\n17\t1\tOD\t2026-09-28 00:00:00\t510.00\t1\r\nid\tvisit_id\teye\texam_date\tresult\tpatient_id\r\n1\t1\tOD\t2026-09-20 00:00:00\tDescripción ficticia\t1\r\nid\tglaucoma_record_id\tvisit_id\tcontrol_date\tglaucoma_type\ttarget_pressure\tclinical_status\tnotes\tpatient_id\r\n1\t1\t1\t2026-09-20 00:00:00\tNULL\t18.00\tSeguimiento ficticio\tNULL\t1\r\n7\t1\t1\t2026-09-28 00:00:00\tNULL\t19.00\tACTIVE\tPrueba académica\t1\r\nid\tvisit_id\tmedication_id\teye\tstart_date\tend_date\tactive\tdose\tfrequency\tnotes\tpatient_id\r\n1\t1\t2\tAO\t2026-09-25\t2026-10-01\t0\tNULL\tNULL\tNULL\t1\r\n16\t1\t2\tOD\t2026-09-26\t2026-10-01\t0\tNULL\tNULL\tPrueba académica\t1\r\n17\t1\t2\tOD\t2026-09-26\t2026-10-01\t0\tNULL\tNULL\tNULL\t1\r\nid\tvisit_id\teye\tprocedure_type\tprocedure_date\tnotes\tpatient_id\r\n1\t1\tOD\tQUIRURGICO:Ejemplo académico\t2026-09-21 00:00:00\tNULL\t1\r\nid\tpatient_id\teye\topened_at\tclosed_at\r\n1\t1\tOD\t2026-09-01 00:00:00\tNULL\r\nid\tclinical_history_id\tdocument_type\tfile_name\tfile_uri\tcreated_at\r\n1\t1\tInforme\tejemplo.txt\tpruebas/ejemplo.txt\t2026-10-08 20:55:29\r\n",
    "stderr": ""
  },
  {
    "n": 42,
    "name": "sp_iop_evolution",
    "query": "CALL sp_iop_evolution(1,'2026-01-01','2026-10-01');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n1\t1\tOD\t2026-09-01 11:00:00\t13.00\t1\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n16\t16\tOI\t2026-09-16 11:00:00\t28.00\t1\r\n46\t16\tOI\t2026-09-19 11:00:00\t22.00\t1\r\n51\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n52\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n53\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n54\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n",
    "stderr": ""
  },
  {
    "n": 43,
    "name": "sp_iop_by_eye",
    "query": "CALL sp_iop_by_eye(1,'OD');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n1\t1\tOD\t2026-09-01 11:00:00\t13.00\t1\r\n31\t1\tOD\t2026-09-04 11:00:00\t25.00\t1\r\n51\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n52\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n53\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n54\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n",
    "stderr": ""
  },
  {
    "n": 44,
    "name": "sp_monthly_visit_stats",
    "query": "CALL sp_monthly_visit_stats();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "month\ttotal\r\n2026-09\t33\r\n",
    "stderr": ""
  },
  {
    "n": 45,
    "name": "sp_patients_by_specialist",
    "query": "CALL sp_patients_by_specialist();",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tfirst_name\tlast_name\ttotal\r\n1\tPrueba\tPaciente\t8\r\n2\tProfesional2\tPrueba\t8\r\n3\tProfesional3\tPrueba\t7\r\n4\tProfesional4\tPrueba\t7\r\n5\tProfesional5\tPrueba\t0\r\n",
    "stderr": ""
  },
  {
    "n": 46,
    "name": "sp_patients_without_visit_months",
    "query": "CALL sp_patients_without_visit_months(3);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "updated_at\tid\tdocument_type_id\tdocument_number\tfirst_name\tlast_name\tbirth_date\tsex\tphone\temail\tcity\tcreated_at\r\n2026-10-08 20:55:28\t16\t1\t101016\tPaciente16\tPrueba\t1966-01-01\tM\t30000016\tNULL\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t17\t2\t101017\tPaciente17\tGómez\t1967-01-01\tF\t30000017\tpaciente17@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t18\t1\t101018\tPaciente18\tPrueba\t1968-01-01\tM\t30000018\tpaciente18@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t19\t2\t101019\tPaciente19\tGómez\t1969-01-01\tF\t30000019\tpaciente19@gmail.com\tBogotá\t2026-10-08 20:55:28\r\n2026-10-08 20:55:28\t20\t1\t101020\tPaciente20\tPrueba\t1970-01-01\tM\t30000020\tNULL\tNULL\t2026-10-08 20:55:28\r\n2026-10-08 20:55:35\t21\t1\tNUEVO901\tNuevo\tPrueba\t1970-01-01\tPrueba académica\tPrueba académica\tprueba académica\tPrueba académica\t2026-10-08 20:55:35\r\n",
    "stderr": ""
  },
  {
    "n": 47,
    "name": "sp_patient_diagnosis_summary",
    "query": "CALL sp_patient_diagnosis_summary(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "name\ttotal\r\nGlaucoma 1\t1\r\nGlaucoma 2\t1\r\nGlaucoma 3\t1\r\nDiagnóstico 7\t1\r\n",
    "stderr": ""
  },
  {
    "n": 48,
    "name": "sp_latest_eye_studies",
    "query": "CALL sp_latest_eye_studies(1);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "id\tvisit_id\teye\texam_date\trnfl\tinterpretation\tvalidated\tpatient_id\r\n21\t1\tOD\t2026-09-28 00:00:00\t80.00\tPrueba académica\t0\t1\r\nid\tvisit_id\teye\texam_date\tmd\tpsd\tvfi\tinterpretation\tpatient_id\r\n22\t1\tOD\t2026-09-28 00:00:00\tNULL\tNULL\t90.00\tNULL\t1\r\nid\tvisit_id\teye\tmeasured_at\tpressure\tpatient_id\r\n54\t1\tOD\t2026-09-28 00:00:00\t19.00\t1\r\n",
    "stderr": ""
  },
  {
    "n": 49,
    "name": "sp_visit_diagnosis_iop_tx",
    "query": "CALL sp_visit_diagnosis_iop_tx(1,1,'2026-09-28',1,'OD',19);",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  },
  {
    "n": 50,
    "name": "sp_complete_glaucoma_control_tx",
    "query": "CALL sp_complete_glaucoma_control_tx(1,1,'2026-09-28','OD',19,'Prueba académica');",
    "status": 0,
    "expected": "SUCCESS",
    "stdout": "",
    "stderr": ""
  }
]
```

</details>

<a id="e-resumen-mysql"></a>

#### resumen-mysql.txt

<details>
<summary>Ver registro completo</summary>

```text
version
8.0.46
TABLE_TYPE	total
BASE TABLE	23
VIEW	12
ROUTINE_TYPE	total
FUNCTION	50
PROCEDURE	50
total_triggers
57
pacientes
21
historias
21
consultas
34
auditorias
234
Tables_in_ophthalmology_modelo
audit_logs
clinical_documents
clinical_histories
diagnoses
document_types
glaucoma_controls
glaucoma_records
gonioscopy_exams
healthcare_professionals
intraocular_pressures
medical_histories
medical_visits
medications
notifications
oct_exams
ophthalmologic_exams
pachymetry_exams
patients
procedures
specialties
treatments
v_glaucoma_controls
v_glaucoma_records
v_gonioscopy_exams
v_intraocular_pressures
v_oct_exams
v_pachymetry_exams
v_procedures
v_treatments
v_visual_field_exams
visit_diagnoses
visual_field_exams
vw_active_treatments
vw_patient_last_visit
vw_patient_visit_count
```

</details>

<a id="e-staruml"></a>

#### staruml.json

<details>
<summary>Ver registro completo</summary>

```json
{
  "version": "7.1.1",
  "verification": "CLI loaded final MDJ and exported all 24 SVG diagrams",
  "guiInteractiveReview": false,
  "watermark": "UNREGISTERED retained",
  "svgPresentation": "White background rectangle added beneath exported elements; watermark retained",
  "mdjSHA256": "e905bf6201923b9a0d2c2f4780f310c3d1a51f2ee604ad91cc58b6b94e2e453f",
  "uniqueIds": 2169,
  "resolvedRefs": 4599,
  "files": [
    {
      "name": "01_Conceptual_01_Identidad_y_atencion.svg",
      "bytes": 670177
    },
    {
      "name": "01_Conceptual_02_Diagnosticos_y_antecedentes.svg",
      "bytes": 462589
    },
    {
      "name": "01_Conceptual_03_Examenes.svg",
      "bytes": 997294
    },
    {
      "name": "01_Conceptual_04_Glaucoma.svg",
      "bytes": 669518
    },
    {
      "name": "01_Conceptual_05_Terapia_y_archivos.svg",
      "bytes": 928459
    },
    {
      "name": "01_Conceptual_06_Soporte.svg",
      "bytes": 113056
    },
    {
      "name": "02_Logico_01_Identidad_y_atencion.svg",
      "bytes": 878275
    },
    {
      "name": "02_Logico_02_Diagnosticos_y_antecedentes.svg",
      "bytes": 681113
    },
    {
      "name": "02_Logico_03_Examenes.svg",
      "bytes": 1174799
    },
    {
      "name": "02_Logico_04_Glaucoma.svg",
      "bytes": 854688
    },
    {
      "name": "02_Logico_05_Terapia_y_archivos.svg",
      "bytes": 1141644
    },
    {
      "name": "02_Logico_06_Soporte.svg",
      "bytes": 262992
    },
    {
      "name": "03_DER_01_Identidad_y_atencion.svg",
      "bytes": 878275
    },
    {
      "name": "03_DER_02_Diagnosticos_y_antecedentes.svg",
      "bytes": 681113
    },
    {
      "name": "03_DER_03_Examenes.svg",
      "bytes": 1174799
    },
    {
      "name": "03_DER_04_Glaucoma.svg",
      "bytes": 854688
    },
    {
      "name": "03_DER_05_Terapia_y_archivos.svg",
      "bytes": 1141644
    },
    {
      "name": "03_DER_06_Soporte.svg",
      "bytes": 262992
    },
    {
      "name": "04_Fisico_MySQL_01_Identidad_y_atencion.svg",
      "bytes": 878290
    },
    {
      "name": "04_Fisico_MySQL_02_Diagnosticos_y_antecedentes.svg",
      "bytes": 681118
    },
    {
      "name": "04_Fisico_MySQL_03_Examenes.svg",
      "bytes": 1174730
    },
    {
      "name": "04_Fisico_MySQL_04_Glaucoma.svg",
      "bytes": 854675
    },
    {
      "name": "04_Fisico_MySQL_05_Terapia_y_archivos.svg",
      "bytes": 1141618
    },
    {
      "name": "04_Fisico_MySQL_06_Soporte.svg",
      "bytes": 263013
    }
  ]
}
```

</details>

<a id="e-transacciones"></a>

#### transacciones.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "name": "Consulta+diagnóstico+PIO",
    "query": "CALL sp_visit_diagnosis_iop_tx(1,1,'2026-09-30',1,'OD',-1)",
    "before": "n\r\n34\r\n",
    "after": "n\r\n34\r\n",
    "pass": true,
    "status": 1,
    "stderr": "ERROR 1644 (45000) at line 1: PIO negativa\r\n"
  },
  {
    "name": "Control+PIO",
    "query": "CALL sp_complete_glaucoma_control_tx(1,1,'2026-09-30','OD',-1,'Debe revertirse')",
    "before": "n\r\n8\r\n",
    "after": "n\r\n8\r\n",
    "pass": true,
    "status": 1,
    "stderr": "ERROR 1644 (45000) at line 1: PIO negativa\r\n"
  }
]
```

</details>

<a id="e-triggers-y-restricciones"></a>

#### triggers-y-restricciones.json

<details>
<summary>Ver registro completo</summary>

```json
[
  {
    "n": 1,
    "name": "TRIM nombres",
    "query": "INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT first_name='Nombre' AND last_name='Apellido' FROM patients WHERE id=LAST_INSERT_ID())",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 2,
    "name": "Correo minúsculas",
    "query": "INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT email='persona@example.com' FROM patients WHERE id=LAST_INSERT_ID())",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 3,
    "name": "Documento mayúsculas",
    "query": "INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT document_number='  XA001  ' FROM patients WHERE id=LAST_INSERT_ID())",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 4,
    "name": "Nacimiento futuro",
    "query": "INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date) VALUES(1,'FUT','A','B',DATE_ADD(CURDATE(),INTERVAL 1 DAY))",
    "assert": null,
    "expected": "Fecha de nacimiento futura",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Fecha de nacimiento futura\r\n"
  },
  {
    "n": 5,
    "name": "PIO negativa",
    "query": "INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',-1)",
    "assert": null,
    "expected": "PIO negativa",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: PIO negativa\r\n"
  },
  {
    "n": 6,
    "name": "Límite de ensayo",
    "query": "INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',61)",
    "assert": null,
    "expected": "límite académico",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Supera límite académico 60\r\n"
  },
  {
    "n": 7,
    "name": "Ojo inválido",
    "query": "INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'AO','2026-09-30',18)",
    "assert": null,
    "expected": "Ojo inválido",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Ojo inválido\r\n"
  },
  {
    "n": 8,
    "name": "Fechas de tratamiento",
    "query": "INSERT INTO treatments(visit_id,eye,start_date,end_date) VALUES(1,'OD','2026-09-30','2026-09-29')",
    "assert": null,
    "expected": "Fechas inválidas",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Fechas inválidas\r\n"
  },
  {
    "n": 9,
    "name": "VFI inválido",
    "query": "INSERT INTO visual_field_exams(visit_id,eye,exam_date,vfi) VALUES(1,'OD','2026-09-30',101)",
    "assert": null,
    "expected": "VFI fuera de rango",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: VFI fuera de rango\r\n"
  },
  {
    "n": 10,
    "name": "Paquimetría inválida",
    "query": "INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(1,'OD','2026-09-30',0)",
    "assert": null,
    "expected": "Paquimetría inválida",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Paquimetría inválida\r\n"
  },
  {
    "n": 11,
    "name": "Auditoría INSERT patients",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='INSERT'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 12,
    "name": "Auditoría INSERT clinical_histories",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='clinical_histories' AND action='INSERT'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='clinical_histories' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 13,
    "name": "Auditoría INSERT medical_visits",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='medical_visits' AND action='INSERT'); INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date) VALUES(1,1,'2026-09-30')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='medical_visits' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 14,
    "name": "Auditoría INSERT visit_diagnoses",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visit_diagnoses' AND action='INSERT'); INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye) VALUES(1,8,'OI')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visit_diagnoses' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 15,
    "name": "Auditoría INSERT intraocular_pressures",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='intraocular_pressures' AND action='INSERT'); INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',18)",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='intraocular_pressures' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 16,
    "name": "Auditoría INSERT treatments",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments' AND action='INSERT'); INSERT INTO treatments(visit_id,eye,start_date) VALUES(1,'OD','2026-09-30')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='treatments' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 17,
    "name": "Auditoría INSERT procedures",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='procedures' AND action='INSERT'); INSERT INTO procedures(visit_id,eye,procedure_type,procedure_date) VALUES(1,'OD','Ensayo','2026-09-30')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='procedures' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 18,
    "name": "Auditoría INSERT oct_exams",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='oct_exams' AND action='INSERT'); INSERT INTO oct_exams(visit_id,eye,exam_date) VALUES(1,'OD','2026-09-30')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='oct_exams' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 19,
    "name": "Auditoría INSERT visual_field_exams",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visual_field_exams' AND action='INSERT'); INSERT INTO visual_field_exams(visit_id,eye,exam_date) VALUES(1,'OD','2026-09-30')",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visual_field_exams' AND action='INSERT')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 20,
    "name": "Notificación umbral",
    "query": "SET @a=(SELECT COUNT(*) FROM notifications); INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',26)",
    "assert": "(SELECT COUNT(*)>@a FROM notifications)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 21,
    "name": "updated_at paciente",
    "query": "UPDATE patients SET updated_at='2000-01-01',phone='555' WHERE id=1",
    "assert": "(SELECT updated_at>'2000-01-01' FROM patients WHERE id=1)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 22,
    "name": "updated_at consulta",
    "query": "UPDATE medical_visits SET updated_at='2000-01-01',reason='Prueba' WHERE id=1",
    "assert": "(SELECT updated_at>'2000-01-01' FROM medical_visits WHERE id=1)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 23,
    "name": "Documento bloqueado",
    "query": "UPDATE patients SET document_number='CAMBIO' WHERE id=1",
    "assert": null,
    "expected": "Documento bloqueado",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Documento bloqueado\r\n"
  },
  {
    "n": 24,
    "name": "Consulta futura",
    "query": "UPDATE medical_visits SET visit_date=DATE_ADD(NOW(),INTERVAL 1 DAY) WHERE id=1",
    "assert": null,
    "expected": "no admiten fecha futura",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Consultas realizadas no admiten fecha futura\r\n"
  },
  {
    "n": 25,
    "name": "Objetivo inválido",
    "query": "UPDATE glaucoma_controls SET target_pressure=-1 WHERE id=1",
    "assert": null,
    "expected": "Presión objetivo inválida",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Presión objetivo inválida\r\n"
  },
  {
    "n": 26,
    "name": "Fecha final inválida",
    "query": "UPDATE treatments SET end_date='2000-01-01' WHERE id=1",
    "assert": null,
    "expected": "Fechas inválidas",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Fechas inválidas\r\n"
  },
  {
    "n": 27,
    "name": "OCT validado",
    "query": "UPDATE oct_exams SET validated=TRUE WHERE id=1; UPDATE oct_exams SET interpretation='Cambio' WHERE id=1",
    "assert": null,
    "expected": "OCT validado no modificable",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: OCT validado no modificable\r\n"
  },
  {
    "n": 28,
    "name": "Consulta cerrada",
    "query": "UPDATE medical_visits SET status='CLOSED' WHERE id=1; UPDATE medical_visits SET reason='Cambio' WHERE id=1",
    "assert": null,
    "expected": "Consulta cerrada",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Consulta cerrada\r\n"
  },
  {
    "n": 29,
    "name": "Campo visual inválido",
    "query": "UPDATE visual_field_exams SET vfi=101 WHERE id=1",
    "assert": null,
    "expected": "VFI fuera de rango",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: VFI fuera de rango\r\n"
  },
  {
    "n": 30,
    "name": "Observaciones TRIM",
    "query": "UPDATE medical_visits SET observations='  Texto  ' WHERE id=1",
    "assert": "(SELECT observations='Texto' FROM medical_visits WHERE id=1)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 31,
    "name": "Auditoría UPDATE patients",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='UPDATE'); UPDATE patients SET phone='NUEVO555' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 32,
    "name": "Auditoría UPDATE patients",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='UPDATE'); UPDATE patients SET email='nuevo@example.com' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 33,
    "name": "Auditoría UPDATE glaucoma_controls",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE'); UPDATE glaucoma_controls SET target_pressure=20 WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 34,
    "name": "Auditoría UPDATE glaucoma_controls",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE'); UPDATE glaucoma_controls SET clinical_status='Cambio' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 35,
    "name": "Auditoría UPDATE treatments",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments' AND action='UPDATE'); UPDATE treatments SET notes='Cambio' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='treatments' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 36,
    "name": "Auditoría UPDATE diagnoses",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='diagnoses' AND action='UPDATE'); UPDATE diagnoses SET name='Cambio' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='diagnoses' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 37,
    "name": "Auditoría UPDATE oct_exams",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='oct_exams' AND action='UPDATE'); UPDATE oct_exams SET interpretation='Cambio' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='oct_exams' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 38,
    "name": "Auditoría UPDATE visual_field_exams",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visual_field_exams' AND action='UPDATE'); UPDATE visual_field_exams SET interpretation='Cambio' WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visual_field_exams' AND action='UPDATE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 39,
    "name": "Alerta sobre objetivo",
    "query": "UPDATE glaucoma_controls SET target_pressure=18 WHERE glaucoma_record_id=1; SET @a=(SELECT COUNT(*) FROM notifications); UPDATE intraocular_pressures SET measured_at='2026-09-30',pressure=30 WHERE id=1",
    "assert": "(SELECT COUNT(*)>@a FROM notifications)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 40,
    "name": "Finalización sin doble auditoría",
    "query": "UPDATE treatments SET active=TRUE WHERE id=1; SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments'); UPDATE treatments SET active=FALSE WHERE id=1",
    "assert": "(SELECT COUNT(*)=@a+1 FROM audit_logs WHERE table_name='treatments')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 41,
    "name": "Copia paciente: DELETE rechazado",
    "query": "DELETE FROM patients WHERE id=1",
    "assert": null,
    "expected": "Paciente con historia clínica",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Paciente con historia clínica\r\n"
  },
  {
    "n": 42,
    "name": "Copia consulta eliminable",
    "query": "INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date) VALUES(1,1,'2026-09-30'); SET @v=LAST_INSERT_ID(); DELETE FROM medical_visits WHERE id=@v",
    "assert": "EXISTS(SELECT 1 FROM audit_logs WHERE table_name='medical_visits' AND record_key=CAST(@v AS CHAR) AND action='DELETE' AND old_data IS NOT NULL)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 43,
    "name": "Copia tratamiento",
    "query": "DELETE FROM treatments WHERE id=1",
    "assert": "EXISTS(SELECT 1 FROM audit_logs WHERE table_name='treatments' AND record_key='1' AND action='DELETE' AND old_data IS NOT NULL)",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 44,
    "name": "Borrado diagnóstico sin uso",
    "query": "DELETE FROM diagnoses WHERE id=10",
    "assert": "EXISTS(SELECT 1 FROM audit_logs WHERE table_name='diagnoses' AND record_key='10' AND action='DELETE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 45,
    "name": "Proteger paciente",
    "query": "DELETE FROM patients WHERE id=1",
    "assert": null,
    "expected": "Paciente con historia clínica",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Paciente con historia clínica\r\n"
  },
  {
    "n": 46,
    "name": "Proteger profesional",
    "query": "DELETE FROM healthcare_professionals WHERE id=1",
    "assert": null,
    "expected": "Profesional con consultas",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Profesional con consultas\r\n"
  },
  {
    "n": 47,
    "name": "Proteger medicamento activo",
    "query": "DELETE FROM medications WHERE id=2",
    "assert": null,
    "expected": "Medicamento en tratamiento activo",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Medicamento en tratamiento activo\r\n"
  },
  {
    "n": 48,
    "name": "Auditar borrado OCT",
    "query": "DELETE FROM oct_exams WHERE id=1",
    "assert": "EXISTS(SELECT 1 FROM audit_logs WHERE table_name='oct_exams' AND record_key='1' AND action='DELETE')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 49,
    "name": "Identidad sesión al borrar documento",
    "query": "DELETE FROM clinical_documents WHERE id=1",
    "assert": "EXISTS(SELECT 1 FROM audit_logs WHERE table_name='clinical_documents' AND record_key='1' AND action='DELETE' AND changed_by=USER())",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 50,
    "name": "Auditoría integrada paciente",
    "query": "SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM'); SET @p=LAST_INSERT_ID(); UPDATE patients SET phone='555' WHERE id=@p",
    "assert": "(SELECT COUNT(*)=@a+2 FROM audit_logs WHERE table_name='patients')",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 51,
    "name": "Una sola historia",
    "query": "INSERT INTO clinical_histories(patient_id,history_number) VALUES(1,'DUP')",
    "assert": null,
    "expected": "Duplicate entry",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1062 (23000) at line 1: Duplicate entry '1' for key 'clinical_histories.patient_id'\r\n"
  },
  {
    "n": 52,
    "name": "Paciente de control",
    "query": "INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date) VALUES(1,2,'2026-09-30')",
    "assert": null,
    "expected": "pacientes diferentes",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1644 (45000) at line 1: Control y consulta pertenecen a pacientes diferentes\r\n"
  },
  {
    "n": 53,
    "name": "Principal por consulta y ojo",
    "query": "INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(1,8,'OD',TRUE)",
    "assert": null,
    "expected": "Duplicate entry",
    "pass": true,
    "status": 1,
    "stdout": "",
    "stderr": "ERROR 1062 (23000) at line 1: Duplicate entry '1:OD' for key 'visit_diagnoses.primary_visit_eye'\r\n"
  },
  {
    "n": 54,
    "name": "Identidad OD/OI",
    "query": "SELECT fn_first_last_iop_diff(20,'OD') IS NULL AS ok",
    "assert": null,
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 55,
    "name": "Nacimiento e historia total",
    "query": "INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM')",
    "assert": "(SELECT COUNT(*)=1 FROM clinical_histories WHERE patient_id=LAST_INSERT_ID())",
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "ok\r\n1\r\n",
    "stderr": ""
  },
  {
    "n": 56,
    "name": "Cero consultas incluido en reporte",
    "query": "SELECT visit_count FROM vw_patient_visit_count WHERE patient_id=20",
    "assert": null,
    "expected": "SUCCESS",
    "pass": true,
    "status": 0,
    "stdout": "visit_count\r\n0\r\n",
    "stderr": ""
  }
]
```

</details>


<a id="punto-42"></a>

# 42. Pregunta orientadora final

**¿Cómo modelar, normalizar e implementar en MySQL una base de datos relacional para historias clínicas de oftalmología y glaucoma que permita garantizar integridad, reducir redundancia y soportar consultas y procesos SQL de diferentes niveles de complejidad?**

<a id="banco-original"></a>

# Banco de 250 ejercicios MySQL

## Proyecto: Historias clínicas de Oftalmología y Glaucoma

Este banco de ejercicios está organizado en cinco categorías:

1. Consultas SQL.
2. Subconsultas.
3. Procedimientos almacenados.
4. Triggers.
5. Funciones almacenadas.

Cada categoría contiene **50 ejercicios**, para un total de **250 actividades**.

Como referencia, se asume que la base de datos contiene entidades similares a:

```
patients
clinical_histories
medical_visits
healthcare_professionals
specialties
diagnoses
visit_diagnoses
glaucoma_records
glaucoma_controls
intraocular_pressures
pachymetry_exams
gonioscopy_exams
oct_exams
visual_field_exams
medications
treatments
procedures
clinical_documents
audit_logs
```


<a id="parte-1"></a>

# PARTE I — 50 EJERCICIOS DE CONSULTAS SQL

## Nivel básico

<a id="ejercicio-1-1"></a>

### 1.

Mostrar todos los pacientes registrados en la base de datos.

**Respuesta:**

```sql
SELECT *
FROM patients;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-2"></a>

### 2.

Mostrar únicamente el número de documento, nombres y apellidos de todos los pacientes.

**Respuesta:**

```sql
SELECT
    document_number,
first_name,
last_name
FROM patients;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-3"></a>

### 3.

Listar todos los profesionales de salud registrados.

**Respuesta:**

```sql
SELECT *
FROM healthcare_professionals;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-4"></a>

### 4.

Mostrar todos los diagnósticos disponibles en el catálogo.

**Respuesta:**

```sql
SELECT *
FROM diagnoses;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-5"></a>

### 5.

Consultar todas las historias clínicas registradas.

**Respuesta:**

```sql
SELECT *
FROM clinical_histories;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-6"></a>

### 6.

Mostrar todos los pacientes ordenados alfabéticamente por apellido.

**Respuesta:**

```sql
SELECT *
FROM patients
ORDER BY last_name, first_name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-7"></a>

### 7.

Mostrar los pacientes ordenados por fecha de nacimiento desde el más joven hasta el de mayor edad.

**Respuesta:**

```sql
SELECT *
FROM patients
ORDER BY birth_date DESC;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-8"></a>

### 8.

Consultar los pacientes cuyo apellido sea `Gómez`.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE last_name = 'Gómez';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-9"></a>

### 9.

Mostrar los pacientes cuyo número de documento comience por `10`.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE document_number LIKE '10%';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-10"></a>

### 10.

Consultar los pacientes cuyo correo electrónico pertenezca al dominio `gmail.com`.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE email LIKE '%@gmail.com';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-11"></a>

### 11.

Mostrar los pacientes que no tengan correo electrónico registrado.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE email IS NULL;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-12"></a>

### 12.

Mostrar los profesionales cuya especialidad sea Oftalmología.

**Respuesta:**

```sql
SELECT hp.*
FROM healthcare_professionals hp
JOIN specialties s
    ON s.id=hp.specialty_id
WHERE s.name='Oftalmología';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-13"></a>

### 13.

Consultar todas las consultas médicas realizadas durante el año 2026.

**Respuesta:**

```sql
SELECT *
FROM medical_visits
WHERE visit_date >= '2026-01-01'
    AND visit_date < '2027-01-01';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-14"></a>

### 14.

Mostrar las consultas realizadas durante un mes determinado.

**Respuesta:**

```sql
SELECT *
FROM medical_visits
WHERE visit_date >= '2026-10-01'
    AND visit_date < '2026-11-01';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-15"></a>

### 15.

Consultar las mediciones de presión intraocular superiores a 20 mmHg.

**Respuesta:**

```sql
SELECT *
FROM v_intraocular_pressures
WHERE pressure > 20;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-16"></a>

### 16.

Mostrar las mediciones de presión intraocular correspondientes únicamente al ojo derecho.

**Respuesta:**

```sql
SELECT *
FROM v_intraocular_pressures
WHERE eye='OD';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-17"></a>

### 17.

Mostrar las mediciones correspondientes únicamente al ojo izquierdo.

**Respuesta:**

```sql
SELECT *
FROM v_intraocular_pressures
WHERE eye='OI';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-18"></a>

### 18.

Consultar todos los tratamientos que se encuentren activos.

**Respuesta:**

```sql
SELECT *
FROM v_treatments
WHERE active=TRUE;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-19"></a>

### 19.

Mostrar todos los tratamientos que hayan finalizado.

**Respuesta:**

```sql
SELECT *
FROM v_treatments
WHERE active=FALSE
    OR (end_date IS NOT NULL
    AND end_date <= CURRENT_DATE);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-20"></a>

### 20.

Consultar los procedimientos realizados después de una fecha determinada.

**Respuesta:**

```sql
SELECT *
FROM v_procedures
WHERE procedure_date > '2026-01-01';
```

## Nivel intermedio

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-21"></a>

### 21.

Mostrar cada paciente junto con el número de su historia clínica.

**Respuesta:**

```sql
SELECT
    p.first_name,
p.last_name,
ch.history_number
FROM patients p
JOIN clinical_histories ch
    ON ch.patient_id=p.id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-22"></a>

### 22.

Mostrar cada consulta indicando el nombre completo del paciente.

**Respuesta:**

```sql
SELECT
    mv.*,
    CONCAT(p.first_name,' ',p.last_name) patient
FROM medical_visits mv
JOIN clinical_histories ch
    ON ch.id=mv.clinical_history_id
JOIN patients p
    ON p.id=ch.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-23"></a>

### 23.

Mostrar cada consulta junto con el nombre del profesional que la realizó.

**Respuesta:**

```sql
SELECT
    mv.*,
    CONCAT(hp.first_name,' ',hp.last_name) professional
FROM medical_visits mv
JOIN healthcare_professionals hp
    ON hp.id=mv.professional_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-24"></a>

### 24.

Listar todos los pacientes junto con la fecha de sus consultas.

**Respuesta:**

```sql
SELECT
    p.first_name,
p.last_name,
mv.visit_date
FROM patients p
JOIN clinical_histories ch
    ON ch.patient_id=p.id
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-25"></a>

### 25.

Mostrar los diagnósticos asociados a cada consulta.

**Respuesta:**

```sql
SELECT
    mv.id,
mv.visit_date,
d.code,
d.name
FROM medical_visits mv
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
JOIN diagnoses d
    ON d.id=vd.diagnosis_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-26"></a>

### 26.

Mostrar nombre del paciente, fecha de consulta y diagnóstico correspondiente.

**Respuesta:**

```sql
SELECT
    CONCAT(p.first_name,' ',p.last_name) patient,
mv.visit_date,
d.name diagnosis
FROM patients p
JOIN clinical_histories ch
    ON ch.patient_id=p.id
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
JOIN diagnoses d
    ON d.id=vd.diagnosis_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-27"></a>

### 27.

Consultar todos los pacientes que tengan diagnóstico de glaucoma.

**Respuesta:**

```sql
SELECT DISTINCT p.*
FROM patients p
JOIN clinical_histories ch
    ON ch.patient_id=p.id
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
JOIN diagnoses d
    ON d.id=vd.diagnosis_id
WHERE d.name LIKE '%Glaucoma%';
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-28"></a>

### 28.

Mostrar todos los controles de glaucoma indicando el paciente correspondiente.

**Respuesta:**

```sql
SELECT
    gc.*,
    CONCAT(p.first_name,' ',p.last_name) patient
FROM v_glaucoma_controls gc
JOIN patients p
    ON p.id=gc.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-29"></a>

### 29.

Mostrar cada medición de presión intraocular junto con nombre del paciente, fecha y ojo.

**Respuesta:**

```sql
SELECT
    iop.pressure,
iop.measured_at,
iop.eye,
CONCAT(p.first_name,' ',p.last_name) patient
FROM v_intraocular_pressures iop
JOIN patients p
    ON p.id=iop.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-30"></a>

### 30.

Mostrar los estudios OCT realizados indicando paciente, ojo y fecha.

**Respuesta:**

```sql
SELECT
    o.exam_date,
o.eye,
o.rnfl,
CONCAT(p.first_name,' ',p.last_name) patient
FROM v_oct_exams o
JOIN patients p
    ON p.id=o.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-31"></a>

### 31.

Mostrar los campos visuales registrados indicando paciente, ojo, MD, PSD y VFI.

**Respuesta:**

```sql
SELECT
    vf.exam_date,
vf.eye,
vf.md,
vf.psd,
vf.vfi,
CONCAT(p.first_name,' ',p.last_name) patient
FROM v_visual_field_exams vf
JOIN patients p
    ON p.id=vf.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-32"></a>

### 32.

Mostrar las paquimetrías realizadas junto con el paciente y el espesor corneal registrado.

**Respuesta:**

```sql
SELECT
    pe.exam_date,
pe.eye,
pe.corneal_thickness,
CONCAT(p.first_name,' ',p.last_name) patient
FROM v_pachymetry_exams pe
JOIN patients p
    ON p.id=pe.patient_id;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-33"></a>

### 33.

Mostrar los tratamientos activos incluyendo nombre del paciente y medicamento.

**Respuesta:**

```sql
SELECT
    t.*,
CONCAT(p.first_name,' ',p.last_name) patient,
m.name medication
FROM v_treatments t
JOIN patients p
    ON p.id=t.patient_id
LEFT JOIN medications m
    ON m.id=t.medication_id
WHERE t.active=TRUE;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-34"></a>

### 34.

Mostrar cada medicamento y la cantidad de tratamientos en los que ha sido utilizado.

**Respuesta:**

```sql
SELECT
    m.id,
m.name,
COUNT(t.id) treatment_count
FROM medications m
LEFT JOIN v_treatments t
    ON t.medication_id=m.id
GROUP BY m.id,m.name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-35"></a>

### 35.

Mostrar la cantidad total de pacientes registrados.

**Respuesta:**

```sql
SELECT COUNT(*) total_patients
FROM patients;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-36"></a>

### 36.

Mostrar la cantidad de consultas realizadas.

**Respuesta:**

```sql
SELECT COUNT(*) total_visits
FROM medical_visits;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-37"></a>

### 37.

Mostrar la cantidad de pacientes por sexo.

**Respuesta:**

```sql
SELECT
    sex,
    COUNT(*) total
FROM patients
GROUP BY sex;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-38"></a>

### 38.

Mostrar la cantidad de pacientes atendidos por cada profesional.

**Respuesta:**

```sql
SELECT
    hp.id,
hp.first_name,
hp.last_name,
COUNT(DISTINCT ch.patient_id) patients_seen
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv
    ON mv.professional_id=hp.id
LEFT JOIN clinical_histories ch
    ON ch.id=mv.clinical_history_id
GROUP BY hp.id,hp.first_name,hp.last_name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-39"></a>

### 39.

Calcular el promedio general de presión intraocular.

**Respuesta:**

```sql
SELECT AVG(pressure) average_pressure
FROM v_intraocular_pressures;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-40"></a>

### 40.

Calcular la presión intraocular mínima y máxima registrada.

**Respuesta:**

```sql
SELECT
    MIN(pressure) minimum_pressure,
    MAX(pressure) maximum_pressure
FROM v_intraocular_pressures;
```

## Nivel avanzado

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-41"></a>

### 41.

Calcular la presión intraocular promedio para OD y OI por separado.

**Respuesta:**

```sql
SELECT
    eye,
    AVG(pressure) average_pressure
FROM v_intraocular_pressures
GROUP BY eye;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-42"></a>

### 42.

Mostrar la cantidad de consultas realizadas por cada paciente.

**Respuesta:**

```sql
SELECT
    p.id,
p.first_name,
p.last_name,
COUNT(mv.id) visit_count
FROM patients p
LEFT JOIN clinical_histories ch
    ON ch.patient_id=p.id
LEFT JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
GROUP BY p.id,p.first_name,p.last_name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-43"></a>

### 43.

Mostrar únicamente los pacientes que tengan tres o más consultas.

**Respuesta:**

```sql
SELECT
    p.id,
p.first_name,
p.last_name,
COUNT(mv.id) visit_count
FROM patients p
JOIN clinical_histories ch
    ON ch.patient_id=p.id
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
GROUP BY p.id,p.first_name,p.last_name
HAVING COUNT(mv.id)>=3;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-44"></a>

### 44.

Mostrar cada profesional junto con la cantidad de consultas realizadas.

**Respuesta:**

```sql
SELECT
    hp.id,
hp.first_name,
hp.last_name,
COUNT(mv.id) visit_count
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv
    ON mv.professional_id=hp.id
GROUP BY hp.id,hp.first_name,hp.last_name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-45"></a>

### 45.

Mostrar los profesionales que hayan realizado más de 20 consultas.

**Respuesta:**

```sql
SELECT
    hp.id,
hp.first_name,
hp.last_name,
COUNT(mv.id) visit_count
FROM healthcare_professionals hp
JOIN medical_visits mv
    ON mv.professional_id=hp.id
GROUP BY hp.id,hp.first_name,hp.last_name
HAVING COUNT(mv.id)>20;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-46"></a>

### 46.

Calcular la cantidad de diagnósticos registrados por tipo de diagnóstico.

**Respuesta:**

```sql
SELECT
    d.id,
d.name,
COUNT(vd.visit_id) total
FROM diagnoses d
LEFT JOIN visit_diagnoses vd
    ON vd.diagnosis_id=d.id
GROUP BY d.id,d.name;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-47"></a>

### 47.

Mostrar los cinco diagnósticos más frecuentes.

**Respuesta:**

```sql
SELECT
    d.id,
d.name,
COUNT(*) frequency
FROM diagnoses d
JOIN visit_diagnoses vd
    ON vd.diagnosis_id=d.id
GROUP BY d.id,d.name
ORDER BY frequency DESC
LIMIT 5;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-48"></a>

### 48.

Mostrar la cantidad de estudios OCT realizados por mes.

**Respuesta:**

```sql
SELECT
    DATE_FORMAT(exam_date,'%Y-%m') month,
    COUNT(*) total
FROM v_oct_exams
GROUP BY DATE_FORMAT(exam_date,'%Y-%m')
ORDER BY month;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-49"></a>

### 49.

Mostrar la cantidad de campos visuales realizados por año.

**Respuesta:**

```sql
SELECT
    YEAR(exam_date) year,
    COUNT(*) total
FROM v_visual_field_exams
GROUP BY YEAR(exam_date)
ORDER BY year;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-1-50"></a>

### 50.

Generar un reporte que muestre por paciente: nombre completo, número de consultas, cantidad de controles de glaucoma, promedio de PIO y fecha de última consulta.

**Respuesta:**

Las agregaciones independientes evitan multiplicar mediciones por los JOIN.

```sql
SELECT p.id, CONCAT(p.first_name,' ',p.last_name) patient,
 (SELECT COUNT(*) FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p.id) visits,
 (SELECT COUNT(*) FROM v_glaucoma_controls gc WHERE gc.patient_id=p.id) glaucoma_controls,
 (SELECT AVG(i.pressure) FROM v_intraocular_pressures i WHERE i.patient_id=p.id) average_iop,
 (SELECT MAX(mv.visit_date) FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p.id) last_visit
FROM patients p;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="parte-2"></a>

# PARTE II — 50 EJERCICIOS DE SUBCONSULTAS

## Subconsultas escalares

<a id="ejercicio-2-1"></a>

### 1.

Mostrar los pacientes cuya edad sea superior a la edad promedio de todos los pacientes.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE TIMESTAMPDIFF(YEAR,birth_date,CURDATE()) > (SELECT AVG(TIMESTAMPDIFF(YEAR,birth_date,CURDATE()))
FROM patients);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-2"></a>

### 2.

Mostrar los pacientes cuya edad sea inferior a la edad promedio.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE TIMESTAMPDIFF(YEAR,birth_date,CURDATE()) < (SELECT AVG(TIMESTAMPDIFF(YEAR,birth_date,CURDATE()))
FROM patients);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-3"></a>

### 3.

Consultar la medición de presión intraocular más alta registrada.

**Respuesta:**

```sql
SELECT MAX(pressure) maximum_pressure
FROM v_intraocular_pressures;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-4"></a>

### 4.

Mostrar todas las mediciones que tengan el mismo valor que la presión máxima registrada.

**Respuesta:**

```sql
SELECT *
FROM v_intraocular_pressures
WHERE pressure=(SELECT MAX(pressure)
FROM v_intraocular_pressures);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-5"></a>

### 5.

Mostrar la presión intraocular mínima registrada.

**Respuesta:**

```sql
SELECT MIN(pressure) minimum_pressure
FROM v_intraocular_pressures;
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-6"></a>

### 6.

Mostrar los estudios OCT cuyo RNFL sea inferior al promedio general.

**Respuesta:**

```sql
SELECT *
FROM v_oct_exams
WHERE rnfl < (SELECT AVG(rnfl)
FROM v_oct_exams);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-7"></a>

### 7.

Mostrar los estudios OCT cuyo RNFL sea superior al promedio general.

**Respuesta:**

```sql
SELECT *
FROM v_oct_exams
WHERE rnfl > (SELECT AVG(rnfl)
FROM v_oct_exams);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-8"></a>

### 8.

Consultar pacientes cuya cantidad de consultas sea mayor que el promedio de consultas por paciente.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT COUNT(*)
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
WHERE ch.patient_id=p.id) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(mv.id) cnt
FROM patients p2
LEFT JOIN clinical_histories ch
    ON ch.patient_id=p2.id
LEFT JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
GROUP BY p2.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-9"></a>

### 9.

Mostrar profesionales cuya cantidad de consultas sea superior al promedio por profesional.

**Respuesta:**

```sql
SELECT hp.*
FROM healthcare_professionals hp
WHERE (SELECT COUNT(*)
FROM medical_visits mv
WHERE mv.professional_id=hp.id) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(mv.id) cnt
FROM healthcare_professionals h
LEFT JOIN medical_visits mv
    ON mv.professional_id=h.id
GROUP BY h.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-10"></a>

### 10.

Consultar pacientes cuya última presión intraocular sea superior al promedio general.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT i.pressure
FROM v_intraocular_pressures i
WHERE i.patient_id=p.id
ORDER BY i.measured_at DESC,i.id DESC
LIMIT 1) > (SELECT AVG(pressure)
FROM v_intraocular_pressures);
```

## Subconsultas con IN

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-11"></a>

### 11.

Mostrar pacientes que tengan al menos una consulta registrada.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT ch.patient_id
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-12"></a>

### 12.

Mostrar pacientes que tengan diagnóstico de glaucoma.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT ch.patient_id
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
JOIN diagnoses d
    ON d.id=vd.diagnosis_id
WHERE d.name LIKE '%Glaucoma%');
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-13"></a>

### 13.

Mostrar pacientes que hayan recibido tratamiento farmacológico.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT patient_id
FROM v_treatments
WHERE medication_id IS NOT NULL);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-14"></a>

### 14.

Mostrar pacientes que tengan estudios OCT registrados.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT patient_id
FROM v_oct_exams);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-15"></a>

### 15.

Mostrar pacientes que tengan campos visuales registrados.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT patient_id
FROM v_visual_field_exams);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-16"></a>

### 16.

Mostrar medicamentos que hayan sido utilizados en al menos un tratamiento.

**Respuesta:**

```sql
SELECT *
FROM medications
WHERE id IN (SELECT medication_id
FROM v_treatments
WHERE medication_id IS NOT NULL);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-17"></a>

### 17.

Mostrar profesionales que hayan atendido pacientes con glaucoma.

**Respuesta:**

```sql
SELECT *
FROM healthcare_professionals
WHERE id IN (SELECT DISTINCT mv.professional_id
FROM medical_visits mv
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
JOIN diagnoses d
    ON d.id=vd.diagnosis_id
WHERE d.name LIKE '%Glaucoma%');
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-18"></a>

### 18.

Mostrar diagnósticos utilizados en alguna consulta.

**Respuesta:**

```sql
SELECT *
FROM diagnoses
WHERE id IN (SELECT diagnosis_id
FROM visit_diagnoses);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-19"></a>

### 19.

Mostrar pacientes que hayan tenido algún procedimiento quirúrgico.

**Respuesta:**

Convención académica explícita: el tipo de procedimiento quirúrgico usa el prefijo QUIRURGICO:.

```sql
SELECT p.* FROM patients p WHERE EXISTS(SELECT 1 FROM v_procedures pr WHERE pr.patient_id=p.id AND pr.procedure_type LIKE 'QUIRURGICO:%');
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-20"></a>

### 20.

Mostrar pacientes que tengan registros de paquimetría.

**Respuesta:**

```sql
SELECT *
FROM patients
WHERE id IN (SELECT patient_id
FROM v_pachymetry_exams);
```

## Subconsultas con NOT IN / NOT EXISTS

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-21"></a>

### 21.

Mostrar pacientes que nunca hayan tenido una consulta.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
WHERE ch.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-22"></a>

### 22.

Mostrar pacientes que nunca hayan tenido un control de glaucoma.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_glaucoma_controls gc
WHERE gc.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-23"></a>

### 23.

Mostrar pacientes que no tengan estudios OCT.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_oct_exams o
WHERE o.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-24"></a>

### 24.

Mostrar pacientes que no tengan campos visuales.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_visual_field_exams v
WHERE v.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-25"></a>

### 25.

Mostrar medicamentos que nunca hayan sido utilizados.

**Respuesta:**

```sql
SELECT m.*
FROM medications m
WHERE NOT EXISTS (SELECT 1
FROM v_treatments t
WHERE t.medication_id=m.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-26"></a>

### 26.

Mostrar profesionales que todavía no hayan registrado consultas.

**Respuesta:**

```sql
SELECT hp.*
FROM healthcare_professionals hp
WHERE NOT EXISTS (SELECT 1
FROM medical_visits mv
WHERE mv.professional_id=hp.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-27"></a>

### 27.

Mostrar diagnósticos que nunca hayan sido asociados a una consulta.

**Respuesta:**

```sql
SELECT d.*
FROM diagnoses d
WHERE NOT EXISTS (SELECT 1
FROM visit_diagnoses vd
WHERE vd.diagnosis_id=d.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-28"></a>

### 28.

Mostrar pacientes que no tengan tratamientos activos.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_treatments t
WHERE t.patient_id=p.id
    AND t.active=TRUE);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-29"></a>

### 29.

Mostrar pacientes que nunca hayan tenido procedimientos.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_procedures pr
WHERE pr.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-30"></a>

### 30.

Mostrar pacientes sin mediciones de presión intraocular.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE NOT EXISTS (SELECT 1
FROM v_intraocular_pressures i
WHERE i.patient_id=p.id);
```

## Subconsultas correlacionadas

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-31"></a>

### 31.

Mostrar las mediciones de PIO superiores al promedio del mismo paciente.

**Respuesta:**

```sql
SELECT i.*
FROM v_intraocular_pressures i
WHERE i.pressure > (SELECT AVG(i2.pressure)
FROM v_intraocular_pressures i2
WHERE i2.patient_id=i.patient_id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-32"></a>

### 32.

Mostrar los estudios OCT cuyo RNFL sea inferior al promedio del mismo paciente.

**Respuesta:**

```sql
SELECT o.*
FROM v_oct_exams o
WHERE o.rnfl < (SELECT AVG(o2.rnfl)
FROM v_oct_exams o2
WHERE o2.patient_id=o.patient_id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-33"></a>

### 33.

Mostrar las consultas posteriores a la primera consulta de cada paciente.

**Respuesta:**

```sql
SELECT mv.*
FROM medical_visits mv
JOIN clinical_histories ch
    ON ch.id=mv.clinical_history_id
WHERE mv.visit_date > (SELECT MIN(mv2.visit_date)
FROM medical_visits mv2
JOIN clinical_histories ch2
    ON ch2.id=mv2.clinical_history_id
WHERE ch2.patient_id=ch.patient_id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-34"></a>

### 34.

Mostrar la última consulta de cada paciente utilizando una subconsulta correlacionada.

**Respuesta:**

```sql
SELECT mv.* FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=(SELECT m2.id FROM medical_visits m2 WHERE m2.clinical_history_id=ch.id ORDER BY m2.visit_date DESC,m2.id DESC LIMIT 1);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-35"></a>

### 35.

Mostrar la primera medición de PIO de cada paciente.

**Respuesta:**

```sql
SELECT i.* FROM v_intraocular_pressures i WHERE i.id=(SELECT i2.id FROM v_intraocular_pressures i2 WHERE i2.patient_id=i.patient_id ORDER BY i2.measured_at,i2.id LIMIT 1);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-36"></a>

### 36.

Mostrar la última medición de presión intraocular de cada paciente y ojo.

**Respuesta:**

```sql
SELECT i.* FROM v_intraocular_pressures i WHERE i.id=(SELECT i2.id FROM v_intraocular_pressures i2 WHERE i2.patient_id=i.patient_id AND i2.eye=i.eye ORDER BY i2.measured_at DESC,i2.id DESC LIMIT 1);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-37"></a>

### 37.

Mostrar los tratamientos cuya fecha de inicio sea posterior a la primera consulta del paciente.

**Respuesta:**

```sql
SELECT t.*
FROM v_treatments t
WHERE t.start_date > (SELECT DATE(MIN(mv.visit_date))
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
WHERE ch.patient_id=t.patient_id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-38"></a>

### 38.

Mostrar pacientes cuyo número de consultas sea mayor que el de todos los demás pacientes de su misma ciudad.

**Respuesta:**

Mayor estrictamente; se excluye al propio paciente. Un paciente sin vecinos de ciudad satisface > ALL del conjunto vacío.

```sql
SELECT p.* FROM patients p WHERE (SELECT visit_count FROM vw_patient_visit_count WHERE patient_id=p.id) > ALL (SELECT c.visit_count FROM patients p2 JOIN vw_patient_visit_count c ON c.patient_id=p2.id WHERE p2.id<>p.id AND p2.city <=> p.city);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-39"></a>

### 39.

Mostrar profesionales cuya cantidad de consultas sea superior al promedio de los profesionales de su especialidad.

**Respuesta:**

```sql
SELECT h.* FROM healthcare_professionals h WHERE (SELECT COUNT(*) FROM medical_visits m WHERE m.professional_id=h.id) > (SELECT COUNT(*) FROM medical_visits m JOIN healthcare_professionals h2 ON h2.id=m.professional_id WHERE h2.specialty_id=h.specialty_id)/(SELECT COUNT(*) FROM healthcare_professionals h3 WHERE h3.specialty_id=h.specialty_id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-40"></a>

### 40.

Mostrar el estudio OCT más reciente de cada paciente.

**Respuesta:**

```sql
SELECT o.* FROM v_oct_exams o WHERE o.id=(SELECT o2.id FROM v_oct_exams o2 WHERE o2.patient_id=o.patient_id ORDER BY o2.exam_date DESC,o2.id DESC LIMIT 1);
```

## Subconsultas avanzadas

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-41"></a>

### 41.

Mostrar pacientes cuya presión intraocular máxima sea mayor que la presión máxima promedio de todos los pacientes.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT MAX(i.pressure)
FROM v_intraocular_pressures i
WHERE i.patient_id=p.id) > (SELECT AVG(x.mx)
FROM (SELECT MAX(pressure) mx
FROM v_intraocular_pressures
GROUP BY patient_id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-42"></a>

### 42.

Mostrar pacientes cuya cantidad de diagnósticos diferentes sea superior al promedio.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT COUNT(DISTINCT vd.diagnosis_id)
FROM clinical_histories ch
JOIN medical_visits mv
    ON mv.clinical_history_id=ch.id
JOIN visit_diagnoses vd
    ON vd.visit_id=mv.id
WHERE ch.patient_id=p.id) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(DISTINCT vd2.diagnosis_id) cnt
FROM patients p2
LEFT JOIN clinical_histories ch2
    ON ch2.patient_id=p2.id
LEFT JOIN medical_visits mv2
    ON mv2.clinical_history_id=ch2.id
LEFT JOIN visit_diagnoses vd2
    ON vd2.visit_id=mv2.id
GROUP BY p2.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-43"></a>

### 43.

Mostrar los pacientes que tengan más tratamientos activos que el promedio de tratamientos activos por paciente.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT COUNT(*)
FROM v_treatments t
WHERE t.patient_id=p.id
    AND t.active=TRUE) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(t2.id) cnt
FROM patients p2
LEFT JOIN v_treatments t2
    ON t2.patient_id=p2.id
    AND t2.active=TRUE
GROUP BY p2.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-44"></a>

### 44.

Mostrar el medicamento más utilizado en tratamientos.

**Respuesta:**

```sql
SELECT m.*
FROM medications m
WHERE (SELECT COUNT(*)
FROM v_treatments t
WHERE t.medication_id=m.id)=(SELECT MAX(x.cnt)
FROM (SELECT COUNT(*) cnt
FROM v_treatments
WHERE medication_id IS NOT NULL
GROUP BY medication_id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-45"></a>

### 45.

Mostrar el diagnóstico más frecuente utilizando subconsultas.

**Respuesta:**

```sql
SELECT d.*
FROM diagnoses d
WHERE (SELECT COUNT(*)
FROM visit_diagnoses vd
WHERE vd.diagnosis_id=d.id)=(SELECT MAX(x.cnt)
FROM (SELECT COUNT(*) cnt
FROM visit_diagnoses
GROUP BY diagnosis_id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-46"></a>

### 46.

Mostrar los pacientes cuya última PIO sea inferior a su primera PIO.

**Respuesta:**

Se compara primera y última medición del mismo ojo; basta que un ojo cumpla la condición.

```sql
SELECT p.* FROM patients p WHERE EXISTS (SELECT 1 FROM v_intraocular_pressures i WHERE i.patient_id=p.id AND (SELECT x.pressure FROM v_intraocular_pressures x WHERE x.patient_id=p.id AND x.eye=i.eye ORDER BY x.measured_at DESC,x.id DESC LIMIT 1) < (SELECT x.pressure FROM v_intraocular_pressures x WHERE x.patient_id=p.id AND x.eye=i.eye ORDER BY x.measured_at,x.id LIMIT 1));
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-47"></a>

### 47.

Mostrar pacientes cuya presión promedio del ojo derecho sea mayor que la del ojo izquierdo.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT AVG(i.pressure)
FROM v_intraocular_pressures i
WHERE i.patient_id=p.id
    AND i.eye='OD') > (SELECT AVG(i.pressure)
FROM v_intraocular_pressures i
WHERE i.patient_id=p.id
    AND i.eye='OI');
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-48"></a>

### 48.

Mostrar los pacientes con mayor cantidad de controles de glaucoma que el promedio general.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE (SELECT COUNT(*)
FROM v_glaucoma_controls gc
WHERE gc.patient_id=p.id) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(gc2.id) cnt
FROM patients p2
LEFT JOIN v_glaucoma_controls gc2
    ON gc2.patient_id=p2.id
GROUP BY p2.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-49"></a>

### 49.

Mostrar las consultas que tengan más diagnósticos asociados que el promedio de diagnósticos por consulta.

**Respuesta:**

```sql
SELECT mv.*
FROM medical_visits mv
WHERE (SELECT COUNT(*)
FROM visit_diagnoses vd
WHERE vd.visit_id=mv.id) > (SELECT AVG(x.cnt)
FROM (SELECT COUNT(vd2.diagnosis_id) cnt
FROM medical_visits mv2
LEFT JOIN visit_diagnoses vd2
    ON vd2.visit_id=mv2.id
GROUP BY mv2.id)x);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="ejercicio-2-50"></a>

### 50.

Mostrar los pacientes que tengan simultáneamente OCT, campo visual, paquimetría y control de glaucoma registrados.

**Respuesta:**

```sql
SELECT p.*
FROM patients p
WHERE EXISTS(SELECT 1
FROM v_oct_exams o
WHERE o.patient_id=p.id)
    AND EXISTS(SELECT 1
FROM v_visual_field_exams v
WHERE v.patient_id=p.id)
    AND EXISTS(SELECT 1
FROM v_pachymetry_exams pa
WHERE pa.patient_id=p.id)
    AND EXISTS(SELECT 1
FROM v_glaucoma_controls g
WHERE g.patient_id=p.id);
```

**Evidencia:** ejecutar la consulta de la respuesta y conservar su resultado. El registro previo está en [consultas ejecutadas](#e-consultas).

<a id="parte-3"></a>

# PARTE III — 50 EJERCICIOS DE PROCEDIMIENTOS ALMACENADOS

## Procedimientos básicos

<a id="ejercicio-3-1"></a>

### 1.

Crear un procedimiento que liste todos los pacientes.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_list_patients$$
CREATE PROCEDURE sp_list_patients()
    SELECT *
    FROM patients $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_list_patients();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-2"></a>

### 2.

Crear un procedimiento que reciba el ID de un paciente y muestre sus datos.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_patient$$
CREATE PROCEDURE sp_get_patient(IN p_id BIGINT)
    SELECT *
    FROM patients
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_get_patient(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-3"></a>

### 3.

Crear un procedimiento que busque un paciente por número de documento.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_find_patient_document$$
CREATE PROCEDURE sp_find_patient_document(IN p_doc VARCHAR(30))
    SELECT *
    FROM patients
    WHERE document_number=p_doc $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_find_patient_document('101001');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-4"></a>

### 4.

Crear un procedimiento que liste todas las consultas de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patient_visits$$
CREATE PROCEDURE sp_patient_visits(IN p_id BIGINT)
    SELECT mv.*
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p_id
    ORDER BY mv.visit_date $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patient_visits(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-5"></a>

### 5.

Crear un procedimiento que muestre todos los profesionales.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_list_professionals$$
CREATE PROCEDURE sp_list_professionals()
    SELECT *
    FROM healthcare_professionals $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_list_professionals();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-6"></a>

### 6.

Crear un procedimiento que reciba una especialidad y muestre sus profesionales.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_professionals_by_specialty$$
CREATE PROCEDURE sp_professionals_by_specialty(IN p_specialty VARCHAR(100))
    SELECT hp.*
    FROM healthcare_professionals hp
    JOIN specialties s
        ON s.id=hp.specialty_id
    WHERE s.name=p_specialty $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_professionals_by_specialty('Oftalmología');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-7"></a>

### 7.

Crear un procedimiento que liste diagnósticos.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_list_diagnoses$$
CREATE PROCEDURE sp_list_diagnoses()
    SELECT *
    FROM diagnoses $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_list_diagnoses();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-8"></a>

### 8.

Crear un procedimiento que muestre medicamentos activos.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_active_medications$$
CREATE PROCEDURE sp_active_medications()
    SELECT *
    FROM medications
    WHERE active=TRUE $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_active_medications();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-9"></a>

### 9.

Crear un procedimiento que liste procedimientos clínicos realizados a un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patient_procedures$$
CREATE PROCEDURE sp_patient_procedures(IN p_id BIGINT)
    SELECT *
    FROM v_procedures
    WHERE patient_id=p_id
    ORDER BY procedure_date $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patient_procedures(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-10"></a>

### 10.

Crear un procedimiento para consultar todos los controles de glaucoma de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patient_glaucoma_controls$$
CREATE PROCEDURE sp_patient_glaucoma_controls(IN p_id BIGINT)
    SELECT *
    FROM v_glaucoma_controls
    WHERE patient_id=p_id
    ORDER BY control_date $$
DELIMITER ;
```

## Procedimientos de inserción

**Código para obtener la evidencia:**

```sql
CALL sp_patient_glaucoma_controls(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-11"></a>

### 11.

Crear un procedimiento para registrar un nuevo paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_patient$$
CREATE PROCEDURE sp_create_patient(
    IN p_document_type_id INT,
    IN p_document_number VARCHAR(30),
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_sex VARCHAR(20),
    IN p_phone VARCHAR(30),
    IN p_email VARCHAR(150),
    IN p_city VARCHAR(100)
)
    INSERT INTO patients (
        document_type_id,
        document_number,
        first_name,
        last_name,
        birth_date,
        sex,
        phone,
        email,
        city
    )
    VALUES (
        p_document_type_id,
        p_document_number,
        p_first_name,
        p_last_name,
        p_birth_date,
        p_sex,
        p_phone,
        p_email,
        p_city
    ) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_create_patient(1,'NUEVO901','Nuevo','Prueba','1970-01-01','Prueba académica','Prueba académica','Prueba académica','Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-12"></a>

### 12.

Crear un procedimiento para crear una historia clínica.

**Respuesta:**

La historia se crea automáticamente al dar de alta el paciente; este procedimiento asigna su número o repara una historia ausente.

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_history$$
CREATE PROCEDURE sp_create_history(IN p_patient_id BIGINT, IN p_history_number VARCHAR(30))
BEGIN
IF NOT EXISTS(SELECT 1 FROM patients WHERE id=p_patient_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente inexistente'; END IF;
IF EXISTS(SELECT 1 FROM clinical_histories WHERE patient_id=p_patient_id) THEN
 UPDATE clinical_histories SET history_number=p_history_number WHERE patient_id=p_patient_id;
ELSE INSERT INTO clinical_histories(patient_id,history_number) VALUES(p_patient_id,p_history_number); END IF;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_create_history(1,'HC-1');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-13"></a>

### 13.

Crear un procedimiento para registrar una consulta médica.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_create_visit$$
CREATE PROCEDURE sp_create_visit(
    IN p_history BIGINT,
    IN p_prof BIGINT,
    IN p_date DATETIME,
    IN p_reason TEXT,
    IN p_assessment TEXT,
    IN p_plan TEXT
)
    INSERT INTO medical_visits (
        clinical_history_id,
        professional_id,
        visit_date,
        reason,
        assessment,
        plan
    )
    VALUES (
        p_history,
        p_prof,
        p_date,
        p_reason,
        p_assessment,
        p_plan
    ) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_create_visit(1,1,'2026-09-28','Prueba académica','Prueba académica','Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-14"></a>

### 14.

Crear un procedimiento para registrar un diagnóstico asociado a una consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_diagnosis$$
CREATE PROCEDURE sp_register_diagnosis(IN p_visit BIGINT, IN p_diagnosis BIGINT, IN p_eye CHAR(2))
BEGIN
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye) VALUES(p_visit,p_diagnosis,p_eye);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_diagnosis(1,2,'OI');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-15"></a>

### 15.

Crear un procedimiento para registrar una medición de PIO.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_iop$$
CREATE PROCEDURE sp_register_iop(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2))
BEGIN
INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(p_visit,p_date,p_eye,p_pressure);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_iop(1,'2026-09-28','OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-16"></a>

### 16.

Crear un procedimiento para registrar un control de glaucoma.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_glaucoma_control$$
CREATE PROCEDURE sp_register_glaucoma_control(IN p_record BIGINT, IN p_visit BIGINT, IN p_date DATETIME, IN p_notes TEXT)
BEGIN
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,notes) VALUES(p_record,p_visit,p_date,p_notes);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_glaucoma_control(1,1,'2026-09-28','Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-17"></a>

### 17.

Crear un procedimiento para registrar un examen OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_oct$$
CREATE PROCEDURE sp_register_oct(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_rnfl DECIMAL(7,2), IN p_interpretation TEXT)
BEGIN
INSERT INTO oct_exams(visit_id,exam_date,eye,rnfl,interpretation) VALUES(p_visit,p_date,p_eye,p_rnfl,p_interpretation);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_oct(1,'2026-09-28','OD',80,'Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-18"></a>

### 18.

Crear un procedimiento para registrar un campo visual.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_visual_field$$
CREATE PROCEDURE sp_register_visual_field(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_md DECIMAL(7,2), IN p_psd DECIMAL(7,2), IN p_vfi DECIMAL(5,2))
BEGIN
INSERT INTO visual_field_exams(visit_id,exam_date,eye,md,psd,vfi) VALUES(p_visit,p_date,p_eye,p_md,p_psd,p_vfi);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_visual_field(1,'2026-09-28','OD',-2,2,90);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-19"></a>

### 19.

Crear un procedimiento para registrar una paquimetría.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_pachymetry$$
CREATE PROCEDURE sp_register_pachymetry(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_value DECIMAL(7,2))
BEGIN
INSERT INTO pachymetry_exams(visit_id,exam_date,eye,corneal_thickness) VALUES(p_visit,p_date,p_eye,p_value);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_register_pachymetry(1,'2026-09-28','OD',510);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-20"></a>

### 20.

Crear un procedimiento para registrar un tratamiento.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_register_treatment$$
CREATE PROCEDURE sp_register_treatment(IN p_visit BIGINT, IN p_med BIGINT, IN p_eye CHAR(2), IN p_start DATE, IN p_end DATE, IN p_notes TEXT)
BEGIN
INSERT INTO treatments(visit_id,medication_id,eye,start_date,end_date,active,notes) VALUES(p_visit,p_med,p_eye,p_start,p_end,p_end IS NULL,p_notes);
END$$
DELIMITER ;
```

## Procedimientos de modificación

**Código para obtener la evidencia:**

```sql
CALL sp_register_treatment(1,2,'OD','2026-09-26','2026-10-01','Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-21"></a>

### 21.

Crear un procedimiento para actualizar teléfono y correo de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_patient_contact$$
CREATE PROCEDURE sp_update_patient_contact(
    IN p_id BIGINT,
    IN p_phone VARCHAR(30),
    IN p_email VARCHAR(150)
)
    UPDATE patients SET phone=p_phone,email=p_email
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_patient_contact(1,'Prueba académica','Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-22"></a>

### 22.

Crear un procedimiento para modificar el estado de una historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_history_status$$
CREATE PROCEDURE sp_update_history_status(
    IN p_id BIGINT,
    IN p_status VARCHAR(20)
)
    UPDATE clinical_histories SET status=p_status
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_history_status(1,'ACTIVE');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-23"></a>

### 23.

Crear un procedimiento para actualizar observaciones de una consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_visit_observations$$
CREATE PROCEDURE sp_update_visit_observations(
    IN p_id BIGINT,
    IN p_obs TEXT
)
    UPDATE medical_visits SET observations=p_obs
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_visit_observations(1,'Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-24"></a>

### 24.

Crear un procedimiento para modificar la presión objetivo de un paciente con glaucoma.

**Respuesta:**

Modifica el último control del ojo indicado, conservando controles anteriores y auditoría del cambio.

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_target_pressure$$
CREATE PROCEDURE sp_update_target_pressure(IN p_patient BIGINT, IN p_eye CHAR(2), IN p_target DECIMAL(5,2))
BEGIN
DECLARE v_control BIGINT;
SET v_control=(SELECT c.id FROM glaucoma_controls c JOIN glaucoma_records r ON r.id=c.glaucoma_record_id WHERE r.patient_id=p_patient AND r.eye=p_eye ORDER BY c.control_date DESC,c.id DESC LIMIT 1);
IF v_control IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin control para ese paciente y ojo'; END IF;
UPDATE glaucoma_controls SET target_pressure=p_target WHERE id=v_control;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_target_pressure(1,'OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-25"></a>

### 25.

Crear un procedimiento para finalizar un tratamiento.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_finish_treatment$$
CREATE PROCEDURE sp_finish_treatment(
    IN p_id BIGINT,
    IN p_end DATE
)
    UPDATE treatments SET end_date=p_end,active=FALSE
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_finish_treatment(1,'2026-10-01');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-26"></a>

### 26.

Crear un procedimiento para cambiar el medicamento de un tratamiento.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_change_treatment_medication$$
CREATE PROCEDURE sp_change_treatment_medication(
    IN p_id BIGINT,
    IN p_med BIGINT
)
    UPDATE treatments SET medication_id=p_med
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_change_treatment_medication(1,2);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-27"></a>

### 27.

Crear un procedimiento para actualizar el estado clínico del glaucoma.

**Respuesta:**

Modifica el último control del ojo indicado, conservando controles anteriores y auditoría del cambio.

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_glaucoma_status$$
CREATE PROCEDURE sp_update_glaucoma_status(IN p_patient BIGINT, IN p_eye CHAR(2), IN p_status VARCHAR(100))
BEGIN
DECLARE v_control BIGINT;
SET v_control=(SELECT c.id FROM glaucoma_controls c JOIN glaucoma_records r ON r.id=c.glaucoma_record_id WHERE r.patient_id=p_patient AND r.eye=p_eye ORDER BY c.control_date DESC,c.id DESC LIMIT 1);
IF v_control IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin control para ese paciente y ojo'; END IF;
UPDATE glaucoma_controls SET clinical_status=p_status WHERE id=v_control;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_glaucoma_status(1,'OD','ACTIVE');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-28"></a>

### 28.

Crear un procedimiento para actualizar información de un profesional.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_professional$$
CREATE PROCEDURE sp_update_professional(
    IN p_id BIGINT,
    IN p_first VARCHAR(100),
    IN p_last VARCHAR(100),
    IN p_active BOOLEAN
)
    UPDATE healthcare_professionals SET first_name=p_first,last_name=p_last,active=p_active
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_professional(1,'Prueba','Paciente',TRUE);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-29"></a>

### 29.

Crear un procedimiento para modificar la interpretación de un OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_oct_interpretation$$
CREATE PROCEDURE sp_update_oct_interpretation(
    IN p_id BIGINT,
    IN p_text TEXT
)
    UPDATE oct_exams SET interpretation=p_text
    WHERE id=p_id $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_update_oct_interpretation(1,'Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-30"></a>

### 30.

Crear un procedimiento para actualizar la interpretación de un campo visual.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_update_visual_field_interpretation$$
CREATE PROCEDURE sp_update_visual_field_interpretation(
    IN p_id BIGINT,
    IN p_text TEXT
)
    UPDATE visual_field_exams SET interpretation=p_text
    WHERE id=p_id $$
DELIMITER ;
```

## Procedimientos con validaciones

**Código para obtener la evidencia:**

```sql
CALL sp_update_visual_field_interpretation(1,'Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-31"></a>

### 31.

Crear un procedimiento que registre una PIO únicamente si el paciente existe.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_iop$$
CREATE PROCEDURE sp_safe_iop(IN p_patient BIGINT, IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2))
BEGIN
IF NOT EXISTS(SELECT 1 FROM patients WHERE id=p_patient) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente inexistente'; END IF;
IF NOT EXISTS(SELECT 1 FROM medical_visits m JOIN clinical_histories ch ON ch.id=m.clinical_history_id WHERE m.id=p_visit AND ch.patient_id=p_patient) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consulta ajena o inexistente'; END IF;
INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(p_visit,p_date,p_eye,p_pressure);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_iop(1,1,'2026-09-28','OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-32"></a>

### 32.

Crear un procedimiento que registre una consulta solo si existe la historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_visit$$
CREATE PROCEDURE sp_safe_visit(
    IN p_history BIGINT,
    IN p_prof BIGINT,
    IN p_date DATETIME
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM clinical_histories
        WHERE id=p_history
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Historia inexistente';
    END IF;
    INSERT INTO medical_visits (
        clinical_history_id,
        professional_id,
        visit_date
    )
    VALUES
    (p_history,p_prof,p_date);
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_visit(1,1,'2026-09-28');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-33"></a>

### 33.

Crear un procedimiento que impida registrar un tratamiento con fecha final anterior a la inicial.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_treatment$$
CREATE PROCEDURE sp_safe_treatment(IN p_visit BIGINT, IN p_med BIGINT, IN p_eye CHAR(2), IN p_start DATE, IN p_end DATE)
BEGIN
IF p_end IS NOT NULL AND p_end<p_start THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fecha final inválida'; END IF;
INSERT INTO treatments(visit_id,medication_id,eye,start_date,end_date,active) VALUES(p_visit,p_med,p_eye,p_start,p_end,p_end IS NULL);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_treatment(1,2,'OD','2026-09-26','2026-10-01');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-34"></a>

### 34.

Crear un procedimiento que impida registrar valores negativos de PIO.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_iop_nonnegative$$
CREATE PROCEDURE sp_safe_iop_nonnegative(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2))
BEGIN
IF p_pressure IS NULL OR p_pressure<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PIO inválida'; END IF; INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(p_visit,p_date,p_eye,p_pressure);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_iop_nonnegative(1,'2026-09-28','OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-35"></a>

### 35.

Crear un procedimiento que valide que el ojo recibido sea `OD` u `OI`.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_eye$$
CREATE PROCEDURE sp_safe_eye(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2))
BEGIN
IF p_eye IS NULL OR p_eye NOT IN ('OD','OI') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo inválido'; END IF; INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(p_visit,p_date,p_eye,p_pressure);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_eye(1,'2026-09-28','OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-36"></a>

### 36.

Crear un procedimiento que impida crear dos historias clínicas para el mismo paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_unique_history$$
CREATE PROCEDURE sp_unique_history(
    IN p_patient BIGINT,
    IN p_number VARCHAR(30)
)
BEGIN
    IF EXISTS(SELECT 1
        FROM clinical_histories
        WHERE patient_id=p_patient
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El paciente ya tiene historia';
    END IF;
    INSERT INTO clinical_histories (
        patient_id,
        history_number
    )
    VALUES
    (p_patient,p_number);
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_unique_history(1,'HC-1');
```

Resultado registrado: rechazo esperado de historia duplicada; detalle en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-37"></a>

### 37.

Crear un procedimiento que registre un diagnóstico solo si existe en el catálogo.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_diagnosis$$
CREATE PROCEDURE sp_safe_diagnosis(IN p_visit BIGINT, IN p_diagnosis BIGINT, IN p_eye CHAR(2))
BEGIN
IF NOT EXISTS(SELECT 1 FROM diagnoses WHERE id=p_diagnosis) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Diagnóstico inexistente'; END IF; INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye,is_primary) VALUES(p_visit,p_diagnosis,p_eye,FALSE);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_diagnosis(1,3,'OI');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-38"></a>

### 38.

Crear un procedimiento que valide que el profesional se encuentre activo antes de registrar una consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_visit_active_professional$$
CREATE PROCEDURE sp_visit_active_professional(
    IN p_history BIGINT,
    IN p_prof BIGINT,
    IN p_date DATETIME
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM healthcare_professionals
        WHERE id=p_prof
        AND active=TRUE
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Profesional inactivo';
    END IF;
    INSERT INTO medical_visits (
        clinical_history_id,
        professional_id,
        visit_date
    )
    VALUES
    (p_history,p_prof,p_date);
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_visit_active_professional(1,1,'2026-09-28');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-39"></a>

### 39.

Crear un procedimiento que registre un campo visual validando que VFI esté entre 0 y 100.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_visual_field$$
CREATE PROCEDURE sp_safe_visual_field(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_vfi DECIMAL(5,2))
BEGIN
IF p_vfi IS NULL OR p_vfi NOT BETWEEN 0 AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI fuera de rango'; END IF; INSERT INTO visual_field_exams(visit_id,exam_date,eye,vfi) VALUES(p_visit,p_date,p_eye,p_vfi);
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_safe_visual_field(1,'2026-09-28','OD',90);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-40"></a>

### 40.

Crear un procedimiento que registre una paquimetría validando que el valor sea positivo.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_safe_pachymetry$$
CREATE PROCEDURE sp_safe_pachymetry(IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_value DECIMAL(7,2))
BEGIN
IF p_value IS NULL OR p_value<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paquimetría inválida'; END IF; INSERT INTO pachymetry_exams(visit_id,exam_date,eye,corneal_thickness) VALUES(p_visit,p_date,p_eye,p_value);
END$$
DELIMITER ;
```

## Procedimientos avanzados

**Código para obtener la evidencia:**

```sql
CALL sp_safe_pachymetry(1,'2026-09-28','OD',510);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-41"></a>

### 41.

Crear un procedimiento que devuelva un resumen completo de la historia clínica de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patient_history_summary$$
CREATE PROCEDURE sp_patient_history_summary(IN p_id BIGINT)
BEGIN
    SELECT *
    FROM patients
    WHERE id=p_id;
    SELECT *
    FROM medical_histories
    WHERE patient_id=p_id;
    SELECT mv.*
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p_id
    ORDER BY mv.visit_date;
SELECT * FROM clinical_histories WHERE patient_id=p_id;
SELECT vd.* FROM visit_diagnoses vd JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_id;
SELECT ex.* FROM ophthalmologic_exams ex JOIN medical_visits mv ON mv.id=ex.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_id;
SELECT * FROM v_intraocular_pressures WHERE patient_id=p_id;
SELECT * FROM v_oct_exams WHERE patient_id=p_id;
SELECT * FROM v_visual_field_exams WHERE patient_id=p_id;
SELECT * FROM v_pachymetry_exams WHERE patient_id=p_id;
SELECT * FROM v_gonioscopy_exams WHERE patient_id=p_id;
SELECT * FROM v_glaucoma_controls WHERE patient_id=p_id;
SELECT * FROM v_treatments WHERE patient_id=p_id;
SELECT * FROM v_procedures WHERE patient_id=p_id;
SELECT * FROM glaucoma_records WHERE patient_id=p_id;
SELECT d.* FROM clinical_documents d JOIN clinical_histories ch ON ch.id=d.clinical_history_id WHERE ch.patient_id=p_id;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patient_history_summary(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-42"></a>

### 42.

Crear un procedimiento que muestre la evolución de PIO de un paciente entre dos fechas.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_iop_evolution$$
CREATE PROCEDURE sp_iop_evolution(
    IN p_id BIGINT,
    IN p_from DATETIME,
    IN p_to DATETIME
)
    SELECT *
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND measured_at BETWEEN p_from
        AND p_to
    ORDER BY measured_at $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_iop_evolution(1,'2026-01-01','2026-10-01');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-43"></a>

### 43.

Crear un procedimiento que reciba paciente y ojo y muestre todas sus mediciones cronológicamente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_iop_by_eye$$
CREATE PROCEDURE sp_iop_by_eye(
    IN p_id BIGINT,
    IN p_eye CHAR(2)
)
    SELECT *
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND eye=p_eye
    ORDER BY measured_at $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_iop_by_eye(1,'OD');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-44"></a>

### 44.

Crear un procedimiento que genere estadísticas mensuales de consultas.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_monthly_visit_stats$$
CREATE PROCEDURE sp_monthly_visit_stats()
    SELECT
    DATE_FORMAT(visit_date,'%Y-%m') month,
    COUNT(*) total
    FROM medical_visits
    GROUP BY DATE_FORMAT(visit_date,'%Y-%m')
    ORDER BY month $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_monthly_visit_stats();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-45"></a>

### 45.

Crear un procedimiento que calcule la cantidad de pacientes atendidos por cada especialista.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patients_by_specialist$$
CREATE PROCEDURE sp_patients_by_specialist()
    SELECT
    hp.id,
    hp.first_name,
    hp.last_name,
    COUNT(DISTINCT ch.patient_id) total
    FROM healthcare_professionals hp
    LEFT JOIN medical_visits mv
        ON mv.professional_id=hp.id
    LEFT JOIN clinical_histories ch
        ON ch.id=mv.clinical_history_id
    GROUP BY hp.id,hp.first_name,hp.last_name $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patients_by_specialist();
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-46"></a>

### 46.

Crear un procedimiento que determine pacientes sin consulta durante un número de meses recibido como parámetro.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patients_without_visit_months$$
CREATE PROCEDURE sp_patients_without_visit_months(IN p_months INT)
    SELECT p.*
    FROM patients p
    WHERE NOT EXISTS(SELECT 1
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p.id
        AND mv.visit_date>=DATE_SUB(CURDATE(),INTERVAL p_months MONTH)) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patients_without_visit_months(3);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-47"></a>

### 47.

Crear un procedimiento que genere un resumen de diagnósticos por paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_patient_diagnosis_summary$$
CREATE PROCEDURE sp_patient_diagnosis_summary(IN p_id BIGINT)
    SELECT
    d.name,
    COUNT(*) total
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    JOIN visit_diagnoses vd
        ON vd.visit_id=mv.id
    JOIN diagnoses d
        ON d.id=vd.diagnosis_id
    WHERE ch.patient_id=p_id
    GROUP BY d.id,d.name $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_patient_diagnosis_summary(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-48"></a>

### 48.

Crear un procedimiento que devuelva el último OCT, último campo visual y última PIO de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_latest_eye_studies$$
CREATE PROCEDURE sp_latest_eye_studies(IN p_id BIGINT)
BEGIN
    SELECT *
    FROM v_oct_exams
    WHERE patient_id=p_id
    ORDER BY exam_date DESC,id DESC
    LIMIT 1;
    SELECT *
    FROM v_visual_field_exams
    WHERE patient_id=p_id
    ORDER BY exam_date DESC,id DESC
    LIMIT 1;
    SELECT *
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
    ORDER BY measured_at DESC,id DESC
    LIMIT 1;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_latest_eye_studies(1);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-49"></a>

### 49.

Crear un procedimiento que registre en una sola transacción una consulta, un diagnóstico y una medición de PIO.

**Respuesta:**

Llamar fuera de otra transacción: START TRANSACTION inicia su propio contexto.

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_visit_diagnosis_iop_tx$$
CREATE PROCEDURE sp_visit_diagnosis_iop_tx(IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_diagnosis BIGINT, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2))
BEGIN
DECLARE v_visit BIGINT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date) VALUES(p_history,p_prof,p_date); SET v_visit=LAST_INSERT_ID();
INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye) VALUES(v_visit,p_diagnosis,p_eye);
INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(v_visit,p_date,p_eye,p_pressure);
COMMIT;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_visit_diagnosis_iop_tx(1,1,'2026-09-28',1,'OD',19);
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="ejercicio-3-50"></a>

### 50.

Crear un procedimiento transaccional que registre un control completo de glaucoma y ejecute `ROLLBACK` si alguna operación falla.

**Respuesta:**

Control completo en este ejercicio = control y PIO del mismo ojo; se valida el ojo del episodio antes de insertar.

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_complete_glaucoma_control_tx$$
CREATE PROCEDURE sp_complete_glaucoma_control_tx(IN p_record BIGINT, IN p_visit BIGINT, IN p_date DATETIME, IN p_eye CHAR(2), IN p_pressure DECIMAL(5,2), IN p_notes TEXT)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
START TRANSACTION;
IF NOT EXISTS(SELECT 1 FROM glaucoma_records WHERE id=p_record AND eye=p_eye) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo ajeno al episodio'; END IF;
INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,notes) VALUES(p_record,p_visit,p_date,p_notes);
INSERT INTO intraocular_pressures(visit_id,measured_at,eye,pressure) VALUES(p_visit,p_date,p_eye,p_pressure);
COMMIT;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
CALL sp_complete_glaucoma_control_tx(1,1,'2026-09-28','OD',19,'Prueba académica');
```

Resultado registrado: llamada ejecutada sin error; resultado completo en [pruebas de procedimientos](#e-procedimientos). Las llamadas de escritura modifican los datos de práctica; ejecutar en el orden probado o preparar sus registros relacionados.

<a id="parte-4"></a>

# PARTE IV — 50 EJERCICIOS DE TRIGGERS

## BEFORE INSERT

<a id="ejercicio-4-1"></a>

### 1.

Crear un trigger que elimine espacios externos de los nombres de pacientes antes de insertarlos.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_trim_bi$$
CREATE TRIGGER trg_patient_trim_bi
    BEFORE INSERT
    ON patients
    FOR EACH ROW
    SET NEW.first_name=TRIM(NEW.first_name),NEW.last_name=TRIM(NEW.last_name) $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM');
SELECT (SELECT first_name='Nombre' AND last_name='Apellido' FROM patients WHERE id=LAST_INSERT_ID()) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-2"></a>

### 2.

Convertir automáticamente el correo del paciente a minúsculas.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_email_lower_bi$$
CREATE TRIGGER trg_patient_email_lower_bi
    BEFORE INSERT
    ON patients
    FOR EACH ROW
    SET NEW.email=LOWER(NEW.email) $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM');
SELECT (SELECT email='persona@example.com' FROM patients WHERE id=LAST_INSERT_ID()) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-3"></a>

### 3.

Convertir el número de documento a mayúsculas cuando contenga caracteres.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_doc_upper_bi$$
CREATE TRIGGER trg_patient_doc_upper_bi
    BEFORE INSERT
    ON patients
    FOR EACH ROW
    SET NEW.document_number=UPPER(NEW.document_number) $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM');
SELECT (SELECT document_number='  XA001  ' FROM patients WHERE id=LAST_INSERT_ID()) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-4"></a>

### 4.

Impedir registrar una fecha de nacimiento futura.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_birth_bi$$
CREATE TRIGGER trg_patient_birth_bi
    BEFORE INSERT
    ON patients
    FOR EACH ROW
    BEGIN
        IF NEW.birth_date>CURRENT_DATE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fecha de nacimiento futura';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date) VALUES(1,'FUT','A','B',DATE_ADD(CURDATE(),INTERVAL 1 DAY));
ROLLBACK;
```

Resultado registrado: rechazo esperado: Fecha de nacimiento futura. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-5"></a>

### 5.

Impedir registrar una presión intraocular negativa.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_negative_bi$$
CREATE TRIGGER trg_iop_negative_bi
    BEFORE INSERT
    ON intraocular_pressures
    FOR EACH ROW
    BEGIN
        IF NEW.pressure<0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PIO negativa';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',-1);
ROLLBACK;
```

Resultado registrado: rechazo esperado: PIO negativa. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-6"></a>

### 6.

Impedir registrar una PIO superior a un límite definido para datos plausibles.

**Respuesta:**

60 mmHg es límite de ensayo elegido, no regla clínica.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_limit_bi$$
CREATE TRIGGER trg_iop_limit_bi BEFORE INSERT ON intraocular_pressures FOR EACH ROW
BEGIN
IF NEW.pressure>60 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Supera límite académico 60'; END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',61);
ROLLBACK;
```

Resultado registrado: rechazo esperado: límite académico. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-7"></a>

### 7.

Validar que el campo `eye` solo admita `OD` u `OI`.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_eye_bi$$
CREATE TRIGGER trg_iop_eye_bi
    BEFORE INSERT
    ON intraocular_pressures
    FOR EACH ROW
    BEGIN
        IF NEW.eye NOT IN ('OD','OI'
    ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo inválido';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'AO','2026-09-30',18);
ROLLBACK;
```

Resultado registrado: rechazo esperado: Ojo inválido. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-8"></a>

### 8.

Impedir que un tratamiento tenga fecha final anterior a la inicial.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_dates_bi$$
CREATE TRIGGER trg_treatment_dates_bi
    BEFORE INSERT
    ON treatments
    FOR EACH ROW
    BEGIN
        IF NEW.end_date IS NOT NULL
            AND NEW.end_date<NEW.start_date THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fechas inválidas';
    END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO treatments(visit_id,eye,start_date,end_date) VALUES(1,'OD','2026-09-30','2026-09-29');
ROLLBACK;
```

Resultado registrado: rechazo esperado: Fechas inválidas. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-9"></a>

### 9.

Validar que el VFI de un campo visual esté entre 0 y 100.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_vfi_bi$$
CREATE TRIGGER trg_vfi_bi
    BEFORE INSERT
    ON visual_field_exams
    FOR EACH ROW
    BEGIN
        IF NEW.vfi IS NOT NULL
            AND NEW.vfi NOT BETWEEN 0
            AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI fuera de rango';
    END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO visual_field_exams(visit_id,eye,exam_date,vfi) VALUES(1,'OD','2026-09-30',101);
ROLLBACK;
```

Resultado registrado: rechazo esperado: VFI fuera de rango. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-10"></a>

### 10.

Validar que la paquimetría sea mayor que cero.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_pachymetry_bi$$
CREATE TRIGGER trg_pachymetry_bi
    BEFORE INSERT
    ON pachymetry_exams
    FOR EACH ROW
    BEGIN
        IF NEW.corneal_thickness<=0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paquimetría inválida';
        END IF;
    END$$
DELIMITER ;
```

## AFTER INSERT

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(1,'OD','2026-09-30',0);
ROLLBACK;
```

Resultado registrado: rechazo esperado: Paquimetría inválida. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-11"></a>

### 11.

Registrar en auditoría la creación de un nuevo paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_ai$$
CREATE TRIGGER trg_patient_ai AFTER INSERT ON patients FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(NEW.id AS CHAR),'INSERT',NULL,JSON_OBJECT('id',NEW.id,'document_type_id',NEW.document_type_id,'document_number',NEW.document_number,'first_name',NEW.first_name,'last_name',NEW.last_name,'birth_date',NEW.birth_date,'sex',NEW.sex,'phone',NEW.phone,'email',NEW.email,'city',NEW.city,'created_at',NEW.created_at,'updated_at',NEW.updated_at),USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='INSERT'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-12"></a>

### 12.

Registrar en auditoría la creación de una historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_history_ai$$
CREATE TRIGGER trg_history_ai AFTER INSERT ON clinical_histories FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('clinical_histories',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='clinical_histories' AND action='INSERT'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='clinical_histories' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-13"></a>

### 13.

Registrar automáticamente en auditoría cada nueva consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_ai$$
CREATE TRIGGER trg_visit_ai AFTER INSERT ON medical_visits FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('medical_visits',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='medical_visits' AND action='INSERT'); INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date) VALUES(1,1,'2026-09-30');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='medical_visits' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-14"></a>

### 14.

Registrar cada nuevo diagnóstico asociado a una consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_diag_ai$$
CREATE TRIGGER trg_visit_diag_ai AFTER INSERT ON visit_diagnoses FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('visit_diagnoses',CONCAT(NEW.visit_id,':',NEW.diagnosis_id,':',NEW.eye),'INSERT',NULL,JSON_OBJECT('is_primary',NEW.is_primary),USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visit_diagnoses' AND action='INSERT'); INSERT INTO visit_diagnoses(visit_id,diagnosis_id,eye) VALUES(1,8,'OI');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visit_diagnoses' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-15"></a>

### 15.

Registrar cada nueva medición de presión intraocular.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_ai$$
CREATE TRIGGER trg_iop_ai AFTER INSERT ON intraocular_pressures FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('intraocular_pressures',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='intraocular_pressures' AND action='INSERT'); INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',18);
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='intraocular_pressures' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-16"></a>

### 16.

Registrar cada nuevo tratamiento.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_ai$$
CREATE TRIGGER trg_treatment_ai AFTER INSERT ON treatments FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('treatments',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments' AND action='INSERT'); INSERT INTO treatments(visit_id,eye,start_date) VALUES(1,'OD','2026-09-30');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='treatments' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-17"></a>

### 17.

Registrar cada nuevo procedimiento.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_procedure_ai$$
CREATE TRIGGER trg_procedure_ai AFTER INSERT ON procedures FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('procedures',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='procedures' AND action='INSERT'); INSERT INTO procedures(visit_id,eye,procedure_type,procedure_date) VALUES(1,'OD','Ensayo','2026-09-30');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='procedures' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-18"></a>

### 18.

Registrar en auditoría cada nuevo estudio OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_oct_ai$$
CREATE TRIGGER trg_oct_ai AFTER INSERT ON oct_exams FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('oct_exams',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='oct_exams' AND action='INSERT'); INSERT INTO oct_exams(visit_id,eye,exam_date) VALUES(1,'OD','2026-09-30');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='oct_exams' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-19"></a>

### 19.

Registrar cada campo visual creado.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_vf_ai$$
CREATE TRIGGER trg_vf_ai AFTER INSERT ON visual_field_exams FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('visual_field_exams',CAST(NEW.id AS CHAR),'INSERT',NULL,NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visual_field_exams' AND action='INSERT'); INSERT INTO visual_field_exams(visit_id,eye,exam_date) VALUES(1,'OD','2026-09-30');
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visual_field_exams' AND action='INSERT') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-20"></a>

### 20.

Crear una notificación interna cuando se registre una PIO mayor que un valor determinado.

**Respuesta:**

Umbral académico elegido 25; la alerta no establece un diagnóstico.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_alert_ai$$
CREATE TRIGGER trg_iop_alert_ai AFTER INSERT ON intraocular_pressures FOR EACH ROW
BEGIN
IF NEW.pressure>25 THEN INSERT INTO notifications(patient_id,message) SELECT ch.patient_id,CONCAT('Ensayo: PIO >25: ',NEW.pressure) FROM medical_visits m JOIN clinical_histories ch ON ch.id=m.clinical_history_id WHERE m.id=NEW.visit_id; END IF;
END$$
DELIMITER ;
```

## BEFORE UPDATE

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM notifications); INSERT INTO intraocular_pressures(visit_id,eye,measured_at,pressure) VALUES(1,'OD','2026-09-30',26);
SELECT (SELECT COUNT(*)>@a FROM notifications) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-21"></a>

### 21.

Actualizar automáticamente `updated_at` antes de modificar un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_updated_bu$$
CREATE TRIGGER trg_patient_updated_bu
    BEFORE UPDATE
    ON patients
    FOR EACH ROW
    SET NEW.updated_at=CURRENT_TIMESTAMP $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE patients SET updated_at='2000-01-01',phone='555' WHERE id=1;
SELECT (SELECT updated_at>'2000-01-01' FROM patients WHERE id=1) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-22"></a>

### 22.

Actualizar `updated_at` antes de modificar una consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_updated_bu$$
CREATE TRIGGER trg_visit_updated_bu
    BEFORE UPDATE
    ON medical_visits
    FOR EACH ROW
    SET NEW.updated_at=CURRENT_TIMESTAMP $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE medical_visits SET updated_at='2000-01-01',reason='Prueba' WHERE id=1;
SELECT (SELECT updated_at>'2000-01-01' FROM medical_visits WHERE id=1) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-23"></a>

### 23.

Impedir modificar el número de documento una vez creada la historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_document_lock_bu$$
CREATE TRIGGER trg_patient_document_lock_bu
    BEFORE UPDATE
    ON patients
    FOR EACH ROW
    BEGIN
        IF NEW.document_number<>OLD.document_number
            AND EXISTS(SELECT 1
            FROM clinical_histories
            WHERE patient_id=OLD.id
    ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Documento bloqueado';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE patients SET document_number='CAMBIO' WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Documento bloqueado. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-24"></a>

### 24.

Impedir asignar una fecha de consulta futura no permitida.

**Respuesta:**

Se modelan consultas realizadas, no citas programadas.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_future_bu$$
CREATE TRIGGER trg_visit_future_bu BEFORE UPDATE ON medical_visits FOR EACH ROW
BEGIN
IF NEW.visit_date>CURRENT_TIMESTAMP THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consultas realizadas no admiten fecha futura'; END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE medical_visits SET visit_date=DATE_ADD(NOW(),INTERVAL 1 DAY) WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: no admiten fecha futura. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-25"></a>

### 25.

Validar que una nueva presión objetivo sea positiva.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_target_pressure_bu$$
CREATE TRIGGER trg_target_pressure_bu BEFORE UPDATE ON glaucoma_controls FOR EACH ROW
BEGIN
IF NEW.target_pressure IS NOT NULL AND NEW.target_pressure<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Presión objetivo inválida'; END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE glaucoma_controls SET target_pressure=-1 WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Presión objetivo inválida. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-26"></a>

### 26.

Impedir establecer una fecha final de tratamiento anterior a su inicio.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_dates_bu$$
CREATE TRIGGER trg_treatment_dates_bu
    BEFORE UPDATE
    ON treatments
    FOR EACH ROW
    BEGIN
        IF NEW.end_date IS NOT NULL
            AND NEW.end_date<NEW.start_date THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fechas inválidas';
    END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE treatments SET end_date='2000-01-01' WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Fechas inválidas. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-27"></a>

### 27.

Evitar modificar un examen OCT que haya sido marcado como validado.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_oct_validated_bu$$
CREATE TRIGGER trg_oct_validated_bu
    BEFORE UPDATE
    ON oct_exams
    FOR EACH ROW
    BEGIN
        IF OLD.validated=TRUE THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='OCT validado no modificable';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE oct_exams SET validated=TRUE WHERE id=1; UPDATE oct_exams SET interpretation='Cambio' WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: OCT validado no modificable. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-28"></a>

### 28.

Evitar modificar una consulta marcada como cerrada.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_closed_bu$$
CREATE TRIGGER trg_visit_closed_bu
    BEFORE UPDATE
    ON medical_visits
    FOR EACH ROW
    BEGIN
        IF OLD.status='CLOSED' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consulta cerrada';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE medical_visits SET status='CLOSED' WHERE id=1; UPDATE medical_visits SET reason='Cambio' WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Consulta cerrada. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-29"></a>

### 29.

Validar valores del campo visual antes de una actualización.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_vf_values_bu$$
CREATE TRIGGER trg_vf_values_bu
    BEFORE UPDATE
    ON visual_field_exams
    FOR EACH ROW
    BEGIN
        IF NEW.vfi IS NOT NULL
            AND NEW.vfi NOT BETWEEN 0
            AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI fuera de rango';
    END IF;
    IF NEW.psd IS NOT NULL AND NEW.psd<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PSD negativa'; END IF;
END $$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE visual_field_exams SET vfi=101 WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: VFI fuera de rango. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-30"></a>

### 30.

Normalizar observaciones eliminando espacios innecesarios antes de actualizar.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_obs_trim_bu$$
CREATE TRIGGER trg_visit_obs_trim_bu
    BEFORE UPDATE
    ON medical_visits
    FOR EACH ROW
    SET NEW.observations=TRIM(NEW.observations) $$
DELIMITER ;
```

## AFTER UPDATE

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE medical_visits SET observations='  Texto  ' WHERE id=1;
SELECT (SELECT observations='Texto' FROM medical_visits WHERE id=1) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-31"></a>

### 31.

Registrar cambios de datos personales del paciente.

**Respuesta:**

El correo se audita exclusivamente en el trigger 32; así no se duplica ese dato.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_au$$
CREATE TRIGGER trg_patient_au AFTER UPDATE ON patients FOR EACH ROW
BEGIN
IF NOT(OLD.document_type_id <=> NEW.document_type_id) OR NOT(OLD.document_number <=> NEW.document_number) OR NOT(OLD.first_name <=> NEW.first_name) OR NOT(OLD.last_name <=> NEW.last_name) OR NOT(OLD.birth_date <=> NEW.birth_date) OR NOT(OLD.sex <=> NEW.sex) OR NOT(OLD.phone <=> NEW.phone) OR NOT(OLD.city <=> NEW.city) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('document_type_id',OLD.document_type_id,'document_number',OLD.document_number,'first_name',OLD.first_name,'last_name',OLD.last_name,'birth_date',OLD.birth_date,'sex',OLD.sex,'phone',OLD.phone,'city',OLD.city),JSON_OBJECT('document_type_id',NEW.document_type_id,'document_number',NEW.document_number,'first_name',NEW.first_name,'last_name',NEW.last_name,'birth_date',NEW.birth_date,'sex',NEW.sex,'phone',NEW.phone,'city',NEW.city),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='UPDATE'); UPDATE patients SET phone='NUEVO555' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-32"></a>

### 32.

Guardar valor anterior y nuevo del correo del paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_email_au$$
CREATE TRIGGER trg_patient_email_au AFTER UPDATE ON patients FOR EACH ROW
BEGIN
IF NOT(OLD.email <=> NEW.email) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('email',OLD.email),JSON_OBJECT('email',NEW.email),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients' AND action='UPDATE'); UPDATE patients SET email='nuevo@example.com' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='patients' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-33"></a>

### 33.

Registrar cambios en la presión objetivo.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_glaucoma_target_au$$
CREATE TRIGGER trg_glaucoma_target_au AFTER UPDATE ON glaucoma_controls FOR EACH ROW
BEGIN
IF NOT(OLD.target_pressure <=> NEW.target_pressure) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('glaucoma_controls',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('target_pressure',OLD.target_pressure),JSON_OBJECT('target_pressure',NEW.target_pressure),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE'); UPDATE glaucoma_controls SET target_pressure=20 WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-34"></a>

### 34.

Auditar cambios en el estado del glaucoma.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_glaucoma_status_au$$
CREATE TRIGGER trg_glaucoma_status_au AFTER UPDATE ON glaucoma_controls FOR EACH ROW
BEGIN
IF NOT(OLD.clinical_status <=> NEW.clinical_status) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('glaucoma_controls',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('clinical_status',OLD.clinical_status),JSON_OBJECT('clinical_status',NEW.clinical_status),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE'); UPDATE glaucoma_controls SET clinical_status='Cambio' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='glaucoma_controls' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-35"></a>

### 35.

Registrar cambios en tratamientos.

**Respuesta:**

La transición de finalización se audita únicamente en 40, con la fila completa.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_au$$
CREATE TRIGGER trg_treatment_au AFTER UPDATE ON treatments FOR EACH ROW
BEGIN
IF NOT(OLD.active=TRUE AND NEW.active=FALSE) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('treatments',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('visit_id',OLD.visit_id,'medication_id',OLD.medication_id,'eye',OLD.eye,'start_date',OLD.start_date,'end_date',OLD.end_date,'active',OLD.active,'dose',OLD.dose,'frequency',OLD.frequency,'notes',OLD.notes),JSON_OBJECT('visit_id',NEW.visit_id,'medication_id',NEW.medication_id,'eye',NEW.eye,'start_date',NEW.start_date,'end_date',NEW.end_date,'active',NEW.active,'dose',NEW.dose,'frequency',NEW.frequency,'notes',NEW.notes),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments' AND action='UPDATE'); UPDATE treatments SET notes='Cambio' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='treatments' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-36"></a>

### 36.

Registrar cambios en diagnósticos.

**Respuesta:**

Diagnóstico significa el catálogo diagnoses; la asociación se audita al insertar en 14.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_diagnosis_au$$
CREATE TRIGGER trg_diagnosis_au AFTER UPDATE ON diagnoses FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('diagnoses',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('code',OLD.code,'name',OLD.name,'glaucoma_type',OLD.glaucoma_type),JSON_OBJECT('code',NEW.code,'name',NEW.name,'glaucoma_type',NEW.glaucoma_type),USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='diagnoses' AND action='UPDATE'); UPDATE diagnoses SET name='Cambio' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='diagnoses' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-37"></a>

### 37.

Registrar cambios de interpretación de OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_oct_interpretation_au$$
CREATE TRIGGER trg_oct_interpretation_au AFTER UPDATE ON oct_exams FOR EACH ROW
BEGIN
IF NOT(OLD.interpretation <=> NEW.interpretation) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('oct_exams',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('interpretation',OLD.interpretation),JSON_OBJECT('interpretation',NEW.interpretation),USER()); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='oct_exams' AND action='UPDATE'); UPDATE oct_exams SET interpretation='Cambio' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='oct_exams' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-38"></a>

### 38.

Registrar modificaciones de campos visuales.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_vf_au$$
CREATE TRIGGER trg_vf_au AFTER UPDATE ON visual_field_exams FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('visual_field_exams',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('eye',OLD.eye,'md',OLD.md,'psd',OLD.psd,'vfi',OLD.vfi,'interpretation',OLD.interpretation),JSON_OBJECT('eye',NEW.eye,'md',NEW.md,'psd',NEW.psd,'vfi',NEW.vfi,'interpretation',NEW.interpretation),USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='visual_field_exams' AND action='UPDATE'); UPDATE visual_field_exams SET interpretation='Cambio' WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM audit_logs WHERE table_name='visual_field_exams' AND action='UPDATE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-39"></a>

### 39.

Generar una alerta cuando una PIO sea actualizada a un valor superior al objetivo.

**Respuesta:**

Se usa el último objetivo del mismo ojo vigente a la fecha de medición; sin objetivo no se genera alerta.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_iop_above_target_au$$
CREATE TRIGGER trg_iop_above_target_au AFTER UPDATE ON intraocular_pressures FOR EACH ROW
BEGIN
DECLARE v_patient BIGINT; DECLARE v_target DECIMAL(5,2);
SELECT ch.patient_id INTO v_patient FROM medical_visits m JOIN clinical_histories ch ON ch.id=m.clinical_history_id WHERE m.id=NEW.visit_id;
SET v_target=(SELECT c.target_pressure FROM glaucoma_controls c JOIN glaucoma_records r ON r.id=c.glaucoma_record_id WHERE r.patient_id=v_patient AND r.eye=NEW.eye AND c.control_date<=NEW.measured_at ORDER BY c.control_date DESC,c.id DESC LIMIT 1);
IF v_target IS NOT NULL AND NEW.pressure>v_target THEN INSERT INTO notifications(patient_id,message) VALUES(v_patient,CONCAT('PIO ',NEW.eye,' superior al objetivo histórico ',v_target)); END IF;
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE glaucoma_controls SET target_pressure=18 WHERE glaucoma_record_id=1; SET @a=(SELECT COUNT(*) FROM notifications); UPDATE intraocular_pressures SET measured_at='2026-09-30',pressure=30 WHERE id=1;
SELECT (SELECT COUNT(*)>@a FROM notifications) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-40"></a>

### 40.

Registrar cuándo un tratamiento cambia de activo a finalizado.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_finished_au$$
CREATE TRIGGER trg_treatment_finished_au AFTER UPDATE ON treatments FOR EACH ROW
BEGIN
IF OLD.active=TRUE AND NEW.active=FALSE THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('treatments',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('visit_id',OLD.visit_id,'medication_id',OLD.medication_id,'eye',OLD.eye,'start_date',OLD.start_date,'end_date',OLD.end_date,'active',OLD.active,'dose',OLD.dose,'frequency',OLD.frequency,'notes',OLD.notes),JSON_OBJECT('visit_id',NEW.visit_id,'medication_id',NEW.medication_id,'eye',NEW.eye,'start_date',NEW.start_date,'end_date',NEW.end_date,'active',NEW.active,'dose',NEW.dose,'frequency',NEW.frequency,'notes',NEW.notes),USER()); END IF;
END$$
DELIMITER ;
```

## DELETE y auditoría

**Código para comprobar la regla:**

```sql
START TRANSACTION;
UPDATE treatments SET active=TRUE WHERE id=1; SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='treatments'); UPDATE treatments SET active=FALSE WHERE id=1;
SELECT (SELECT COUNT(*)=@a+1 FROM audit_logs WHERE table_name='treatments') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-41"></a>

### 41.

Guardar una copia de un paciente antes de eliminarlo.

**Respuesta:**

Si una FK u otro trigger impide el DELETE, también se revierte esta copia: InnoDB no permite auditoría autónoma de intentos fallidos.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_bd$$
CREATE TRIGGER trg_patient_bd BEFORE DELETE ON patients FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'document_type_id',OLD.document_type_id,'document_number',OLD.document_number,'first_name',OLD.first_name,'last_name',OLD.last_name,'birth_date',OLD.birth_date,'sex',OLD.sex,'phone',OLD.phone,'email',OLD.email,'city',OLD.city,'created_at',OLD.created_at,'updated_at',OLD.updated_at),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM patients WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Paciente con historia clínica. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-42"></a>

### 42.

Guardar una copia de una consulta eliminada.

**Respuesta:**

Si una FK u otro trigger impide el DELETE, también se revierte esta copia: InnoDB no permite auditoría autónoma de intentos fallidos.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_visit_bd$$
CREATE TRIGGER trg_visit_bd BEFORE DELETE ON medical_visits FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('medical_visits',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'clinical_history_id',OLD.clinical_history_id,'professional_id',OLD.professional_id,'visit_date',OLD.visit_date,'reason',OLD.reason,'assessment',OLD.assessment,'plan',OLD.plan,'observations',OLD.observations,'status',OLD.status,'updated_at',OLD.updated_at),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date) VALUES(1,1,'2026-09-30'); SET @v=LAST_INSERT_ID(); DELETE FROM medical_visits WHERE id=@v;
SELECT EXISTS(SELECT 1 FROM audit_logs WHERE table_name='medical_visits' AND record_key=CAST(@v AS CHAR) AND action='DELETE' AND old_data IS NOT NULL) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-43"></a>

### 43.

Guardar un histórico de un tratamiento eliminado.

**Respuesta:**

Si una FK u otro trigger impide el DELETE, también se revierte esta copia: InnoDB no permite auditoría autónoma de intentos fallidos.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_treatment_bd$$
CREATE TRIGGER trg_treatment_bd BEFORE DELETE ON treatments FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('treatments',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'visit_id',OLD.visit_id,'medication_id',OLD.medication_id,'eye',OLD.eye,'start_date',OLD.start_date,'end_date',OLD.end_date,'active',OLD.active,'dose',OLD.dose,'frequency',OLD.frequency,'notes',OLD.notes),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM treatments WHERE id=1;
SELECT EXISTS(SELECT 1 FROM audit_logs WHERE table_name='treatments' AND record_key='1' AND action='DELETE' AND old_data IS NOT NULL) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-44"></a>

### 44.

Registrar en auditoría la eliminación de un diagnóstico.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_diagnosis_ad$$
CREATE TRIGGER trg_diagnosis_ad AFTER DELETE ON diagnoses FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('diagnoses',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'code',OLD.code,'name',OLD.name,'glaucoma_type',OLD.glaucoma_type),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM diagnoses WHERE id=10;
SELECT EXISTS(SELECT 1 FROM audit_logs WHERE table_name='diagnoses' AND record_key='10' AND action='DELETE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-45"></a>

### 45.

Impedir eliminar pacientes que tengan historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_no_history_bd$$
CREATE TRIGGER trg_patient_no_history_bd
    BEFORE DELETE
    ON patients
    FOR EACH ROW
    BEGIN
        IF EXISTS(SELECT 1
            FROM clinical_histories
            WHERE patient_id=OLD.id
    ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente con historia clínica';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM patients WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Paciente con historia clínica. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-46"></a>

### 46.

Impedir eliminar profesionales con consultas registradas.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_professional_no_visits_bd$$
CREATE TRIGGER trg_professional_no_visits_bd
    BEFORE DELETE
    ON healthcare_professionals
    FOR EACH ROW
    BEGIN
        IF EXISTS(SELECT 1
            FROM medical_visits
            WHERE professional_id=OLD.id
    ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Profesional con consultas';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM healthcare_professionals WHERE id=1;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Profesional con consultas. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-47"></a>

### 47.

Impedir eliminar medicamentos actualmente utilizados en tratamientos activos.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_medication_active_use_bd$$
CREATE TRIGGER trg_medication_active_use_bd
    BEFORE DELETE
    ON medications
    FOR EACH ROW
    BEGIN
        IF EXISTS(SELECT 1
            FROM v_treatments
            WHERE medication_id=OLD.id
            AND active=TRUE
    ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Medicamento en tratamiento activo';
        END IF;
    END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM medications WHERE id=2;
ROLLBACK;
```

Resultado registrado: rechazo esperado: Medicamento en tratamiento activo. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-48"></a>

### 48.

Registrar automáticamente la eliminación de un examen OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_oct_ad$$
CREATE TRIGGER trg_oct_ad AFTER DELETE ON oct_exams FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('oct_exams',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'visit_id',OLD.visit_id,'eye',OLD.eye,'exam_date',OLD.exam_date,'rnfl',OLD.rnfl,'interpretation',OLD.interpretation,'validated',OLD.validated),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM oct_exams WHERE id=1;
SELECT EXISTS(SELECT 1 FROM audit_logs WHERE table_name='oct_exams' AND record_key='1' AND action='DELETE') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-49"></a>

### 49.

Registrar quién eliminó un documento clínico.

**Respuesta:**

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_document_ad$$
CREATE TRIGGER trg_document_ad AFTER DELETE ON clinical_documents FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('clinical_documents',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'clinical_history_id',OLD.clinical_history_id,'document_type',OLD.document_type,'file_name',OLD.file_name,'file_uri',OLD.file_uri,'created_at',OLD.created_at),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
DELETE FROM clinical_documents WHERE id=1;
SELECT EXISTS(SELECT 1 FROM audit_logs WHERE table_name='clinical_documents' AND record_key='1' AND action='DELETE' AND changed_by=USER()) AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="ejercicio-4-50"></a>

### 50.

Implementar un esquema completo de auditoría mediante triggers para `INSERT`, `UPDATE` y `DELETE` sobre la tabla `patients`.

**Respuesta:**

Solución ejecutable completa reutiliza los nombres 11,31,41 y los reinstala, sin crear un segundo juego. El correo sigue auditado por 32. El borrado de pacientes con historia se rechaza por 45; su auditoría se revierte.

```sql
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_ai$$
CREATE TRIGGER trg_patient_ai AFTER INSERT ON patients FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(NEW.id AS CHAR),'INSERT',NULL,JSON_OBJECT('id',NEW.id,'document_type_id',NEW.document_type_id,'document_number',NEW.document_number,'first_name',NEW.first_name,'last_name',NEW.last_name,'birth_date',NEW.birth_date,'sex',NEW.sex,'phone',NEW.phone,'email',NEW.email,'city',NEW.city,'created_at',NEW.created_at,'updated_at',NEW.updated_at),USER());
END$$
DELIMITER ;
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_au$$
CREATE TRIGGER trg_patient_au AFTER UPDATE ON patients FOR EACH ROW
BEGIN
IF NOT(OLD.document_type_id <=> NEW.document_type_id) OR NOT(OLD.document_number <=> NEW.document_number) OR NOT(OLD.first_name <=> NEW.first_name) OR NOT(OLD.last_name <=> NEW.last_name) OR NOT(OLD.birth_date <=> NEW.birth_date) OR NOT(OLD.sex <=> NEW.sex) OR NOT(OLD.phone <=> NEW.phone) OR NOT(OLD.city <=> NEW.city) THEN INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(NEW.id AS CHAR),'UPDATE',JSON_OBJECT('document_type_id',OLD.document_type_id,'document_number',OLD.document_number,'first_name',OLD.first_name,'last_name',OLD.last_name,'birth_date',OLD.birth_date,'sex',OLD.sex,'phone',OLD.phone,'city',OLD.city),JSON_OBJECT('document_type_id',NEW.document_type_id,'document_number',NEW.document_number,'first_name',NEW.first_name,'last_name',NEW.last_name,'birth_date',NEW.birth_date,'sex',NEW.sex,'phone',NEW.phone,'city',NEW.city),USER()); END IF;
END$$
DELIMITER ;
DELIMITER $$
DROP TRIGGER IF EXISTS trg_patient_bd$$
CREATE TRIGGER trg_patient_bd BEFORE DELETE ON patients FOR EACH ROW
BEGIN
INSERT INTO audit_logs(table_name,record_key,action,old_data,new_data,changed_by) VALUES('patients',CAST(OLD.id AS CHAR),'DELETE',JSON_OBJECT('id',OLD.id,'document_type_id',OLD.document_type_id,'document_number',OLD.document_number,'first_name',OLD.first_name,'last_name',OLD.last_name,'birth_date',OLD.birth_date,'sex',OLD.sex,'phone',OLD.phone,'email',OLD.email,'city',OLD.city,'created_at',OLD.created_at,'updated_at',OLD.updated_at),NULL,USER());
END$$
DELIMITER ;
```

**Código para comprobar la regla:**

```sql
START TRANSACTION;
SET @a=(SELECT COUNT(*) FROM audit_logs WHERE table_name='patients'); INSERT INTO patients(document_type_id,document_number,first_name,last_name,birth_date,email) VALUES(1,'  xA001  ','  Nombre  ','  Apellido  ','1970-01-01','PERSONA@EXAMPLE.COM'); SET @p=LAST_INSERT_ID(); UPDATE patients SET phone='555' WHERE id=@p;
SELECT (SELECT COUNT(*)=@a+2 FROM audit_logs WHERE table_name='patients') AS comprobacion;
ROLLBACK;
```

Resultado registrado: operación aceptada y comprobación igual a 1. Detalle en [pruebas de triggers](#e-triggers-y-restricciones). Si MySQL Workbench detiene el bloque por el error esperado, ejecutar ROLLBACK por separado.

<a id="parte-5"></a>

# PARTE V — 50 EJERCICIOS DE FUNCIONES ALMACENADAS

## Funciones básicas

<a id="ejercicio-5-1"></a>

### 1.

Crear una función que calcule la edad de un paciente a partir de su fecha de nacimiento.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_age$$
CREATE FUNCTION fn_patient_age(p_birth DATE)
RETURNS INT
NOT DETERMINISTIC NO SQL
    RETURN TIMESTAMPDIFF(YEAR,p_birth,CURDATE()) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_age('1970-01-01') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
56
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-2"></a>

### 2.

Crear una función que reciba nombres y apellidos y retorne el nombre completo.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_full_name$$
CREATE FUNCTION fn_full_name(
    p_first VARCHAR(100),
    p_last VARCHAR(100)
)
RETURNS VARCHAR(201)
DETERMINISTIC
    RETURN CONCAT_WS(' ',p_first,p_last) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_full_name('A','B') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
A B
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-3"></a>

### 3.

Crear una función que reciba un ID de paciente y retorne su número de documento.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_document$$
CREATE FUNCTION fn_patient_document(p_id BIGINT)
RETURNS VARCHAR(30) READS SQL DATA
BEGIN
    DECLARE v VARCHAR(30);
    SELECT document_number INTO v
    FROM patients
    WHERE id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_document(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
101001
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-4"></a>

### 4.

Crear una función que reciba un ID de paciente y retorne su edad.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_age_by_id$$
CREATE FUNCTION fn_patient_age_by_id(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v DATE;
    SELECT birth_date INTO v
    FROM patients
    WHERE id=p_id; RETURN TIMESTAMPDIFF(YEAR,v,CURDATE());
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_age_by_id(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
75
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-5"></a>

### 5.

Crear una función que reciba el ID de una consulta y retorne su fecha.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_visit_date$$
CREATE FUNCTION fn_visit_date(p_id BIGINT)
RETURNS DATETIME READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    SELECT visit_date INTO v
    FROM medical_visits
    WHERE id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_visit_date(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
2026-09-01 10:00:00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-6"></a>

### 6.

Crear una función que determine cuántos años han pasado desde una fecha.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_years_since$$
CREATE FUNCTION fn_years_since(p_date DATE)
RETURNS INT
NOT DETERMINISTIC NO SQL
    RETURN TIMESTAMPDIFF(YEAR,p_date,CURDATE()) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_years_since('2000-01-01') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
26
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-7"></a>

### 7.

Crear una función que reciba un valor de PIO y retorne un texto descriptivo.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_iop_description$$
CREATE FUNCTION fn_iop_description(p_value DECIMAL(5,2)) RETURNS VARCHAR(80)
DETERMINISTIC NO SQL
BEGIN
RETURN CASE WHEN p_value IS NULL THEN 'Sin dato' WHEN p_value<0 THEN 'Valor inválido' ELSE CONCAT('PIO registrada: ',p_value,' mmHg') END;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_iop_description(18) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
PIO registrada: 18.00 mmHg
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-8"></a>

### 8.

Crear una función que reciba `OD` u `OI` y devuelva `Ojo derecho` u `Ojo izquierdo`.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_eye_name$$
CREATE FUNCTION fn_eye_name(p_eye CHAR(2))
RETURNS VARCHAR(20)
DETERMINISTIC
    RETURN CASE p_eye WHEN 'OD' THEN 'Ojo derecho' WHEN 'OI' THEN 'Ojo izquierdo' ELSE NULL
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_eye_name('OD') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Ojo derecho
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-9"></a>

### 9.

Crear una función que reciba un booleano y retorne `Activo` o `Inactivo`.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_boolean_status$$
CREATE FUNCTION fn_boolean_status(p_value BOOLEAN)
RETURNS VARCHAR(10)
DETERMINISTIC
    RETURN IF(p_value,'Activo','Inactivo') $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_boolean_status(TRUE) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Activo
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-10"></a>

### 10.

Crear una función que formatee un número de historia clínica.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_format_history$$
CREATE FUNCTION fn_format_history(p_id BIGINT)
RETURNS VARCHAR(20)
DETERMINISTIC
    RETURN CONCAT('HC-',LPAD(p_id,6,'0')) $$
DELIMITER ;
```

## Funciones con consultas

**Código para obtener la evidencia:**

```sql
SELECT fn_format_history(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
HC-000001
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-11"></a>

### 11.

Crear una función que retorne la cantidad de consultas de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_visit_count$$
CREATE FUNCTION fn_patient_visit_count(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(*) INTO v
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_visit_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
6
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-12"></a>

### 12.

Crear una función que retorne la cantidad de diagnósticos de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_diagnosis_count$$
CREATE FUNCTION fn_patient_diagnosis_count(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(*) INTO v
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    JOIN visit_diagnoses vd
        ON vd.visit_id=mv.id
    WHERE ch.patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_diagnosis_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
5
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-13"></a>

### 13.

Crear una función que retorne la cantidad de controles de glaucoma de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_glaucoma_control_count$$
CREATE FUNCTION fn_glaucoma_control_count(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(*) INTO v
    FROM v_glaucoma_controls
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_glaucoma_control_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
3
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-14"></a>

### 14.

Crear una función que retorne la última fecha de consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_last_visit$$
CREATE FUNCTION fn_last_visit(p_id BIGINT)
RETURNS DATETIME READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    SELECT MAX(mv.visit_date) INTO v
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_last_visit(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
2026-09-28 00:00:00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-15"></a>

### 15.

Crear una función que retorne la primera fecha de consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_first_visit$$
CREATE FUNCTION fn_first_visit(p_id BIGINT)
RETURNS DATETIME READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    SELECT MIN(mv.visit_date) INTO v
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    WHERE ch.patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_first_visit(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
2026-09-01 10:00:00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-16"></a>

### 16.

Crear una función que retorne la presión intraocular promedio de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_iop$$
CREATE FUNCTION fn_avg_iop(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_iop(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
20.20
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-17"></a>

### 17.

Crear una función que retorne la presión promedio de OD.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_iop_od$$
CREATE FUNCTION fn_avg_iop_od(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND eye='OD'; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_iop_od(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
19.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-18"></a>

### 18.

Crear una función que retorne la presión promedio de OI.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_iop_oi$$
CREATE FUNCTION fn_avg_iop_oi(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND eye='OI'; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_iop_oi(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
25.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-19"></a>

### 19.

Crear una función que retorne la PIO máxima registrada para un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_max_iop$$
CREATE FUNCTION fn_max_iop(p_id BIGINT)
RETURNS DECIMAL(5,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(5,2);
    SELECT MAX(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_max_iop(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
28.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-20"></a>

### 20.

Crear una función que retorne la PIO mínima registrada.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_min_iop$$
CREATE FUNCTION fn_min_iop(p_id BIGINT)
RETURNS DECIMAL(5,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(5,2);
    SELECT MIN(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

## Funciones clínicas y de clasificación

**Código para obtener la evidencia:**

```sql
SELECT fn_min_iop(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
13.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-21"></a>

### 21.

Crear una función que clasifique una PIO según rangos definidos para fines académicos.

**Respuesta:**

Cortes académicos elegidos: A=[0,10), B=[10,20], C=(20,+∞). No clasificación médica.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_iop_academic_range$$
CREATE FUNCTION fn_iop_academic_range(p_value DECIMAL(5,2)) RETURNS VARCHAR(30)
DETERMINISTIC NO SQL
BEGIN
RETURN CASE WHEN p_value IS NULL THEN 'Sin dato' WHEN p_value<0 THEN 'Inválido' WHEN p_value<10 THEN 'Rango A' WHEN p_value<=20 THEN 'Rango B' ELSE 'Rango C' END;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_iop_academic_range(18) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Rango B
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-22"></a>

### 22.

Crear una función que indique si una PIO supera una presión objetivo recibida como parámetro.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_iop_above_target$$
CREATE FUNCTION fn_iop_above_target(
    p_iop DECIMAL(5,2),
    p_target DECIMAL(5,2)
)
RETURNS BOOLEAN
DETERMINISTIC
    RETURN p_iop>p_target $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_iop_above_target(19,18) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-23"></a>

### 23.

Crear una función que determine si un paciente tiene diagnóstico de glaucoma.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_has_glaucoma$$
CREATE FUNCTION fn_has_glaucoma(p_id BIGINT)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    JOIN visit_diagnoses vd
        ON vd.visit_id=mv.id
    JOIN diagnoses d
        ON d.id=vd.diagnosis_id
    WHERE ch.patient_id=p_id
        AND d.name LIKE '%Glaucoma%') $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_has_glaucoma(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-24"></a>

### 24.

Crear una función que determine si un paciente tiene tratamientos activos.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_has_active_treatment$$
CREATE FUNCTION fn_has_active_treatment(p_id BIGINT)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM v_treatments
    WHERE patient_id=p_id
        AND active=TRUE) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_has_active_treatment(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
0
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-25"></a>

### 25.

Crear una función que indique si el paciente tiene al menos un OCT registrado.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_has_oct$$
CREATE FUNCTION fn_has_oct(p_id BIGINT)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM v_oct_exams
    WHERE patient_id=p_id) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_has_oct(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-26"></a>

### 26.

Crear una función que indique si tiene campo visual registrado.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_has_visual_field$$
CREATE FUNCTION fn_has_visual_field(p_id BIGINT)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM v_visual_field_exams
    WHERE patient_id=p_id) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_has_visual_field(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-27"></a>

### 27.

Crear una función que determine si tiene paquimetría.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_has_pachymetry$$
CREATE FUNCTION fn_has_pachymetry(p_id BIGINT)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM v_pachymetry_exams
    WHERE patient_id=p_id) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_has_pachymetry(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-28"></a>

### 28.

Crear una función que determine si el paciente tiene controles pendientes según un número de meses.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_control_pending$$
CREATE FUNCTION fn_control_pending(
    p_id BIGINT,
    p_months INT
)
RETURNS BOOLEAN READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    IF p_months IS NULL OR p_months<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Meses inválidos'; END IF;
    SELECT MAX(control_date) INTO v
    FROM v_glaucoma_controls
    WHERE patient_id=p_id; RETURN v IS NULL
        OR v<DATE_SUB(CURDATE(),INTERVAL p_months MONTH);
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_control_pending(1,3) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
0
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-29"></a>

### 29.

Crear una función que clasifique un paciente según cantidad de consultas: nuevo, recurrente o frecuente.

**Respuesta:**

Regla académica elegida: nuevo 0–1 consultas, recurrente 2–4, frecuente ≥5.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_frequency$$
CREATE FUNCTION fn_patient_frequency(p_id BIGINT) RETURNS VARCHAR(15)
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE n INT; SET n=fn_patient_visit_count(p_id); RETURN CASE WHEN n<=1 THEN 'Nuevo' WHEN n<=4 THEN 'Recurrente' ELSE 'Frecuente' END;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_frequency(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Frecuente
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-30"></a>

### 30.

Crear una función que retorne `Completo` si el paciente tiene OCT, campo visual, PIO y paquimetría, o `Incompleto` en caso contrario.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_exam_set_status$$
CREATE FUNCTION fn_exam_set_status(p_id BIGINT)
RETURNS VARCHAR(10) READS SQL DATA
    RETURN IF(EXISTS(SELECT 1
    FROM v_oct_exams
    WHERE patient_id=p_id)
        AND EXISTS(SELECT 1
    FROM v_visual_field_exams
    WHERE patient_id=p_id)
        AND EXISTS(SELECT 1
    FROM v_intraocular_pressures
    WHERE patient_id=p_id)
        AND EXISTS(SELECT 1
    FROM v_pachymetry_exams
    WHERE patient_id=p_id),'Completo','Incompleto') $$
DELIMITER ;
```

## Funciones estadísticas

**Código para obtener la evidencia:**

```sql
SELECT fn_exam_set_status(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Completo
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-31"></a>

### 31.

Crear una función que calcule el promedio de PIO entre dos fechas para un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_iop_between$$
CREATE FUNCTION fn_avg_iop_between(
    p_id BIGINT,
    p_from DATETIME,
    p_to DATETIME
)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND measured_at BETWEEN p_from
        AND p_to; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_iop_between(1,'2026-01-01','2026-10-01') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
20.20
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-32"></a>

### 32.

Crear una función que calcule la diferencia entre la primera y última PIO.

**Respuesta:**

Se recibe ojo para comparar mediciones del mismo ojo; sin mediciones retorna NULL.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_first_last_iop_diff$$
CREATE FUNCTION fn_first_last_iop_diff(p_id BIGINT, p_eye CHAR(2))
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE a DECIMAL(5,2); DECLARE b DECIMAL(5,2);
    SELECT pressure INTO a
    FROM v_intraocular_pressures
    WHERE patient_id=p_id AND eye=p_eye
    ORDER BY measured_at,id
    LIMIT 1;
    SELECT pressure INTO b
    FROM v_intraocular_pressures
    WHERE patient_id=p_id AND eye=p_eye
    ORDER BY measured_at DESC,id DESC
    LIMIT 1; RETURN b-a;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_first_last_iop_diff(1,'OD') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
6.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-33"></a>

### 33.

Crear una función que retorne el número de días desde la última consulta.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_days_since_last_visit$$
CREATE FUNCTION fn_days_since_last_visit(p_id BIGINT)
RETURNS INT READS SQL DATA
    RETURN DATEDIFF(CURDATE(),DATE(fn_last_visit(p_id))) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_days_since_last_visit(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
10
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-34"></a>

### 34.

Crear una función que retorne el número de meses desde el último OCT.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_months_since_last_oct$$
CREATE FUNCTION fn_months_since_last_oct(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    SELECT MAX(exam_date) INTO v
    FROM v_oct_exams
    WHERE patient_id=p_id; RETURN TIMESTAMPDIFF(MONTH,v,CURDATE());
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_months_since_last_oct(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
0
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-35"></a>

### 35.

Crear una función que retorne el número de meses desde el último campo visual.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_months_since_last_visual_field$$
CREATE FUNCTION fn_months_since_last_visual_field(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v DATETIME;
    SELECT MAX(exam_date) INTO v
    FROM v_visual_field_exams
    WHERE patient_id=p_id; RETURN TIMESTAMPDIFF(MONTH,v,CURDATE());
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_months_since_last_visual_field(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
0
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-36"></a>

### 36.

Crear una función que calcule el promedio de RNFL de los OCT de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_rnfl$$
CREATE FUNCTION fn_avg_rnfl(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(rnfl) INTO v
    FROM v_oct_exams
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_rnfl(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
75.67
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-37"></a>

### 37.

Crear una función que retorne el valor más reciente de RNFL.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_latest_rnfl$$
CREATE FUNCTION fn_latest_rnfl(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT rnfl INTO v
    FROM v_oct_exams
    WHERE patient_id=p_id
    ORDER BY exam_date DESC,id DESC
    LIMIT 1; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_latest_rnfl(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
80.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-38"></a>

### 38.

Crear una función que calcule el promedio de VFI de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_vfi$$
CREATE FUNCTION fn_avg_vfi(p_id BIGINT)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(vfi) INTO v
    FROM v_visual_field_exams
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_vfi(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
84.25
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-39"></a>

### 39.

Crear una función que retorne la cantidad de tratamientos históricos.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_treatment_history_count$$
CREATE FUNCTION fn_treatment_history_count(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(*) INTO v
    FROM v_treatments
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_treatment_history_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
3
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-40"></a>

### 40.

Crear una función que retorne la cantidad de medicamentos diferentes utilizados por un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_distinct_medications$$
CREATE FUNCTION fn_distinct_medications(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(DISTINCT medication_id) INTO v
    FROM v_treatments
    WHERE patient_id=p_id
        AND medication_id IS NOT NULL; RETURN v;
END $$
DELIMITER ;
```

## Funciones avanzadas

**Código para obtener la evidencia:**

```sql
SELECT fn_distinct_medications(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-41"></a>

### 41.

Crear una función que reciba paciente y ojo y retorne la última PIO registrada.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_last_iop_eye$$
CREATE FUNCTION fn_last_iop_eye(
    p_id BIGINT,
    p_eye CHAR(2)
)
RETURNS DECIMAL(5,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(5,2);
    SELECT pressure INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND eye=p_eye
    ORDER BY measured_at DESC,id DESC
    LIMIT 1; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_last_iop_eye(1,'OD') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
19.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-42"></a>

### 42.

Crear una función que reciba paciente y ojo y retorne la PIO promedio.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_avg_iop_eye$$
CREATE FUNCTION fn_avg_iop_eye(
    p_id BIGINT,
    p_eye CHAR(2)
)
RETURNS DECIMAL(7,2) READS SQL DATA
BEGIN
    DECLARE v DECIMAL(7,2);
    SELECT AVG(pressure) INTO v
    FROM v_intraocular_pressures
    WHERE patient_id=p_id
        AND eye=p_eye; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_avg_iop_eye(1,'OI') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
25.00
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-43"></a>

### 43.

Crear una función que determine si la última PIO es mayor o menor que la primera.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_iop_trend$$
CREATE FUNCTION fn_iop_trend(p_id BIGINT, p_eye CHAR(2)) RETURNS VARCHAR(12)
NOT DETERMINISTIC READS SQL DATA
BEGIN
DECLARE d DECIMAL(7,2); SET d=fn_first_last_iop_diff(p_id,p_eye); RETURN CASE WHEN d IS NULL THEN 'Sin datos' WHEN d>0 THEN 'Mayor' WHEN d<0 THEN 'Menor' ELSE 'Igual' END;
END$$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_iop_trend(1,'OD') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Mayor
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-44"></a>

### 44.

Crear una función que retorne la diferencia porcentual entre primera y última PIO.

**Respuesta:**

Se recibe ojo para comparar mediciones del mismo ojo; sin mediciones retorna NULL.

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_iop_percent_change$$
CREATE FUNCTION fn_iop_percent_change(p_id BIGINT, p_eye CHAR(2))
RETURNS DECIMAL(9,2) READS SQL DATA
BEGIN
    DECLARE a DECIMAL(5,2); DECLARE b DECIMAL(5,2);
    SELECT pressure INTO a
    FROM v_intraocular_pressures
    WHERE patient_id=p_id AND eye=p_eye
    ORDER BY measured_at,id
    LIMIT 1;
    SELECT pressure INTO b
    FROM v_intraocular_pressures
    WHERE patient_id=p_id AND eye=p_eye
    ORDER BY measured_at DESC,id DESC
    LIMIT 1; RETURN IF(a=0,NULL,((b-a)/a)*100);
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_iop_percent_change(1,'OD') AS resultado;
```

Resultado de la ejecución registrada:

```text
result
46.15
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-45"></a>

### 45.

Crear una función que retorne el diagnóstico principal más reciente de un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_latest_primary_diagnosis$$
CREATE FUNCTION fn_latest_primary_diagnosis(p_id BIGINT)
RETURNS VARCHAR(150) READS SQL DATA
BEGIN
    DECLARE v VARCHAR(150);
    SELECT d.name INTO v
    FROM clinical_histories ch
    JOIN medical_visits mv
        ON mv.clinical_history_id=ch.id
    JOIN visit_diagnoses vd
        ON vd.visit_id=mv.id
    JOIN diagnoses d
        ON d.id=vd.diagnosis_id
    WHERE ch.patient_id=p_id
        AND vd.is_primary=TRUE
    ORDER BY mv.visit_date DESC,mv.id DESC,vd.diagnosis_id,vd.eye
    LIMIT 1; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_latest_primary_diagnosis(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Diagnóstico 7
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-46"></a>

### 46.

Crear una función que retorne el nombre del medicamento activo más reciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_latest_active_medication$$
CREATE FUNCTION fn_latest_active_medication(p_id BIGINT)
RETURNS VARCHAR(150) READS SQL DATA
BEGIN
    DECLARE v VARCHAR(150);
    SELECT m.name INTO v
    FROM v_treatments t
    JOIN medications m
        ON m.id=t.medication_id
    WHERE t.patient_id=p_id
        AND t.active=TRUE
    ORDER BY t.start_date DESC,t.id DESC
    LIMIT 1; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_latest_active_medication(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
NULL
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-47"></a>

### 47.

Crear una función que retorne la cantidad de procedimientos realizados a un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_procedure_count$$
CREATE FUNCTION fn_procedure_count(p_id BIGINT)
RETURNS INT READS SQL DATA
BEGIN
    DECLARE v INT;
    SELECT COUNT(*) INTO v
    FROM v_procedures
    WHERE patient_id=p_id; RETURN v;
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_procedure_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-48"></a>

### 48.

Crear una función que determine si un profesional ha atendido alguna vez a un paciente específico.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_professional_saw_patient$$
CREATE FUNCTION fn_professional_saw_patient(
    p_prof BIGINT,
    p_patient BIGINT
)
RETURNS BOOLEAN READS SQL DATA
    RETURN EXISTS(SELECT 1
    FROM medical_visits mv
    JOIN clinical_histories ch
        ON ch.id=mv.clinical_history_id
    WHERE mv.professional_id=p_prof
        AND ch.patient_id=p_patient) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_professional_saw_patient(1,1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
1
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-49"></a>

### 49.

Crear una función que calcule la cantidad total de exámenes especializados registrados para un paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_special_exam_count$$
CREATE FUNCTION fn_special_exam_count(p_id BIGINT)
RETURNS INT READS SQL DATA
    RETURN (SELECT COUNT(*)
    FROM v_oct_exams
    WHERE patient_id=p_id)+(SELECT COUNT(*)
    FROM v_visual_field_exams
    WHERE patient_id=p_id)+(SELECT COUNT(*)
    FROM v_pachymetry_exams
    WHERE patient_id=p_id)+(SELECT COUNT(*)
    FROM v_gonioscopy_exams
    WHERE patient_id=p_id) $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_special_exam_count(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
11
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.

<a id="ejercicio-5-50"></a>

### 50.

Crear una función que genere un resumen textual como:

```
Paciente: Carlos Gómez
Consultas: 8
Controles glaucoma: 4
Última PIO OD: 18
Última PIO OI: 17
Tratamientos activos: 2
```

a partir del ID del paciente.

**Respuesta:**

```sql
DELIMITER $$
DROP FUNCTION IF EXISTS fn_patient_summary$$
CREATE FUNCTION fn_patient_summary(p_id BIGINT)
RETURNS TEXT READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(220);
    SELECT CONCAT(first_name,' ',last_name) INTO v_name
    FROM patients
    WHERE id=p_id; RETURN CONCAT('Paciente: ',v_name,' | Consultas: ',fn_patient_visit_count(p_id),' | Controles glaucoma: ',fn_glaucoma_control_count(p_id),' | Última PIO OD: ',COALESCE(fn_last_iop_eye(p_id,'OD'),'N/D'),' | Última PIO OI: ',COALESCE(fn_last_iop_eye(p_id,'OI'),'N/D'),' | Tratamientos activos: ',(SELECT COUNT(*)
    FROM v_treatments
    WHERE patient_id=p_id
        AND active=TRUE));
END $$
DELIMITER ;
```

**Código para obtener la evidencia:**

```sql
SELECT fn_patient_summary(1) AS resultado;
```

Resultado de la ejecución registrada:

```text
result
Paciente: Paciente1 Gómez | Consultas: 6 | Controles glaucoma: 3 | Última PIO OD: 19.00 | Última PIO OI: 22.00 | Tratamientos activos: 0
```

Los valores dependientes de fechas o datos pueden cambiar al volver a ejecutar.
