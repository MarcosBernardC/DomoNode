# --- Configuración de XC8 v2.40 ---
XC8_BIN = /opt/microchip/xc8/v2.40/bin
CC = $(XC8_BIN)/xc8-cc
CHIP = 12F675

# --- Rutas de Firmware ---
FW_SRC = firmware/src/main.c
FW_BUILD = firmware/build
# Cambiamos DomoNode.hex por main.hex para que sea consistente
FW_TARGET = $(FW_BUILD)/main.hex

# --- Flags XC8 ---
XC8_FLAGS = -mcpu=$(CHIP) -std=c90 -O2 -mccreport

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
	fi

$(FW_BUILD):
	@mkdir -p $(FW_BUILD)

$(FW_TARGET): $(FW_SRC)
	@echo "🛠️  Compilando firmware desde $<..."
	@$(CC) $(XC8_FLAGS) $< -o $@

# --- Sección de Limpieza ---
clean:
	@echo "🧹 Limpiando archivos de DomoNode..."
	@rm -rf $(FW_BUILD) ccreport
	@echo "OK."

.PHONY: all firmware clean