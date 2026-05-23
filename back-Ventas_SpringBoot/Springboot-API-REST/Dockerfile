# --- ETAPA 1: Construcción (Build) ---
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
# Copiar el archivo de configuración de Maven y el código fuente
COPY pom.xml .
COPY src ./src
# Compilar el proyecto saltándose las pruebas unitarias para acelerar el proceso
RUN mvn clean package -DskipTests

# --- ETAPA 2: Ejecución (Runner) ---
FROM eclipse-temurin:17-jre-alpine AS runner
WORKDIR /app

# Buenas prácticas de seguridad: Crear usuario no-root (Mínimo privilegio)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copiar solo el archivo .jar compilado desde la etapa de construcción
COPY --from=build /app/target/*.jar app.jar

# Cambiar al usuario seguro
USER appuser

# Exponer el puerto del microservicio (comúnmente 8080)
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]