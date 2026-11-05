# Gerenciador de Localizações

Aplicativo desenvolvido em Flutter para Android como parte da Atividade 1 da disciplina de Programação para Dispositivos Móveis II (Fatec).

O aplicativo realiza a coleta contínua de localizações via GPS (Streams), armazena os dados em um banco de dados local SQLite e permite consultar os registros em forma de lista (histórico) e em um mapa interativo.

---

## 🚀 Funcionalidades

- **Coleta em Tempo Real:** Início e término da coleta contínua por meio de `Stream` com alta precisão.
- **Gerenciamento de Permissões:** Verificação do status do GPS e acesso às configurações de permissão do dispositivo.
- **Persistência Local (SQLite):** Gravação automática de latitude, longitude, precisão e horário UTC no banco `localizacoes.db`.
- **Histórico de Registros:** Exibição das últimas 100 posições formatadas com data/hora local e opção de limpeza total do histórico.
- **Mapa Interativo:** Exibição dos pontos coletados com destaque em vermelho para a localização mais recente.

---

## 🛠️ Tecnologias e Pacotes Utilizados

- **Flutter / Dart**
- [geolocator](https://pub.dev/packages/geolocator) (Coleta e verificação de permissões do GPS)
- [sqflite](https://pub.dev/packages/sqflite) (Persistência local no banco SQLite)
- [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) (Visualização do mapa e marcadores)
- [intl](https://pub.dev/packages/intl) (Formatação de data e hora)

---

## 📂 Estrutura do Projeto

```text
lib/
├── main.dart
├── app.dart
├── models/
│   └── localizacao.dart
├── data/
│   ├── banco_localizacoes.dart
│   └── repositorio_localizacoes.dart
├── services/
│   └── servico_localizacao.dart
└── screens/
    ├── tela_coleta.dart
    ├── tela_localizacoes.dart
    └── tela_mapa.dart
```

---

## 📲 Como Rodar e Gerar o APK

### Pré-requisitos
- Flutter SDK instalado.
- Dispositivo Android (ou emulador) com permissão de localização ativada.

### Executando em Modo de Desenvolvimento
1. Clone o repositório.
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute no dispositivo conectado:
   ```bash
   flutter run
   ```

### Gerando o APK para Instalação

Para gerar o instalador Android (Release):
```bash
flutter build apk --release
```

O arquivo `.apk` estará disponível em:
`build/app/outputs/flutter-apk/app-release.apk`