# Guía de Navegación y Edición Fluida en Neovim

Esta guía reúne los atajos nativos de Vim y los comandos personalizados de la configuración activa en `~/.config/nvim` (basada en `lazy.nvim`, `koda.nvim`, Telescope, LSP, Obsidian, DAP y Sidekick). Está organizada desde las acciones más frecuentes hasta flujos avanzados de refactorización, notas e inteligencia artificial.

> **Convención de teclas**:
> - `<Space>` (Barra espaciadora) es la tecla `<leader>`.
> - `<C-x>` significa presionar `Ctrl + x`.
> - `<S-x>` significa presionar `Shift + x`.
> - `<A-x>` significa presionar `Alt + x`.

---

## Ruta Rápida (Flujo esencial diario)

1. **Abrir un archivo por nombre**: presionar `<Space>ff`, escribir parte del nombre y presionar `Enter`.
2. **Buscar texto en todo el proyecto**: presionar `<Space>fw`, escribir el término buscado y navegar resultados con `<C-j>` / `<C-k>`.
3. **Saltar a la definición de una función o clase**: colocar el cursor sobre el símbolo y presionar `gd` (volver atrás con `<C-o>`).
4. **Modificar una palabra o texto entre comillas**: usar `ciw` (cambiar palabra) o `ci"` (cambiar dentro de comillas).
5. **Enviar código a Claude Code, Codex o Pi**: seleccionar líneas con `V` y presionar `<Space>av`, o abrir el agente con `<Space>ac` / `<Space>ax` / `<Space>ai`.

---

## 1. Modos y Supervivencia Básica

Neovim es un editor modal. La mayor parte del tiempo se permanece en **Modo Normal** (navegación y órdenes) y solo se entra en **Modo Insertar** para escribir texto nuevo.

| Atajo / Comando | Modo | Acción |
|-----------------|------|--------|
| `i` / `a` | Normal | Entrar a modo insertar antes (`i`) o después (`a`) del cursor |
| `I` / `A` | Normal | Insertar al inicio (`I`) o al final (`A`) de la línea actual |
| `o` / `O` | Normal | Crear una línea nueva abajo (`o`) o arriba (`O`) y entrar a insertar |
| `Esc` o `<C-[>` | Cualquiera | Volver al modo normal |
| `v` / `V` / `<C-v>` | Normal | Modo visual por caracteres (`v`), líneas completas (`V`) o bloques en columna (`<C-v>`) |
| `:w` | Normal | Guardar el archivo actual |
| `:q` / `:wq` | Normal | Cerrar ventana (`:q`) o guardar y cerrar (`:wq`) |
| `:qa!` | Normal | Salir de todo sin guardar cambios |
| `u` / `<C-r>` | Normal | Deshacer (`u`) y rehacer (`Ctrl + r`) |
| `.` | Normal | Repetir el último cambio realizado (comando clave de productividad) |
| `Esc` | Terminal | Salir del modo insertar dentro de una terminal integrada |

---

## 2. Movimiento Fluido Dentro de un Archivo

Evitar las flechas del teclado mantiene las manos en la fila central y permite combinar movimientos con operadores de edición.

### Desplazamiento Básico y por Palabras

| Atajo | Acción |
|-------|--------|
| `h` `j` `k` `l` | Izquierda (`h`), abajo (`j`), arriba (`k`), derecha (`l`) |
| `w` / `b` | Saltar al inicio de la siguiente palabra (`w`) o palabra anterior (`b`) |
| `e` | Saltar al final de la palabra actual o siguiente |
| `W` / `B` / `E` | Igual que `w`/`b`/`e`, pero separando solo por espacios en blanco |
| `0` / `^` | Ir al inicio absoluto de la línea (`0`) o al primer carácter no vacío (`^`) |
| `$` | Ir al final de la línea |

### Saltos Precisos en la Línea y en Pantalla

| Atajo | Acción |
|-------|--------|
| `f{carácter}` / `F{carácter}` | Saltar hacia adelante (`f`) o atrás (`F`) hasta el carácter indicado en la misma línea |
| `t{carácter}` / `T{carácter}` | Saltar justo antes del carácter indicado hacia adelante (`t`) o atrás (`T`) |
| `;` / `,` | Repetir el último salto `f`/`t` hacia adelante (`;`) o en sentido inverso (`,`) |
| `%` | Saltar entre paréntesis `()`, llaves `{}` o corchetes `[]` correspondientes |
| `{` / `}` | Saltar al párrafo o bloque de código anterior (`{`) o siguiente (`}`) |
| `<C-d>` / `<C-u>` | Bajar (`<C-d>`) o subir (`<C-u>`) media pantalla manteniendo el cursor centrado |
| `gg` / `G` | Ir a la primera línea del archivo (`gg`) o a la última (`G`) |
| `{número}G` o `:{número}` | Saltar directamente al número de línea indicado (ej. `42G`) |
| `{número}j` / `{número}k` | Saltar `N` líneas hacia abajo o arriba usando los números relativos laterales |
| `zz` | Centrar verticalmente en pantalla la línea donde está el cursor |
| `<C-o>` / `<C-i>` | Navegar hacia atrás (`<C-o>`) o adelante (`<C-i>`) en el historial de saltos |

