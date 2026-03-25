#!/bin/bash
# newp.sh - The Complete "Memory, Skills & Routing" Factory

TARGET="/usr/local/bin/newp"

cat << 'EOF' > /tmp/newp_logic
#!/bin/bash
PROJECT_NAME=$1
PROJECT_ROOT="/srv/projects"
TARGET_DIR="$PROJECT_ROOT/$PROJECT_NAME"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: newp <project-name>"
    exit 1
fi

echo "Scaffolding Complete Memory & Skills Factory at $TARGET_DIR..."
mkdir -p "$TARGET_DIR/.claude/rules/skills"
cd "$TARGET_DIR"

# 1. Create the Memory Files
touch .claude/rules/memory-profile.md
touch .claude/rules/memory-preferences.md
touch .claude/rules/memory-decisions.md
touch .claude/rules/memory-sessions.md

# 2. Add the META-SKILL (The "addskill" logic)
cat << 'S_EOF' > .claude/rules/skills/meta-add-skill.md
# Skill: Create New Skills (addskill)
When the user says "addskill [name]" or "create skill [name]":
1. Create a new file: `.claude/rules/skills/[name].md`.
2. Use this template:
   # Skill: [Name]
   ## Trigger
   [When should this skill be used?]
   ## Steps
   1. [Step 1]
   2. [Step 3]
3. If we just completed a task, automatically fill in the steps based on what worked.
4. Confirm: "New skill '[name]' has been added to your library."
S_EOF

# 3. Populate the Master CLAUDE.md (The Routing File)
cat << 'C_EOF' > CLAUDE.md
# CLAUDE.md for $PROJECT_NAME

## Routing & Rules
- **Profile/Facts:** \`.claude/rules/memory-profile.md\`
- **Preferences:** \`.claude/rules/memory-preferences.md\`
- **Decisions:** \`.claude/rules/memory-decisions.md\`
- **Recent Work:** \`.claude/rules/memory-sessions.md\`
- **Skills/Runbooks:** \`.claude/rules/skills/*.md\`

## Auto-Update Memory (MANDATORY)
**Update memory files AS YOU GO, not at the end.** When you learn something new, update immediately.

| Trigger | Action |
|---------|--------|
| User shares a fact | → Update \`memory-profile.md\` |
| User states a preference | → Update \`memory-preferences.md\` |
| A technical decision is made | → Update \`memory-decisions.md\` |
| A new repeatable process is found | → Use \`addskill\` to update \`skills/\` |
| Completing substantive work | → Add to \`memory-sessions.md\` |

**DO NOT ASK. Just update the files.**

## Build & Run Commands
- Build: \`docker compose build\`
- Up: \`docker compose up -d\`
- Logs: \`docker compose logs -f\`
- Stop: \`docker compose down\`
C_EOF

# 4. Standard .claudeignore
echo "node_modules/
dist/
build/
.git/
*.log" > .claudeignore

# 5. Initialize Git
git init && git add . && git commit -m "Initial memory, skills and routing scaffold"

echo "✅ Project $PROJECT_NAME is ready with full Routing & Rules."
echo "👉 Use 'addskill [name]' to teach Claude new tricks."
EOF

sudo mv /tmp/newp_logic $TARGET
sudo chmod +x $TARGET
echo "🚀 'newp' upgraded with full Routing & Rules."
