# Desenvolvendo o TVReporterSRT no Windows

Você pode editar todo o código no Windows. A compilação de iOS continua precisando de macOS/Xcode,
mas o GitHub Actions executa essa etapa em um Mac remoto para você.

## O fluxo

Windows + VS Code
→ Git
→ GitHub
→ GitHub Actions em macOS
→ Xcode compila
→ log/artefato disponível no GitHub

## 1. Instalar no Windows

Instale:

- Git for Windows
- VS Code
- Uma conta no GitHub

Depois abra a pasta do projeto no VS Code.

Opcionalmente execute no PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup-windows.ps1
```

## 2. Criar um repositório no GitHub

Crie um repositório chamado:

`TVReporterSRT`

Não precisa adicionar README ou .gitignore no GitHub porque o projeto já possui esses arquivos.

Na pasta do projeto:

```powershell
git init
git add .
git commit -m "Primeira versão TVReporterSRT"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/TVReporterSRT.git
git push -u origin main
```

## 3. Compilação automática

Ao fazer push, o workflow:

`.github/workflows/ios-build.yml`

é executado automaticamente.

No GitHub:

`Actions → iOS Build Check`

Ele:

1. abre um runner macOS;
2. instala o XcodeGen;
3. gera o `.xcodeproj`;
4. baixa as dependências Swift;
5. compila para o simulador;
6. salva o log.

Esse build NÃO precisa de conta Apple paga porque não instala em um iPhone físico.

## 4. Testar no iPhone

Para gerar um build assinado para dispositivo físico, é necessário configurar assinatura Apple.

O workflow:

`.github/workflows/ios-archive.yml`

já está preparado para isso, mas requer secrets no GitHub.

Secrets esperados:

- `APPLE_TEAM_ID`
- `APPLE_CERTIFICATE_P12_BASE64`
- `APPLE_CERTIFICATE_PASSWORD`
- `APPLE_PROVISIONING_PROFILE_BASE64`
- `APPLE_CODE_SIGN_IDENTITY`
- `KEYCHAIN_PASSWORD`

A assinatura de apps iOS para distribuição/TestFlight normalmente exige Apple Developer Program.

## 5. O que fazer primeiro

Não configure assinatura ainda.

Primeiro:

1. suba o projeto para o GitHub;
2. rode `iOS Build Check`;
3. abra o log;
4. se houver erro de Swift/HaishinKit, copie o erro e mande para o ChatGPT.

Assim corrigimos a aplicação até o build ficar verde antes de mexer em certificado e TestFlight.

## 6. Configuração SRT do protótipo

Destino padrão:

- IP: `192.168.20.53`
- Porta: `6767`
- Modo: Caller
- Latência inicial: 200 ms

No vMix:

- Add Input
- Stream/SRT
- SRT Listener
- porta `6767`

Quando o iPhone estiver fora da rede local, ele precisa ter rota/VPN para alcançar `192.168.20.53`.

## Importante

O Windows não consegue executar Xcode nem gerar localmente um app iOS de produção.
Neste projeto, o GitHub Actions funciona como o "Mac de compilação".