### Marcas (Marks)

| Atajo | Acción |
|-------|--------|
| `m{a-z}` | Guardar una marca local en la posición actual (ej. `ma`) |
| `'{a-z}` o `` `{a-z} `` | Saltar a la línea (`'a`) o posición exacta (`` `a ``) de la marca |
| `m]` / `m[` | Ir a la siguiente (`m]`) o anterior (`m[`) marca en el buffer (`marks.nvim`) |
| `dm{a-z}` | Eliminar la marca indicada |

---

## 3. Seleccionar, Modificar y Manipular Texto

La gramática de Vim funciona como **`Verbo (Operador) + Sustantivo (Movimiento u Objeto de Texto)`**:
- **Verbos**: `d` (borrar/cortar), `c` (cambiar: borra y entra a insertar), `y` (copiar/yank), `v` (seleccionar), `>` (indentar a la derecha), `<` (indentar a la izquierda), `=` (autoformatear indentación).
- **Modificadores de Objeto**: `i` (*inner*: dentro de, sin incluir delimitadores) y `a` (*around*: alrededor de, incluyendo delimitadores).
- **Objetos**: `w` (palabra), `"` (comillas dobles), `'` (comillas simples), `` ` `` (backticks), `(` o `b` (paréntesis), `{` o `B` (llaves), `[` (corchetes), `t` (etiqueta HTML/JSX), `p` (párrafo).

### Combinaciones Esenciales de Edición

| Comando | Significado Literal | Resultado |
|---------|---------------------|-----------|
| `ciw` | *Change inner word* | Borra la palabra bajo el cursor (sin importar en qué letra esté) y entra a modo insertar |
| `diw` / `yiw` | *Delete / Yank inner word* | Borra (`diw`) o copia (`yiw`) la palabra bajo el cursor |
| `ci"` / `di"` | *Change / Delete inner `"`* | Cambia o borra todo el contenido dentro de `"..."` |
| `ca"` | *Change around `"`* | Cambia el contenido incluyendo las comillas `"..."` |
| `ci(` / `ci{` / `ci[` | *Change inner `()` `{}` `[]`* | Cambia los argumentos de una función `(...)` o el cuerpo de un bloque `{...}` |
| `cit` / `dit` | *Change / Delete inner tag* | Cambia o borra el contenido dentro de una etiqueta HTML/JSX `<tag>...</tag>` |
| `dd` / `yy` / `cc` | Operar sobre la línea entera | Corta (`dd`), copia (`yy`) o reemplaza (`cc`) toda la línea actual |
| `D` / `C` | Operar hasta el final de línea | Borra (`D`) o cambia (`C`) desde el cursor hasta el final de la línea |
| `p` / `P` | Pegar (*Put*) | Pega después (`p`) o antes (`P`) del cursor (sincronizado con el portapapeles del sistema) |
| `x` / `r{carácter}` | Edición de un carácter | Borra el carácter bajo el cursor (`x`) o lo reemplaza por otro (`r`) |
| `J` | Unir líneas (*Join*) | Une la línea inferior con la línea actual |
| `~` | Alternar mayúscula/minúscula | Cambia la capitalización del carácter o selección actual |

### Mover Líneas y Bloques en Vivo

| Atajo | Modo | Acción |
|-------|------|--------|
| `J` / `K` | Visual (`v` / `V`) | Mueve el bloque seleccionado hacia abajo (`J`) o arriba (`K`) reindentando automáticamente |
| `<A-h>` `<A-j>` `<A-k>` `<A-l>` | Normal y Visual | Mueve la línea o selección en cualquier dirección (`mini.move`) |
| `>` / `<` | Visual (`v` / `V`) | Indenta o desindenta el bloque seleccionado |

### Rodear Texto con Paréntesis, Comillas o Tags (`nvim-surround`)

| Comando | Ejemplo | Acción |
|---------|---------|--------|
| `ys{movimiento}{carácter}` | `ysiw"` | Rodea la palabra actual con comillas dobles (`hola` -> `"hola"`) |
| `yss{carácter}` | `yss)` | Rodea toda la línea actual con paréntesis |
| `S{carácter}` (en modo Visual) | `viwS}` | Rodea la selección actual con llaves `{...}` |
| `cs{viejo}{nuevo}` | `cs"'` | Cambia comillas dobles por comillas simples (`"hola"` -> `'hola'`) |
| `ds{carácter}` | `ds"` | Elimina las comillas o paréntesis que rodean al cursor (`"hola"` -> `hola`) |

---

## 4. Buscar y Reemplazar (Local y Global)

### Búsqueda y Reemplazo Dentro del Archivo Actual

| Comando | Acción |
|---------|--------|
| `/{texto}` + `Enter` | Buscar `{texto}` hacia adelante en el archivo |
| `?{texto}` + `Enter` | Buscar `{texto}` hacia atrás en el archivo |
| `n` / `N` | Ir a la siguiente (`n`) o anterior (`N`) coincidencia de búsqueda |
| `*` / `#` | Buscar inmediatamente la palabra exacta bajo el cursor hacia adelante (`*`) o atrás (`#`) |
| `:noh` | Limpiar el resaltado de la última búsqueda |
| `:%s/viejo/nuevo/g` | Reemplazar todas las apariciones de `viejo` por `nuevo` en todo el archivo |
| `:%s/viejo/nuevo/gc` | Igual que el anterior, pero pidiendo confirmación (`y`/`n`/`a`/`q`) en cada cambio |
| `:'<,'>s/viejo/nuevo/g` | Reemplazar solo dentro de las líneas seleccionadas en Modo Visual |

### Búsqueda Entre Archivos del Proyecto (Telescope)

| Atajo | Acción |
|-------|--------|
| `<Space>ff` | Buscar archivos por nombre en el directorio actual (`find_files`) |
| `<Space>fw` | Buscar texto exacto o regex dentro de todos los archivos del proyecto (`live_grep`) |
| `<Space>fc` | Buscar la palabra bajo el cursor en todo el proyecto (`grep_string`) |
| `<Space>fs` | Buscar funciones, clases y variables dentro del archivo actual (`lsp_document_symbols`) |

**Dentro de la ventana de Telescope**:
- `<C-j>` / `<C-k>`: Moverse al resultado siguiente o anterior.
- `Enter`: Abrir el archivo seleccionado.
- `<C-q>`: Enviar los resultados filtrados a la lista *Quickfix* y abrirla.

---

## 5. Árbol de Archivos, Pestañas (Buffers) y Ventanas (Splits)

### Explorador de Archivos (`nvim-tree`)

| Atajo | Contexto | Acción |
|-------|----------|--------|
| `<C-n>` | Global | Abrir o cerrar el árbol lateral de archivos |
| `<Space>e` | Global | Enfocar el cursor en el árbol de archivos |
| `Enter` o `o` | Dentro de `nvim-tree` | Abrir archivo o expandir carpeta |
| `a` | Dentro de `nvim-tree` | Crear archivo o carpeta nueva (terminar con `/` para carpeta) |
| `r` | Dentro de `nvim-tree` | Renombrar archivo o carpeta |
| `d` | Dentro de `nvim-tree` | Eliminar archivo o carpeta |
| `x` / `c` / `p` | Dentro de `nvim-tree` | Cortar (`x`), copiar (`c`) y pegar (`p`) archivos |
| `y` / `Y` / `gy` | Dentro de `nvim-tree` | Copiar nombre (`y`), ruta relativa (`Y`) o ruta absoluta (`gy`) |
| `H` | Dentro de `nvim-tree` | Mostrar u ocultar archivos ocultos (dotfiles) |

### Pestañas Superiores y Buffers (`bufferline`)

| Atajo | Acción |
|-------|--------|
| `<Tab>` | Ir al siguiente buffer abierto |
| `<S-Tab>` | Ir al buffer anterior |
| `<Space>h` / `<Space>l` | Mover la pestaña actual hacia la izquierda (`<Space>h`) o derecha (`<Space>l`) |
| `<Space>x` | Cerrar el buffer actual |
| `<Space>n` | Abrir una nueva pestaña vacía |

### División de Ventanas (Splits) y Navegación (compatible con Tmux)

| Atajo | Acción |
|-------|--------|
| `<Space>sv` | Dividir ventana verticalmente |
| `<Space>sh` | Dividir ventana horizontalmente |
| `<Space>se` | Igualar el tamaño de todas las ventanas divididas |
| `<Space>sx` | Cerrar la división de ventana actual |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Mover el foco entre ventanas de Neovim y paneles de Tmux (`vim-tmux-navigator`) |
| `<C-Up>` / `<C-Down>` | Aumentar o reducir el alto de la ventana actual |
| `<C-Left>` / `<C-Right>` | Reducir o aumentar el ancho de la ventana actual |

---

## 6. Inteligencia de Código (LSP y Autocompletado)

Los servidores configurados (`pyright`, `clangd`, `ts_ls`, `html`, `cssls`, `lua_ls`, `marksman`) activan estos atajos automáticamente al abrir un archivo compatible.

### Navegación y Refactorización LSP

| Atajo | Acción |
|-------|--------|
| `K` | Mostrar documentación y firma de tipos en ventana flotante (*Hover*) |
| `gd` | Ir a la definición del símbolo bajo el cursor |
| `gD` | Ir a la declaración del símbolo (útil en headers C/C++) |
| `gR` o `<Space>cu` | Ver todas las referencias donde se usa el símbolo en Telescope |
| `gi` o `<Space>ch` | Ver implementaciones de una interfaz o método virtual en Telescope |
| `gt` | Ir a la definición del tipo de dato |
| `<Space>ci` / `<Space>co` | Ver llamadas entrantes (`ci`) o salientes (`co`) de la función actual |
| `<Space>rn` | Renombrar variable, función o clase en todo el proyecto (*Rename*) |
| `<Space>ca` | Abrir menú de acciones de código y correcciones rápidas (*Code Actions*) |
| `[d` / `]d` | Saltar al error o advertencia anterior (`[d`) o siguiente (`]d`) |
| `<Space>d` | Ver el detalle del error en la línea actual en ventana flotante |
| `<Space>D` | Listar todos los diagnósticos y errores del archivo en Telescope |
| `<Space>rs` | Reiniciar el servidor LSP (`:LspRestart`) |

### Menú de Autocompletado (`nvim-cmp` + `LuaSnip`)

| Atajo (Modo Insertar) | Acción |
|-----------------------|--------|
| `<C-Space>` | Forzar apertura del menú de autocompletado |
| `<C-j>` / `<C-k>` | Bajar (`<C-j>`) o subir (`<C-k>`) en la lista de sugerencias |
| `Enter` | Confirmar e insertar la sugerencia seleccionada |
| `<C-b>` / `<C-f>` | Desplazar hacia arriba o abajo la documentación flotante del ítem |
| `<C-e>` | Cancelar y cerrar el menú de autocompletado |

---

## 7. Agentes de IA en Terminal (`sidekick.nvim`)

Integración directa con **Claude Code**, **Codex** y **Pi** sin salir de Neovim, con recarga automática de archivos modificados en disco.

| Atajo | Modo | Acción |
|-------|------|--------|
| `<Space>ac` | Normal | Abrir o alternar el panel de **Claude Code** |
| `<Space>ax` | Normal | Abrir o alternar el panel de **Codex** |
| `<Space>ai` | Normal | Abrir o alternar el panel de **Pi** |
| `<Space>as` | Normal | Seleccionar agente interactivamente desde una lista |
| `<Space>aa` | Normal | Mostrar u ocultar el último panel de agente activo |
| `<C-.>` | Normal, Insertar, Visual, Terminal | Alternar foco rápidamente entre el editor y el panel del agente |
| `<Space>af` | Normal | Enviar el archivo actual (`{file}`) como contexto al agente |
| `<Space>av` | Visual (`v` / `V`) | Enviar el bloque de código seleccionado (`{selection}`) al agente |
| `<Space>at` | Normal y Visual | Enviar la posición o nodo actual (`{this}`) al agente |
| `<Space>ap` | Normal y Visual | Elegir un prompt predefinido (`explain`, `fix`, `review`, `diagnostics`, `tests`, `optimize`) |
| `<Space>ad` | Normal | Cerrar o desconectar la sesión CLI activa |

---

## 8. Obsidian y Notas en Markdown

Configurado con soporte automático para el vault en `~/Desktop/Ubicalo_Doc` y cualquier carpeta que contenga `.obsidian`.

| Atajo | Acción |
|-------|--------|
| `<Space>os` | Buscar texto dentro de todas las notas del vault (`ObsidianSearch`) |
| `<Space>oq` | Cambiar rápidamente entre notas por nombre (`ObsidianQuickSwitch`) |
| `<Space>od` | Abrir o crear la nota diaria de hoy (`ObsidianToday`) |
| `<Space>ob` | Ver qué notas enlazan a la nota actual (`ObsidianBacklinks`) |
| `<Space>ol` | Listar todos los enlaces dentro de la nota actual (`ObsidianLinks`) |
| `<Space>ot` | Insertar una plantilla de Obsidian (`ObsidianTemplate`) |
| `<Space>oT` | Ver tabla de contenidos de la nota actual (`ObsidianTOC`) |
| `<Space>oo` | Abrir la nota actual en la aplicación de escritorio de Obsidian (`ObsidianOpen`) |
| `<Space>oc` | Marcar o desmarcar una casilla de tarea `- [ ]` (`Toggle checkbox`) |
| `gf` / `Enter` | Seguir el enlace `[[wiki]]` o `[markdown](...)` bajo el cursor |
| `<Space>om` | Activar o desactivar el renderizado visual de Markdown (`RenderMarkdown toggle`) |

---

## 9. Herramientas C/C++ y Debugging (DAP)

### Comandos de Automatización para C/C++

Al guardar cualquier archivo `.h`, `.hpp`, `.c` o `.cpp`, el formateador de `#include` ordena y agrupa las cabeceras automáticamente. Además están disponibles estos comandos:

| Comando | Acción |
|---------|--------|
| `:Skel` | En un `.h`/`.hpp` vacío genera `#pragma once`; en un `.c`/`.cpp` vacío inserta el `#include` de su cabecera par |
| `:CppTrvCtr` | Con el cursor dentro de una clase o struct C++, genera automáticamente un constructor que inicializa todos sus miembros |
| `:CppExtractDefinitions` | En un `.h`/`.hpp`, extrae todas las funciones miembro inline de la clase actual hacia su archivo `.cpp` correspondiente |
| `:CppExtractFunctionDefinition` | Extrae únicamente la función bajo el cursor desde el header hacia el archivo `.cpp` |

### Depuración Interactiva (`nvim-dap` para Python y C/C++)

| Atajo | Acción |
|-------|--------|
| `<Space>db` | Poner o quitar un *Breakpoint* en la línea actual |
| `<Space>dc` | Iniciar depuración o continuar ejecución (*Continue*) |
| `<Space>ds` | Pasar por encima de la línea actual (*Step Over*) |
| `<Space>di` | Entrar dentro de la función llamada (*Step Into*) |
| `<Space>do` | Salir de la función actual (*Step Out*) |
| `<Space>du` | Abrir o cerrar la interfaz gráfica del debugger (*DAP UI*) |
| `<Space>dw` | Agregar la expresión o selección actual al panel *Watches* |
| `<Space>dW` | Eliminar una expresión del panel *Watches* |
| `<Space>dC` | Limpiar todas las expresiones de *Watches* |
| `<Space>dr` / `<Space>dt` | Reiniciar (`dr`) o terminar (`dt`) la sesión de depuración |

---

## 10. Apariencia, Temas y Plegado de Código

| Atajo / Comando | Acción |
|-----------------|--------|
| `<Space>ts` o `:Theme` | Abrir selector de temas (por defecto `koda` con fondo `#000000` y texto `#ffffff`) |
| `<Space>tn` / `<Space>tp` | Cambiar al tema siguiente (`tn`) o anterior (`tp`) |
| `:Lazy` | Abrir el gestor de plugins `lazy.nvim` (actualizar con `U`, limpiar con `X`) |
| `:Mason` | Abrir el gestor de servidores LSP, linters y adaptadores DAP |
| `za` | Alternar abrir o cerrar un pliegue de código (*Fold*) |
| `zR` / `zM` | Abrir todos (`zR`) o cerrar todos (`zM`) los pliegues del archivo |

---

## Lista de Verificación de Dominio Progresivo

- [ ] **Nivel 1 (Supervivencia)**: Navegar con `h j k l`, saltar con `w b <C-d> <C-u>`, guardar con `:w` y cambiar de pestaña con `<Tab>` / `<S-Tab>`.
- [ ] **Nivel 2 (Velocidad de Edición)**: Usar `ciw`, `ci"`, `ci(`, repetir cambios con `.`, mover bloques con `V` + `J`/`K` y rodear texto con `ysiw"`.
- [ ] **Nivel 3 (Navegación de Proyecto)**: Abrir archivos sin usar el árbol mediante `<Space>ff`, buscar texto global con `<Space>fw` y saltar a definiciones con `gd` / `<C-o>`.
- [ ] **Nivel 4 (Flujo con IA y Notas)**: Enviar selecciones a Claude/Codex/Pi con `<Space>av`, alternar foco con `<C-.>` y gestionar notas en Obsidian con `<Space>os` / `<Space>od`.
