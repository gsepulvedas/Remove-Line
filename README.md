# Copyright (C) 2026 Gabriel Jhoan Sepúlveda Santibáñez
# Este programa se distribuye bajo la GNU Affero General Public License v3.0.
# Debe mantenerse este aviso de autoría en cualquier redistribución o modificación.

# Remove-Line
Edición masiva de archivos vía editor de flujos y aprovechando las características de PWSH 5.1.

# Remove-Line

## 📖 Descripción
Remove-Line es un módulo que permite **eliminar o reemplazar texto específico en archivos y directorios**.  
Soporta operaciones en cualquier parte del archivo y ofrece opciones de búsqueda recursiva en subcarpetas.

---

## ⚙️ Parámetros

- **First**  
  Elimina desde el inicio de un archivo.

- **Rename**  
  Renombra en cualquier lugar del archivo.

- **Ruta**  
  Directorio donde se buscarán los archivos.

- **Patron**  
  El carácter o símbolo a modificar.

- **Recurse**  
  Busca en todas las subcarpetas.

- **File**  
  Aplica solo a archivos.

- **Directory**  
  Aplica solo a directorios.

---

## 💻 Ejemplos de uso

### 1. Eliminar un patrón simple
```powershell
Remove-Line -Patron "2025"
Elimina la cadena "2025" de todos los archivos y directorios en el directorio actual.

2. Eliminar desde el inicio en subcarpetas
powershell
Remove-Line -First -Patron "_" -Recurse -Path $HOME\Documentos
Elimina patrones que comiencen con _ en archivos y carpetas dentro de la ruta especificada.

3. Eliminar caracteres especiales
powershell
Remove-Line -First -Patron '`n' -Recurse -Path $HOME\Documentos
Elimina el carácter especial \n en archivos y carpetas.
Se recomienda usar comillas simples ' ' para estos casos.

4. Renombrar patrones en archivos
powershell
Remove-Line -Patron " -- " -Ruta $HOME\Documentos -Recurse -File -Rename "-"
Renombra el patrón " -- " en archivos, reemplazándolo por "-".

5. Renombrar solo archivos con extensión específica
powershell
Remove-Line -Patron " -- " -Ruta $HOME\Documentos -Recurse -Filter *.jpg
Renombra el patrón " -- " únicamente en archivos con extensión .jpg.

6. Renombrar patrones en directorios
powershell
Remove-Line -Patron "dir-1" -Ruta $HOME\Documentos -Recurse -Directory
Renombra el patrón "dir-1" en nombres de directorios.

👤 Autor
© 2026 Gabriel Jhoan Sepúlveda Santibáñez