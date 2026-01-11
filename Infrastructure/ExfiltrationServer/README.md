# Exfiltration Server (C2 Infrastructure)

## Overview

Server-side component for receiving, decrypting, and storing exfiltrated data from compromised systems. Designed to run on AWS EC2 or similar cloud infrastructure.

## Architecture

This server acts as the receiving endpoint for data exfiltrated using the SecureDataExfiltration client tool.

### Components

- **HTTPS Listener** - Receives encrypted data over HTTPS
- **AES Decryption** - Decrypts data using shared AES key
- **Data Storage** - Stores received data securely
- **Logging** - Tracks incoming connections and data transfers

## Features

- ✅ TLS/SSL encryption (HTTPS)
- ✅ AES-256 encryption layer
- ✅ Request validation and authentication
- ✅ Structured logging
- ✅ Data chunking support for large files
- ✅ Error handling and recovery

## Setup Instructions

### Prerequisites

- AWS Account with EC2 access
- SSL/TLS certificate (Let's Encrypt recommended)
- .NET runtime or Python (depending on implementation)
- Firewall configured to allow HTTPS (port 443)

### EC2 Configuration

1. **Launch EC2 Instance**
   - Recommended: Ubuntu Server 22.04 LTS
   - Instance type: t3.small or larger
   - Security Group: Allow inbound HTTPS (443)

2. **Install Dependencies**

   ```bash
   # For .NET implementation
   sudo apt update
   sudo apt install -y dotnet-runtime-8.0
   
   # For Python implementation
   sudo apt install -y python3 python3-pip
   pip3 install flask cryptography
   ```

3. **SSL Certificate Setup**

   ```bash
   sudo apt install -y certbot
   sudo certbot certonly --standalone -d your-domain.com
   ```

### Configuration

Create `config.json`:

```json
{
  "server": {
    "host": "0.0.0.0",
    "port": 443,
    "ssl_cert": "/etc/letsencrypt/live/your-domain.com/fullchain.pem",
    "ssl_key": "/etc/letsencrypt/live/your-domain.com/privkey.pem"
  },
  "encryption": {
    "aes_key": "your-32-byte-key-here",
    "aes_iv": "your-16-byte-iv-here"
  },
  "storage": {
    "data_directory": "/var/exfil-data/",
    "max_file_size": "100MB"
  },
  "logging": {
    "level": "INFO",
    "file": "/var/log/exfil-server.log"
  }
}
```

### Running the Server

```bash
# For .NET
sudo dotnet DataReceiver.dll

# For Python
sudo python3 data_receiver.py

# Run as systemd service (recommended)
sudo systemctl start exfil-server
sudo systemctl enable exfil-server
```

## API Endpoints

### POST /receive

Receives encrypted data from clients.

**Headers:**

- `Content-Type: application/octet-stream`
- `X-Session-ID: <unique-session-id>`

**Body:** AES-encrypted binary data

**Response:**

```json
{
  "status": "success",
  "received_bytes": 1024,
  "session_id": "abc123"
}
```

## Security Considerations

### Key Management

- Store AES keys securely (AWS Secrets Manager, HashiCorp Vault)
- Rotate keys regularly
- Never commit keys to version control

### Network Security

- Use AWS Security Groups to restrict access
- Consider VPN or IP whitelisting
- Enable CloudWatch monitoring
- Set up CloudTrail for audit logs

### Data Security

- Encrypt data at rest on server
- Implement secure deletion after processing
- Set up automated backups
- Use AWS KMS for additional encryption layer

## Monitoring

### CloudWatch Metrics

- Incoming request count
- Data transfer volume
- Error rates
- CPU/Memory utilization

### Alerts

- Unusual traffic patterns
- Failed decryption attempts
- Disk space warnings

## Lab Environment

⚠️ **This is C2 infrastructure** - Keep separate from target systems and ensure proper operational security.

### Best Practices

- Use dedicated AWS account for red team infrastructure
- Tag all resources appropriately
- Implement proper logging and monitoring
- Document all operations
- Tear down when not in use to minimize costs

## Cost Optimization

- Use EC2 spot instances for non-critical testing
- Stop instances when not in use
- Monitor data transfer costs
- Use S3 for long-term storage instead of EBS

## Defense Evasion

Organizations can detect this infrastructure:

- Unusual outbound HTTPS connections to unknown domains
- Domain reputation checks
- Certificate transparency logs
- Traffic pattern analysis

## TODO

- [ ] Implement server code (C# or Python)
- [ ] Add authentication mechanism
- [ ] Create systemd service file
- [ ] Add database integration for metadata
- [ ] Implement web dashboard for monitoring
- [ ] Add support for multiple concurrent sessions

## References

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Let's Encrypt](https://letsencrypt.org/)
- [AES Encryption Best Practices](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)
