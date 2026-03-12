# ==============================================================================
#  DomoNode — Makefile
#  Compilador : XC8 v2.40 (xc8-cc)
#  Target     : PIC16F1939
#  Docs       : LuaLaTeX (latexmk)
# ==============================================================================

# ------------------------------------------------------------------------------
#  Toolchain — XC8
# ------------------------------------------------------------------------------
XC8_BIN := /opt/microchip/xc8/v2.40/bin
CC      := $(XC8_BIN)/xc8-cc
CHIP    := 16F1939

# ------------------------------------------------------------------------------
#  Programador — PK2CMD (ICSP)
# ------------------------------------------------------------------------------
PK2       := sudo pk2cmd
PK2_CHIP  := PIC$(CHIP)
PK2_FLAGS := -p$(PK2_CHIP)

# ------------------------------------------------------------------------------
#  Firmware
# ------------------------------------------------------------------------------
FW_SRC    := firmware/src/main.c
FW_BUILD  := firmware/build
FW_TARGET := $(FW_BUILD)/main.hex
CC_FLAGS  := -mcpu=$(CHIP) -std=c90 -O2 -mccreport

# ------------------------------------------------------------------------------
#  Documentación — LaTeX
# ------------------------------------------------------------------------------
LATEXMK      := latexmk
L_BUILD      := research/build
L_FLAGS      := -lualatex -outdir=$(L_BUILD) -interaction=nonstopmode -halt-on-error

TEX_SOURCES  := $(shell find research -maxdepth 1 -name "*.tex")
TEX_TARGETS  := $(basename $(notdir $(TEX_SOURCES)))

# ------------------------------------------------------------------------------
#  Regla principal
# ------------------------------------------------------------------------------
.DEFAULT_GOAL := all

all: firmware

# ==============================================================================
#  FIRMWARE
# ==============================================================================

firmware: $(FW_BUILD) $(FW_TARGET)
	@if [ -n "$$(find $(FW_TARGET) -mmin -0.01 2>/dev/null)" ]; then \
		echo "------------------------------------------------"; \
		echo "✅ FIRMWARE [$(CHIP)]: Compilación exitosa.";      \
		echo "📦 Binario listo en: $(FW_TARGET)";                \
		echo "------------------------------------------------"; \
	else \
		echo "------------------------------------------------"; \
		echo "☕ FIRMWARE [$(CHIP)]: $(FW_TARGET) ya está al día."; \
		echo "------------------------------------------------"; \
	fi

$(FW_BUILD):
	@mkdir -p $@

$(FW_TARGET): $(FW_SRC)
	@echo "🛠️  Compilando firmware desde $<..."
	@$(CC) $(CC_FLAGS) $< -o $@

# ==============================================================================
#  ICSP — Programación en circuito
# ==============================================================================

# Verifica la conexión con el microcontrolador
check:
	@echo "🔍 Detectando $(PK2_CHIP)..."
	@RESULT=$$($(PK2) $(PK2_FLAGS) -I 2>&1); \
	DEVID=$$(echo "$$RESULT" | grep "Device ID" | awk '{print $$NF}'); \
	if [ "$$DEVID" = "0000" ]; then \
		echo "❌ Bus ICSP sin respuesta. Revisa MCLR, PGD y PGC."; \
		exit 1;                                                     \
	else \
		echo "✅ $(PK2_CHIP) detectado. Device ID: $$DEVID";        \
	fi

# Graba el firmware en el PIC
flash: $(FW_TARGET)
	@echo "⚡ Programando $(PK2_CHIP) con $(FW_TARGET)..."
	@$(PK2) $(PK2_FLAGS) -M -F$(FW_TARGET) -R
	@echo "✅ Programación completada. Ejecutando firmware..."

# Borra la memoria del PIC
erase:
	@echo "🧼 Borrando memoria de $(PK2_CHIP)..."
	@$(PK2) $(PK2_FLAGS) -E
	@echo "✅ Memoria borrada."

# ==============================================================================
#  DOCUMENTACIÓN — LaTeX
# ==============================================================================

docs: docs_info

docs_info:
	@echo "📝 Sistema de Documentación DomoNode (research/)"
	@echo "   Archivos detectados : $(TEX_TARGETS)"
	@echo "   Uso                 : make <nombre>  (ej: make investigacion)"
	@echo "------------------------------------------------"

# Regla genérica: compila cualquier .tex detectado en research/
$(TEX_TARGETS): %:
	$(eval SOURCE_PATH := $(shell find research -name "$*.tex" -print -quit))
	@mkdir -p $(L_BUILD)
	@echo "📄 Generando: $(SOURCE_PATH) → $(L_BUILD)/$@.pdf"
	@$(LATEXMK) $(L_FLAGS) -f -jobname=$@ $(SOURCE_PATH)
	@echo "✅ DOCS: $(L_BUILD)/$@.pdf generado."

# ==============================================================================
#  LIMPIEZA
# ==============================================================================

# Elimina artefactos de compilación del firmware
clean-firmware:
	@echo "🧹 Limpiando firmware..."
	@rm -rf $(FW_BUILD) ccreport
	@echo "   Firmware limpio."

# Elimina artefactos de compilación de LaTeX
clean-research:
	@echo "🧹 Limpiando LaTeX..."
	@rm -rf $(L_BUILD)
	@echo "   Research limpio."

# Elimina temporales de LaTeX preservando los PDFs
distclean:
	@echo "🧹 Limpiando temporales LaTeX en $(L_BUILD)..."
	@$(LATEXMK) -c -outdir=$(L_BUILD)
	@find $(L_BUILD) -type f ! -name "*.pdf" -delete 2>/dev/null || true
	@echo "   Temporales eliminados. PDFs conservados."

# Purga completa del proyecto (requiere intención explícita)
clean-all: clean-firmware clean-research
	@echo "✨ Proyecto DomoNode purgado por completo."

# ------------------------------------------------------------------------------
.PHONY: all firmware check flash erase \
        docs docs_info $(TEX_TARGETS)   \
        clean-firmware clean-research distclean clean-all