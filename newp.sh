#!/bin/bash
# newp.sh - Self-Evolving "Memory & Skills" Factory

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

echo "Scaffolding Self-Evolving Factory at $TARGET_DIR..."
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
   2. [Step 2]
3. If we just completed a task, automatically fill in the steps based on what worked.
4. Confirm to the user: "New skill '[name]' has been added to your library."
S_EOF

# 3. Add Starter Skills
cat << 'S_EOF' > .claude/rules/skills/git-flow.md
# Skill: Git Workflow
- Use concise, imperative commit messages.
- Run `git status` before committing to verify changes.
S_EOF

# 4. Populate the Routing CLAUDE.md
cat << 'C_EOF' > CLAUDE.md
# CLAUDE.md for $PROJECT_NAME

## Routing
- **Memory:** \`.claude/rules/memory-*.md\`
- **Skills:** \`.claude/rules/skills/*.md\`

## Instructions
- **Auto-Update:** Update memory files AS YOU GO.
- **New Skills:** When I say "addskill [name]", follow the \`meta-add-skill.md\` protocol to create a new runbook.

## Build & Run
- Build: \`docker compose build\`
- Up: \`docker compose up -d\`
C_EOF

# 5. Create .claudeignore
echo "node_modules/
dist/
build/
.git/
*.log" > .claudeignore

# 6. Initialize Git
git init && git add . && git commit -m "Initial self-evolving scaffold"

echo "✅ Project $PROJECT_NAME is ready."
echo "👉 Try saying 'addskill deploy' inside Claude Code."
EOF

sudo mv /tmp/newp_logic $TARGET
sudo chmod +x $TARGET
echo "🚀 'newp' upgraded. Your AI can now learn new skills on command."
