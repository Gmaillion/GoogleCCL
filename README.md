* Full feature documentation
* Usage instructions
* Pinggy access guide
* License section with the full MIT license

It is ready to be hosted directly on GitHub.

---

### ✅ `README.md`

````markdown
# 🔧 Ubuntu VM Setup on Google Cloud Shell

Automated script to create a **persistent Ubuntu virtual machine** with **remote VNC access** via **Pinggy**, fully self-contained inside **Google Cloud Shell**. No Google Cloud APIs required.

> **Credit**: GrandSiLes  
> **Disclaimer**: For educational and personal use only. Use responsibly.

---

## 🚀 Features

- 🧠 Disk & RAM check before install
- 📦 Interactive selection of optional apps (Chrome, Firefox)
- 🖥️ Ubuntu image auto-download prompt
- ⚙️ VM configuration (RAM, Disk) via prompt
- 🔁 Persistent VM using QEMU (survives shell disconnects)
- 🔐 Secure, token-based remote access via Pinggy (VNC on port `5900`)
- 📡 IP address and password displayed at completion
- 💥 Ultra-robust error handling & friendly messages
- 🧰 Runs **100% independently of GCP APIs**

---

## 📋 Prerequisites

- ✅ A valid [Google Cloud Shell](https://shell.cloud.google.com) session
- ✅ A GitHub account (to clone this repo)
- ✅ A [Pinggy](https://pinggy.io) account (for the access token)

---

## 📥 Installation & Usage

### 1. **Launch Google Cloud Shell**
Go to: [https://shell.cloud.google.com](https://shell.cloud.google.com)

### 2. **Clone this repository**
```bash
git clone https://github.com/yourusername/ubuntu-cloudshell-vm.git
cd ubuntu-cloudshell-vm
````

### 3. **Run the setup script**

```bash
chmod +x setup-vm.sh
./setup-vm.sh
```

---

## 🔑 VM Access Details

* **VNC Host**: Shown at end, like: `abc.tcp.pinggy.io:443`
* **VNC Port**: 443 (via Pinggy)
* **VM VNC Password**: `P@ssw0rd!`
* **Connection Method**: Use RealVNC or another client

---

## 🧠 How to Get a Pinggy Access Token

1. Go to [https://pinggy.io](https://pinggy.io)
2. Sign in using GitHub or Google
3. Click **"Get Access Token"** from dashboard
4. Copy the token string like `xNFfCJCcGrJ`
5. When the script asks, paste only the token

   The script will generate the tunnel like:

   ```
   ./pinggy -p 443 -R0:localhost:5900 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 xNFfCJCcGrJ+tcp@free.pinggy.io
   ```

   ✅ This creates a VNC tunnel on port `5900`

---

## 📦 Optional Software

During setup, you'll be prompted to install:

* [ ] Google Chrome (manual install suggested later in VM)
* [ ] Mozilla Firefox

These are selected interactively — just press `y` or `n` when prompted.

---

## 🧹 Low Storage Warning

If disk space is **less than 4GB**, setup will halt with an error:

```bash
❌ NOT ENOUGH SPACE IN STORAGE.
Visit: https://support.google.com/drive/answer/6374270?hl=en
```

You must clean up unused Drive/Cloud Shell files before proceeding.

---

## 🔧 Managing the VM

* **Start VM manually** (after reboot/disconnect):

  ```bash
  ./start-vm.sh
  ```

* **Stop VM**:

  ```bash
  pkill qemu-system-x86_64
  ```

* **View logs**:

  ```bash
  tail -f vm.log
  ```

---

## 🧪 Troubleshooting

| Issue                        | Fix                                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------------------- |
| Disk space error             | Free up space using [Google Drive cleanup](https://support.google.com/drive/answer/6374270?hl=en) |
| Pinggy tunnel not working    | Verify token, ensure port is `5900`, or re-run manually                                           |
| Black screen in VNC          | Ensure Ubuntu installation inside VM is completed via VNC                                         |
| Ubuntu installer not booting | Check image link; ensure it’s a `.iso` or bootable `.img`                                         |

---

## 📄 License (MIT)

```
MIT License

Copyright (c) 2025 GrandSiLes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
THE SOFTWARE.
```

---

## 🙌 Support

Feel free to submit issues or pull requests to improve the script. This project is maintained for the community by **GrandSiLes**.

---

```

---

Let me know if you'd like a `.gitignore`, `LICENSE` file, or the GitHub repository structure generated next!
```
