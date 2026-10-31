#!/usr/bin/env bash

set -euo pipefail

DRV_NAME="rtl8821ce"
DRV_VERSION="v5.5.2_34066.20200325-ask1"
KERNEL="$(uname -r)"

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET="/usr/src/${DRV_NAME}-${DRV_VERSION}"

if [[ "$EUID" -ne 0 ]]; then
    echo "Ошибка: запустите скрипт через sudo."
    exit 1
fi

for CMD in dkms make modinfo; do
    if ! command -v "$CMD" >/dev/null 2>&1; then
        echo "Ошибка: отсутствует программа $CMD."
        exit 1
    fi
done

if [[ ! -d "/lib/modules/$KERNEL/build" ]]; then
    echo "Ошибка: отсутствуют заголовки ядра $KERNEL."
    exit 1
fi

if [[ ! -f "$SOURCE_DIR/dkms.conf" ]] ||
   ! grep -Fxq "PACKAGE_VERSION=\"$DRV_VERSION\"" \
       "$SOURCE_DIR/dkms.conf"; then
    echo "Ошибка: неправильная конфигурация DKMS."
    exit 1
fi

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
    echo "ОСТАНОВКА: исходники этой версии уже находятся в /usr/src."
    exit 1
fi

if dkms status -m "$DRV_NAME" 2>/dev/null |
   grep -q "^${DRV_NAME}/"; then
    echo "ОСТАНОВКА: в DKMS уже зарегистрирован RTL8821CE."
    echo "Необходимо вручную проверить существующую установку."
    exit 1
fi

if modinfo -k "$KERNEL" -n 8821ce >/dev/null 2>&1; then
    echo "ОСТАНОВКА: модуль 8821ce уже установлен."
    echo "Автоматическая замена запрещена."
    exit 1
fi

echo "Драйвер: ${DRV_NAME}/${DRV_VERSION}"
echo "Ядро: $KERNEL"
echo
echo "Будут выполнены копирование исходников,"
echo "регистрация, сборка и установка через DKMS."
echo "Автоустановка для будущих ядер отключена."
echo

read -r -p "Для продолжения введите INSTALL-ASK1: " ANSWER

if [[ "$ANSWER" != "INSTALL-ASK1" ]]; then
    echo "Установка отменена."
    exit 1
fi

cp -a -- "$SOURCE_DIR" "$TARGET"

dkms add -m "$DRV_NAME" -v "$DRV_VERSION"
dkms build -m "$DRV_NAME" -v "$DRV_VERSION" -k "$KERNEL"
dkms install -m "$DRV_NAME" -v "$DRV_VERSION" -k "$KERNEL"

echo
echo "Драйвер ask1 установлен для ядра $KERNEL."
echo "Для загрузки нового модуля может потребоваться перезагрузка."
