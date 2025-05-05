#!/bin/bash

# ┌────────────────────────────────────────────────────────┐
# │ Ultra Robust Ubuntu VM Setup Script for GCP Cloud Shell│
# │ Author: GrandSiLes                                      │
# │ License: MIT                                            │
# │ Features:                                               │
# │ - Ubuntu ISO boot + auto VM via QEMU                    │
# │ - Pinggy tunnel (VNC) + Optional browser installs       │
# └────────────────────────────────────────────────────────┘

set -e

# Colors
BOLD="\033[1m"; GREEN="\033[1;32m"; RED="\033[1;31m"; YELLOW="\033[1;33m"; BLUE="\033[1;34m"; NC="\033[0m"

echo -e "\n${BLUE}${BOLD}🌐 Ultra Robust Ubuntu VM Setup for Google Cloud Shell${NC}"
echo -e "${YELLOW}📌 Author: GrandSiLes${NC}"

# Constants
PINGGY_URL="https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/cli/v0.1.7/linux/amd64/pinggy"
DEFAULT_ISO="https://mirror.limda.net/ubuntu-releases/24.04.2/ubuntu-24.04.2-desktop-amd64.iso"
VNC_PORT=5900
VM_PASSWORD="P@ssw0rd!"

# ========= Dependency Check =========
echo -e "\n${BLUE}[1/10] Checking dependencies...${NC}"
sudo apt update -y && sudo apt install -y qemu-system-x86 wget curl sshpass bc > /dev/null
echo -e "${GREEN}✔ Dependencies installed.${NC}"

# ========= Disk Space Check =========
echo -e "${BLUE}[2/10] Checking available disk space...${NC}"
REQUIRED_GB=5
AVAILABLE_GB=$(df -BG ~ | awk 'NR==2 {print $4}' | sed 's/G//')
if (( AVAILABLE_GB < REQUIRED_GB )); then
    echo -e "${RED}❌ Not enough storage. ${AVAILABLE_GB}GB available, need ${REQUIRED_GB}GB.${NC}"
    exit 1
else
    echo -e "${GREEN}✔ Sufficient storage: ${AVAILABLE_GB}GB available.${NC}"
fi

# ========= User Input =========
echo -e "\n${BLUE}[3/10] Configure Ubuntu ISO & VM Resources${NC}"
read -p "📥 Enter ISO URL [default=$DEFAULT_ISO]: " ISO_URL
ISO_URL=${ISO_URL:-$DEFAULT_ISO}

read -p "💾 RAM (GB) [default=2]: " RAM
RAM=${RAM:-2}

read -p "🧠 CPU Cores [default=2]: " CORES
CORES=${CORES:-2}

read -p "📀 Disk Size (GB) [default=20]: " DISK
DISK=${DISK:-20}

read -p "🌐 Install Chrome? [y/n]: " INSTALL_CHROME
read -p "🌐 Install Firefox? [y/n]: " INSTALL_FIREFOX

ISO_FILE=$(basename "$ISO_URL")

# ========= Download ISO =========
echo -e "\n${BLUE}[4/10] Downloading Ubuntu ISO...${NC}"
if [ ! -f "$ISO_FILE" ]; then
    wget --show-progress "$ISO_URL" -O "$ISO_FILE"
else
    echo -e "${YELLOW}⚠ ISO already downloaded.${NC}"
fi

# ========= Create Virtual Disk =========
echo -e "\n${BLUE}[5/10] Creating virtual disk...${NC}"
qemu-img create -f qcow2 ubuntu-vm.qcow2 ${DISK}G > /dev/null
echo -e "${GREEN}✔ Virtual disk created.${NC}"

# ========= Start VM =========
echo -e "\n${BLUE}[6/10] Booting VM in background...${NC}"
nohup qemu-system-x86_64 \
    -m ${RAM}G \
    -smp ${CORES} \
    -hda ubuntu-vm.qcow2 \
    -cdrom "$ISO_FILE" \
    -boot d \
    -vga virtio \
    -display none \
    -nographic \
    -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::${VNC_PORT}-:5900 \
    -device virtio-net,netdev=n1 > vm.log 2>&1 &

echo -e "${GREEN}✔ VM started in background.${NC}"

# ========= Pinggy Setup =========
echo -e "\n${BLUE}[7/10] Setting up Pinggy Tunnel (for VNC)...${NC}"
if [ ! -f "pinggy" ]; then
    wget -O pinggy "$PINGGY_URL" && chmod +x pinggy
fi

echo -e "\nVisit ${YELLOW}https://pinggy.io${NC}, sign in, and get your access token."
read -p "🔑 Enter Pinggy Access Token: " TOKEN

if [[ -z "$TOKEN" ]]; then
    echo -e "${RED}❌ No token provided. Skipping tunnel setup.${NC}"
else
    nohup ./pinggy -p 443 -R0:localhost:${VNC_PORT} \
        -o StrictHostKeyChecking=no \
        -o ServerAliveInterval=30 \
        "${TOKEN}+tcp@free.pinggy.io" > pinggy.log 2>&1 &
    echo -e "${GREEN}✔ Tunnel started. VNC running at your Pinggy URL.${NC}"
fi

# ========= Software Reminder =========
echo -e "\n${BLUE}[8/10] Optional Software Notes...${NC}"
if [[ "$INSTALL_CHROME" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🟡 Chrome installation should be done manually inside the VM after boot.${NC}"
fi
if [[ "$INSTALL_FIREFOX" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🟡 Firefox installation should be done manually inside the VM after boot.${NC}"
fi

# ========= Done =========
echo -e "\n${GREEN}[✔] All done! Your Ubuntu VM is booting...${NC}"
echo -e "🔐 VNC Password: ${YELLOW}${VM_PASSWORD}${NC}"
echo -e "🖥️  Use any VNC Viewer to connect to the Pinggy URL (port 443)"
echo -e "💡 VM runs in background, use this script again to reconnect."
