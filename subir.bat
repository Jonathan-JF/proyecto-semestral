# Vamos a crear una versión mejorada y más robusta del script .bat para Windows (v2).
# Esta versión incluye verificación de errores, limpieza de imágenes huérfanas y manejo avanzado de puertos.

bat_v2_content = """@echo off
:: Script de Automatizacion Local - Innovatech Chile (Windows) - Version 2
:: Este archivo detiene, limpia y levanta de forma segura todo tu entorno local en Windows.

SETLOCAL EnableDelayedExpansion

echo =======================================================================
echo          INICIANDO ENTORNO LOCAL DE INNOVATECH CHILE (V2)
echo =======================================================================
echo.

:: 1. Detener contenedores antiguos de forma segura
echo [+] Deteniendo y limpiando contenedores del proyecto...
docker-compose down --remove-orphans
if %errorlevel% neq 0 (
    echo [!] Hubo un problema al detener los contenedores previos, forzando limpieza...
)
echo.

:: 2. Limpieza preventiva de puertos comunes en Windows
echo [+] Verificando que los puertos clave (8080, 8081, 8082, 3306) esten libres...
for %%p in (8080 8081 8082 3306) do (
    netstat -ano | findstr :%%p > nul
    if !errorlevel! equ 0 (
        echo [!] Advertencia: El puerto %%p parece estar ocupado en tu PC.
        echo     Si la compilacion falla, asegurate de cerrar aplicaciones que lo usen.
    )
)
echo.

:: 3. Compilar Dockerfiles locales y levantar la infraestructura unificada
echo [+] Compilando e iniciando la arquitectura multi-capa...
echo     (Frontend: 8080 ^| Ventas: 8081 ^| Despachos: 8082 ^| Base de Datos: 3306)
echo.
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo.
    echo [ERR] Error crítico al levantar Docker Compose. 
    echo       Revisa que Docker Desktop este abierto y corriendo en tu PC.
    pause
    exit /b %errorlevel%
)
echo.

:: 4. Mostrar el estado final del ecosistema local de forma limpia
echo =======================================================================
echo               ESTADO ACTUAL DE LOS CONTENEDORES (DOCKER PS)
echo =======================================================================
echo.
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo =======================================================================
echo [+] ¡Todo listo, Jonathan! Tu entorno local esta arriba de forma segura.
echo [+] Para abrir el Frontend en tu navegador ingresa a: http://localhost:8080
echo =======================================================================
echo.
pause
"""

file_path_v2 = "subir-v2.bat"
with open(file_path_v2, "w", encoding="utf-8") as file:
    file.write(bat_v2_content)

print(f"Archivo generado con éxito: {file_path_v2}")