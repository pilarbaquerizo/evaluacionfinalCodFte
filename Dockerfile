# ---------- Etapa de compilación ----------
FROM gradle:8.14-jdk21-alpine AS builder

WORKDIR /workspace

# Copiamos primero los archivos de configuración para aprovechar la caché de Docker.
COPY build.gradle settings.gradle ./
RUN gradle dependencies --no-daemon

COPY src ./src
RUN gradle bootJar --no-daemon

# ---------- Etapa de ejecución ----------
FROM eclipse-temurin:21-jre-alpine

# Ejecutar como usuario no root.
RUN addgroup -S app && adduser -S app -G app

WORKDIR /app

COPY --from=builder /workspace/build/libs/*.jar app.jar

RUN chown -R app:app /app
USER app

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
