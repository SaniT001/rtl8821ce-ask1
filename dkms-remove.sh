#!/usr/bin/env bash

set -euo pipefail

DRV_NAME="rtl8821ce"
DRV_VERSION="v5.5.2_34066.20200325-ask1"

if [[ "$EUID" -ne 0 ]]; then
    echo "Ошибка: запустите скрипт с правами администратора."
    exit 1
fi

if ! command -v dkms >/dev/null 2>&1; then
    echo "Ошибка: DKMS не установлен."
    exit 1
fi

echo "Удаление драйвера: ${DRV_NAME}/${DRV_VERSION}"
echo
echo "ВНИМАНИЕ:"
echo "Редакция ask1 будет удалена из DKMS для всех ядер."
echo "Если это единственный работающий Wi-Fi драйвер,"
echo "после перезагрузки беспроводная сеть может не работать."
echo
echo "Исходники в /usr/src не будут удалены."
echo

read -r -p "Для подтверждения введите REMOVE-ASK1: " ANSWER

if [[ "$ANSWER" != "REMOVE-ASK1" ]]; then
    echo "Операция отменена."
    exit 1
fi

if ! dkms status -m "$DRV_NAME" -v "$DRV_VERSION" 2>/dev/null \
    | grep -q "^${DRV_NAME}/${DRV_VERSION}"; then
    echo "Редакция ask1 не зарегистрирована в DKMS."
    exit 1
fi

dkms remove -m "$DRV_NAME" -v "$DRV_VERSION" --all

echo
echo "Редакция ask1 удалена из DKMS."
echo "Исходники сохранены."
