# Phase 1 Update: Podman Instead of Docker/Colima

**Date**: 2026-06-12  
**Change**: Updated all documentation and scripts to use Podman instead of Docker Desktop/Colima

## Rationale

Podman is better suited for the agent-lab non-admin user environment:

### Advantages of Podman
- **Daemonless**: No background daemon required (unlike Docker Desktop)
- **Rootless**: Runs without root/admin privileges by default
- **No admin required**: Perfect for non-admin `agent-lab` user
- **Docker-compatible**: Same CLI commands as Docker
- **Better security model**: Container processes run as the user, not root
- **Lightweight**: Lower resource overhead than Docker Desktop

### Why Not Docker Desktop
- Requires admin privileges to install
- Runs a system-level daemon
- Heavier resource usage
- Not ideal for non-admin user isolation

### Why Not Colima
- While Colima is better than Docker Desktop, it still manages a Docker daemon
- Podman's daemonless architecture is cleaner for our use case
- Podman is more actively developed for macOS
- Native rootless support vs Colima's VM-based approach

## Files Updated

### Documentation
1. **docs/setup/tool-installation-notes.md**
   - Replaced Docker/Colima section with Podman section
   - Added Podman initialization and usage instructions
   - Included Docker compatibility alias
   - Updated tool verification commands
   - Updated official documentation links

2. **docs/setup/macos-agent-lab-user.md**
   - Updated optional tools list to reference Podman

3. **docs/setup/bootstrap-agent-lab.md**
   - Updated optional tools checklist
   - Changed Docker/Colima configuration to Podman configuration

4. **PHASE1-QUICKSTART.md**
   - Updated recommended optional tools

### Scripts
1. **scripts/bootstrap/bootstrap-agent-lab.sh**
   - Changed optional tool checks from `docker` and `colima` to `podman`

2. **scripts/macos/check-agent-lab-user.sh**
   - Changed optional tool checks from `docker` and `colima` to `podman`

## Podman Quick Reference

### Installation
```bash
# System-wide (admin)
brew install podman

# User-local (no admin)
# Install Homebrew in user directory first, then:
brew install podman
```

### Initial Setup
```bash
# One-time initialization
podman machine init

# Start the machine
podman machine start

# Verify
podman ps
```

### Daily Usage
```bash
# Start machine (if not running)
podman machine start

# Use like Docker
podman run -d --name myapp myimage
podman ps
podman stop myapp

# Optional: Stop machine when done
podman machine stop
```

### Docker Compatibility
```bash
# Add alias for Docker compatibility
echo 'alias docker=podman' >> ~/.zshrc
source ~/.zshrc

# Now `docker` commands work
docker ps
docker run hello-world
```

## Impact on Agent Lab

This change has **no impact** on the agent lab functionality:
- Podman is drop-in compatible with Docker commands
- All container-based workflows will work identically
- Better alignment with non-admin user security model
- Reduced resource overhead

## Migration Notes

If you've already set up with Docker/Colima:
1. You can keep using it (it will still work)
2. Or migrate to Podman:
   ```bash
   # Stop and remove Colima
   colima stop
   colima delete
   
   # Install Podman
   brew install podman
   podman machine init
   podman machine start
   ```

## Verification

After installing Podman:
```bash
# Check version
podman --version

# Test functionality
podman run --rm hello-world

# Verify machine status
podman machine list
```

The bootstrap script will automatically check for Podman during setup.
