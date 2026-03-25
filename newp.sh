# 1. Create the new installer script
cat << 'EOF' > /tmp/install_newp.sh
#!/bin/bash
TARGET="/usr/local/bin/newp"

cat << 'INNER_EOF' > /tmp/newp_logic
#!/bin/bash
PROJECT_NAME=$1
PROJECT_ROOT="/srv/projects"
TARGET_DIR="$PROJECT_ROOT/$PROJECT_NAME"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: newp <project-name>"
    exit 1
fi

echo "Scaffolding Advanced Memory Structure at $TARGET_DIR..."
mkdir -p "$TARGET_DIR/.claude/rules"
cd "$TARGET_DIR"

# 1. Create the Memory Files
touch .claude/rules/memory-profile.md
touch .claude/rules/memory-preferences.md
touch .claude/rules/memory-decisions.md
touch .claude/rules/memory-sessions.md

# 2. Populate the Routing CLAUDE.md
cat << 'C_EOF' > CLAUDE.md
# CLAUDE.md for $PROJECT_NAME

## Routing & Rules
- **Profile/Facts:** See \`.claude/rules/memory-profile.md\`
- **Preferences:** See \`.claude/rules/memory-preferences.md\`
- **Past Decisions:** See \`.claude/rules/memory-decisions.md\`
- **Recent Work:** See \`.claude/rules/memory-sessions.md\`

## Auto-Update Memory (MANDATORY)
**Update memory files AS YOU GO, not at the end.** When you learn something new, update immediately.

| Trigger | Action |
|---------|--------|
| User shares a personal fact | → Update \`memory-profile.md\` |
| User states a preference | → Update \`memory-preferences.md\` |
| A technical decision is made | → Update \`memory-decisions.md\` |
| Completing substantive work | → Add to \`memory-sessions.md\` |

**DO NOT ASK. Just update the files when you learn.**

## Build & Run
- Build: \`docker compose build\`
- Up: \`docker compose up -d\`
- Logs: \`docker compose logs -f\`
C_EOF

# 3. Create .claudeignore
echo "node_modules/
dist/
build/
.git/
*.log" > .claudeignore

# 4. Initialize Git if not already there
if [ ! -d ".git" ]; then
    git init && git add . && git commit -m "Initial memory-layer scaffold"
fi

echo "✅ Advanced project $PROJECT_NAME initialized."
INNER_EOF

sudo mv /tmp/newp_logic $TARGET
sudo chmod +x $TARGET
echo "🚀 'newp' has been upgraded to the Memory Layer version."
EOF

# 2. Run the installer (strip Windows characters just in case)
tr -d '\r' < /tmp/install_newp.sh | bash
