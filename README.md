# Security Lab

Educational cybersecurity toolkit for authorized penetration testing and red team operations.

## Project Structure

### PostExploitation/

Tools and scripts that execute on compromised systems during post-exploitation phases.

- **DataExfiltration/** - Secure data exfiltration using HTTPS + AES encryption
- **SearchScript/** - File enumeration and search capabilities

### Infrastructure/

Command and Control (C2) infrastructure components.

- **ExfiltrationServer/** - Server-side components for receiving and processing exfiltrated data

## Architecture

```
┌─────────────────────┐         HTTPS + AES         ┌─────────────────────┐
│  Compromised Host   │ ───────────────────────────> │   EC2/C2 Server     │
│                     │                               │                     │
│ PostExploitation/   │                               │ Infrastructure/     │
│ - File Search       │                               │ - Data Receiver     │
│ - Data Exfil Client │                               │ - Decryption        │
└─────────────────────┘                               └─────────────────────┘
```

## Usage

⚠️ **LEGAL NOTICE**: These tools are for authorized security testing and educational purposes only. Ensure you have explicit permission before testing on any system.

### Post-Exploitation Tools

See individual README files in each subdirectory:

- [DataExfiltration](./PostExploitation/DataExfiltration/README.md)
- [SearchScript](./PostExploitation/SearchScript/README.MD)

### Infrastructure Setup

See [ExfiltrationServer](./Infrastructure/ExfiltrationServer/README.md) for C2 setup instructions.

## MITRE ATT&CK Mapping

- **T1083** - File and Directory Discovery (SearchScript)
- **T1041** - Exfiltration Over C2 Channel (DataExfiltration)
- **T1071** - Application Layer Protocol - HTTPS
- **T1573** - Encrypted Channel (AES encryption layer)

## Development Environment

- **Language**: C#, PowerShell
- **Target Platform**: Windows
- **Infrastructure**: AWS EC2 (or similar cloud hosting)

## License

For educational and authorized testing purposes only.
