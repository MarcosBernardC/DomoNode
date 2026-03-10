# --- Configuración de XC8 v2.40 ---
XC8_BIN   = /opt/microchip/xc8/v2.40/bin
CC        = $(XC8_BIN)/xc8-cc
CHIP      = 16F1939

# --- Configuración de LaTeX (Estándar LuaLaTeX) ---
LATEXMK   = latexmk
L_BUILD   = research/build
L_FLAGS   = -lualatex -outdir=$(L_BUILD) -interaction=nonstopmode -halt-on-error

# --- Rutas de Firmware ---
FW_SRC    = firmware/src/main.c
FW_BUILD  = firmware/build
FW_TARGET = $(FW_BUILD)/main.hex

# --- Detección Dinámica de LaTeX en research/ ---
TEX_SOURCES := $(shell find research -maxdepth 1 -name "*.tex")
TEX_TARGETS := $(basename $(notdir $(TEX_SOURCES)))

# --- Regla Principal ---
all: firmware

# --- Sección de Firmware ---
firmware: $(FW_BUILD) $(FW_TARGET)
	@if [ ! -z "$$(find $(FW_TARGET) -mmin -0.01 2>/dev/null)" ]; then \
		echo "------------------------------------------------"; \
		echo "✅ FIRMWARE [$(CHIP)]: Compilación exitosa."; \
		echo "📦 Binario listo en: $(FW_TARGET)"; \
	else \
		echo "------------------------------------------------"; \
		echo "☕ FIRMWARE [$(CHIP)]: El archivo $(FW_TARGET) ya está al día."; \
		echo "------------------------------------------------"; \
	fi

$(FW_BUILD):
	@mkdir -p $(FW_BUILD)

$(FW_TARGET): $(FW_SRC)
	@echo "🛠️  Compilando firmware desde $<..."
	@$(CC) -mcpu=$(CHIP) -std=c90 -O2 -mccreport $< -o $@

# --- Sección de Documentación ---
docs: docs_info

docs_info:
	@echo "📝 Sistema de Documentación DomoNode (research/)"
	@echo "Archivos detectados: $(TEX_TARGETS)"
	@echo "Uso: make [nombre_del_archivo] (ej: make investigacion)"
	@echo "------------------------------------------------"

$(TEX_TARGETS): %:
	@$(eval SOURCE_PATH := $(shell find research -name "$*.tex" -print -quit))
	@mkdir -p $(L_BUILD)
	@echo "📄 Generando: $(SOURCE_PATH) -> $(L_BUILD)/$@.pdf"
	# Añadimos -f para ignorar falta de bibliografía y quitamos el silenciador temporalmente
	@$(LATEXMK) $(L_FLAGS) -f -jobname=$@ $(SOURCE_PATH)
	@echo "✅ DOCS: $(L_BUILD)/$@.pdf generado."

## --- Sección de Limpieza Explícita ---

# Limpia exclusivamente el firmware del PIC12F675
clean-firmware:
	@echo "🧹 Limpiando compilación de Firmware..."
	@rm -rf $(FW_BUILD) ccreport
	@echo "Firmware limpio."

# Limpia exclusivamente la carpeta build de research (LaTeX)
clean-research:
	@echo "🧹 Limpiando compilación de LaTeX..."
	@rm -rf $(L_BUILD)
	@echo "Research limpio."

# Limpia TODO el proyecto (Requiere intención explícita)
clean-all: clean-firmware clean-research
	@echo "✨ Todo el proyecto DomoNode ha sido purgado."

# Limpieza de temporales de LaTeX pero preservando los PDFs resultantes
distclean:
	@echo "🧹 Limpiando temporales en $(L_BUILD)..."
	@$(LATEXMK) -c -outdir=$(L_BUILD)
	@find $(L_BUILD) -type f ! -name '*.pdf' -delete 2>/dev/null || true

# Eliminamos la regla 'clean' a secas para evitar borrados accidentales
.PHONY: all firmware clean-all clean-firmware clean-research distclean docs docs_info $(TEX_TARGETS)