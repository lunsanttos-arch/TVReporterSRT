# TVReporterSRT

Protótipo de aplicativo iPhone para contribuição de vídeo ao vivo via SRT,
pensado para ligação direta com vMix.

## Ambiente principal

O projeto está preparado para desenvolvimento no **Windows**.

Você edita pelo VS Code, envia o código para o GitHub e o GitHub Actions
compila usando um runner macOS/Xcode.

Leia primeiro:

**`WINDOWS.md`**

## Configuração SRT padrão

- SRT Caller
- Host: `192.168.20.53`
- Porta: `6767`
- Latência: `200 ms`

No vMix use SRT Listener na porta `6767`.

## Estrutura

- `TVReporterSRT/` — código Swift/SwiftUI
- `project.yml` — projeto XcodeGen
- `.github/workflows/ios-build.yml` — build automático sem assinatura
- `.github/workflows/ios-archive.yml` — archive assinado para iPhone
- `scripts/setup-windows.ps1` — ajuda para inicializar o Git no Windows

## Primeiro objetivo

Conseguir um build verde no workflow `iOS Build Check`.

Depois disso:

1. validar câmera e áudio;
2. validar SRT;
3. reduzir latência;
4. adicionar reconexão;
5. adicionar estatísticas de rede;
6. preparar TestFlight.
