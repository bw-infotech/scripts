#!/bin/bash
# newp.sh - Project Factory for Tim Berte

# 1. Define the command location
TARGET="/usr/local/bin/newp"

# 2. The logic that will live in the 'newp' command
cat << 'EOF' > /tmp/newp_logic
#!/bin/bash
PROJECT_NAME=$1
PROJECT_ROOT="/srv/projects"
TARGET_DIR="$PROJECT_ROOT/$PROJECT_NAME"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: newp <project-name>"
    exit 1
fi

# Create the project directory
echo "Creating project at $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Create CLAUDE.md (The AI's Operating Manual)
cat << 'C_EOF' > CLAUDE.md
# CLAUDE.md for $PROJECT_NAME

## Build & Run Commands
- Build: \`docker compose build\`
- Up: \`docker compose up -d\`
- Logs: \`docker compose logs -f\`
- Stop: \`docker compose down\`

## Code Style & Preferences
- **Tone:** High-protein logic, low-carb boilerplate.
- **Context:** Keep AI context under 30k-50k tokens.
- **Database:** Prefers PostgreSQL (standard for Berte projects).
- **Architecture:** Clean, modular, and Docker-first.

## No test suite configured yet.
C_EOF

# Create .claudeignore (Token Protection)
cat << 'I_EOF' > .claudeignore
node_modules/
dist/
build/
.git/
*.log
venv/
__pycache__/
.env
I_EOF

# Create a starter docker-compose.yml
cat << 'D_EOF' > docker-compose.yml
services:
  app:
    build: .
    container_name: $PROJECT_NAME
    restart: unless-stopped
    # networks:
    #   - postgres_default
D_EOF

# Initialize Git
git init
git add .
git commit -m "Initial scaffold via newp"

echo "✅ Project $PROJECT_NAME is ready at $TARGET_DIR"
echo "👉 Type 'cd $TARGET_DIR && claude' to begin."
EOF

# 3. Install the command to the system
sudo mv /tmp/newp_logic $TARGET
sudo chmod +x $TARGET

echo "🚀 'newp' command installed. You can now run it from anywhere."
