import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "permissions"
  static targets = ["input", "button", "preview"]

  toggle() {
    if (this.recorder && this.recorder.state === "recording") {
      this.stop()
    } else {
      this.requestAccess()
    }
  }

  requestAccess() {
    if (this.enabled) {
      // App native : on demande d'abord la permission système Android
      this.send("requestMicrophone", {}, () => this.start())
      this.send("microphoneDenied", {}, () => {
        this.buttonTarget.textContent = "Micro refusé"
      })
    } else {
      // Navigateur classique : le navigateur gère lui-même la demande
      this.start()
    }
  }

  async start() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      this.chunks = []
      this.recorder = new MediaRecorder(stream)

      this.recorder.ondataavailable = (event) => this.chunks.push(event.data)
      this.recorder.onstop = () => {
        stream.getTracks().forEach((track) => track.stop())
        this.attachFile()
      }

      this.recorder.start()
      this.buttonTarget.textContent = "⏹ Arrêter"
    } catch (error) {
      console.error("Recorder error:", error.name, error.message)
      this.buttonTarget.textContent = `Erreur : ${error.name}`
    }
  }

  stop() {
    this.recorder.stop()
    this.buttonTarget.textContent = "🎤 Enregistrer"
  }

  attachFile() {
    const blob = new Blob(this.chunks, { type: this.recorder.mimeType })
    const file = new File([blob], "mot.webm", { type: blob.type })

    const transfer = new DataTransfer()
    transfer.items.add(file)
    this.inputTarget.files = transfer.files

    this.previewTarget.src = URL.createObjectURL(blob)
    this.previewTarget.classList.remove("hidden")
  }

  disconnect() {
    if (this.recorder && this.recorder.state === "recording") this.recorder.stop()
  }
}
