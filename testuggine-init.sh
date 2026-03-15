#!/usr/bin/env bash
# ============================================================================
# testuggine init — From zero to governed in one command
# ============================================================================
#
# "Nessuno dovrebbe pagare un prezzo enterprise per fare bene cose semplici."
#
# This script sets up multi-agent governance on any workspace.
# It's designed to be friendly, inclusive, and safe:
#   - Asks before writing anything
#   - Never overwrites existing files without confirmation
#   - Works on macOS, Linux, and Windows (Git Bash/WSL)
#   - Zero dependencies beyond bash + python3
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/hale-bopp-data/agentic-playbook/main/testuggine-init.sh | bash
#   # or
#   bash testuggine-init.sh
#   # or
#   bash testuggine-init.sh --scan-only    # Just show what's installed, don't write
#
# Created: S149 (2026-03-15) — EasyWay, 149 sessions of multi-agent development
# License: MIT
# ============================================================================

set -euo pipefail

# --- Colors (safe for non-interactive) ---
if [ -t 1 ]; then
    BOLD='\033[1m' GREEN='\033[0;32m' YELLOW='\033[0;33m'
    CYAN='\033[0;36m' RED='\033[0;31m' NC='\033[0m'
else
    BOLD='' GREEN='' YELLOW='' CYAN='' RED='' NC=''
fi

SCAN_ONLY=false
for arg in "$@"; do
    [ "$arg" = "--scan-only" ] && SCAN_ONLY=true
done

# ============================================================================
echo ""
echo -e "${BOLD}  🐢 Testuggine Init${NC}"
echo -e "  ${CYAN}Multi-agent governance — from zero to governed${NC}"
echo ""
echo "  This will:"
echo "  1. Find which AI agents you have installed"
echo "  2. Ask you a few questions about your workspace"
echo "  3. Write instructions so every agent knows your rules"
echo ""
echo "  It will NOT:"
echo "  - Install anything"
echo "  - Delete any files"
echo "  - Overwrite your existing config without asking"
echo ""

if [ "$SCAN_ONLY" = true ]; then
    echo -e "  ${YELLOW}Mode: scan only (no changes)${NC}"
    echo ""
fi

# ============================================================================
# STEP 1: Agent Discovery
# ============================================================================
echo -e "${BOLD}Step 1: Finding your AI agents...${NC}"
echo ""

AGENTS_FOUND=()
AGENTS_PATHS=()
AGENTS_INSTRUCTIONS=()
AGENTS_HAS_INSTRUCTIONS=()

check_agent() {
    local id="$1" name="$2" dir="$3" instructions="$4"
    local expanded_dir expanded_instructions

    expanded_dir=$(eval echo "$dir" 2>/dev/null || echo "$dir")
    expanded_instructions=$(eval echo "$instructions" 2>/dev/null || echo "$instructions")

    if [ -d "$expanded_dir" ]; then
        local has_instr="no"
        if [ -n "$expanded_instructions" ] && [ -f "$expanded_instructions" ]; then
            has_instr="yes"
        fi
        AGENTS_FOUND+=("$id")
        AGENTS_PATHS+=("$expanded_dir")
        AGENTS_INSTRUCTIONS+=("$expanded_instructions")
        AGENTS_HAS_INSTRUCTIONS+=("$has_instr")

        if [ "$has_instr" = "yes" ]; then
            local lines=$(wc -l < "$expanded_instructions" 2>/dev/null || echo "?")
            echo -e "  ${GREEN}✓${NC} ${BOLD}$name${NC} — instructions: yes ($lines lines)"
        else
            echo -e "  ${YELLOW}!${NC} ${BOLD}$name${NC} — instructions: ${RED}missing${NC}"
        fi
    fi
}

# Scan known agent locations
check_agent "claude"  "Claude Code"  "~/.claude"        "CLAUDE.md"
check_agent "codex"   "Codex (OpenAI)" "~/.codex"       "~/.codex/instructions.md"
check_agent "cursor"  "Cursor"       "~/.cursor"        ".cursorrules"
check_agent "copilot" "GitHub Copilot" "~/.copilot"     ".github/copilot-instructions.md"
check_agent "gemini"  "Gemini"       "~/.antigravity"   "~/.antigravity/rules.md"
check_agent "codeium" "Codeium"      "~/.codeium"       ""
check_agent "axet"    "Axet"         "~/.axetplugincache" ""

AGENT_COUNT=${#AGENTS_FOUND[@]}

if [ "$AGENT_COUNT" -eq 0 ]; then
    echo -e "  ${YELLOW}No AI agents found.${NC}"
    echo "  If you have agents installed in non-standard locations,"
    echo "  you can add them manually to agent-sync.yml later."
    exit 0
fi

echo ""
echo -e "  Found ${BOLD}$AGENT_COUNT${NC} agent(s)."
echo ""

if [ "$SCAN_ONLY" = true ]; then
    echo "  (scan only mode — exiting)"
    exit 0
fi

# ============================================================================
# STEP 2: Workspace Interview (Valentino-style: one question at a time)
# ============================================================================
echo -e "${BOLD}Step 2: Tell me about your workspace${NC}"
echo -e "  ${CYAN}(5 quick questions, press Enter for defaults)${NC}"
echo ""

read -p "  1. Project name? [my-project] " PROJECT_NAME
PROJECT_NAME="${PROJECT_NAME:-my-project}"

read -p "  2. How many repos? [1] " REPO_COUNT
REPO_COUNT="${REPO_COUNT:-1}"

read -p "  3. Primary language? (node/python/go/rust/java/mixed) [node] " PRIMARY_LANG
PRIMARY_LANG="${PRIMARY_LANG:-node}"

read -p "  4. Branch strategy? (feat-main/feat-develop-main/trunk) [feat-main] " BRANCH_STRATEGY
BRANCH_STRATEGY="${BRANCH_STRATEGY:-feat-main}"

read -p "  5. Where do you track work? (github/ado/jira/linear/none) [github] " TRACKER
TRACKER="${TRACKER:-github}"

echo ""

# Derive PR target from branch strategy
PR_TARGET="main"
[ "$BRANCH_STRATEGY" = "feat-develop-main" ] && PR_TARGET="develop"

# ============================================================================
# STEP 3: Generate config + instructions
# ============================================================================
echo -e "${BOLD}Step 3: Generating configuration...${NC}"
echo ""

# --- workspace-map.yml ---
WORKSPACE_MAP="workspace-map.yml"
if [ -f "$WORKSPACE_MAP" ]; then
    echo -e "  ${YELLOW}!${NC} workspace-map.yml already exists — skipping"
else
    cat > "$WORKSPACE_MAP" <<YAML
# workspace-map.yml — Generated by testuggine init
# This file helps AI agents orient instantly in your workspace.
version: "1.0"
generated: "$(date -u +%Y-%m-%d)"
method: "interview"

workspace:
  name: "$PROJECT_NAME"
  description: ""
  root: "."

repos:
  $PROJECT_NAME:
    path: .
    stack: $PRIMARY_LANG
    branch_strategy: $BRANCH_STRATEGY
    pr_target: $PR_TARGET
    deploy: false
    description: ""

work_tracking:
  platform: $TRACKER

agents:
$(for i in "${!AGENTS_FOUND[@]}"; do
    echo "  - name: ${AGENTS_FOUND[$i]}"
done)
YAML
    echo -e "  ${GREEN}✓${NC} Created workspace-map.yml"
fi

# --- Instructions for each agent ---
generate_agent_instructions() {
    cat <<INSTR
# ${PROJECT_NAME} — ${1} Instructions

> Auto-generated by testuggine init.
> Edit this file to add project-specific rules.
> The Testuggine governance system will keep it fresh.

## Workspace

- **Project**: ${PROJECT_NAME}
- **Stack**: ${PRIMARY_LANG}
- **Branch strategy**: ${BRANCH_STRATEGY}
- **PR target**: ${PR_TARGET}
- **Work tracking**: ${TRACKER}

## Rules

- Use branch prefix \`${2}/\` for all your branches (e.g., \`${2}/fix-bug\`)
- Never push directly to main${3}
- Never commit secrets, API keys, or credentials

## Getting Started

Read workspace-map.yml in the project root for the full workspace map.
INSTR
}

WRITTEN=0
for i in "${!AGENTS_FOUND[@]}"; do
    agent_id="${AGENTS_FOUND[$i]}"
    instructions="${AGENTS_INSTRUCTIONS[$i]}"
    has_instr="${AGENTS_HAS_INSTRUCTIONS[$i]}"

    [ -z "$instructions" ] && continue

    extra=""
    [ "$BRANCH_STRATEGY" = "feat-develop-main" ] && extra=$'\n- Never push directly to develop'

    if [ "$has_instr" = "yes" ]; then
        echo -e "  ${YELLOW}!${NC} $agent_id: instructions already exist — skipping (use --force to overwrite)"
    else
        # Ensure directory exists
        instr_dir=$(dirname "$instructions")
        mkdir -p "$instr_dir" 2>/dev/null || true

        generate_agent_instructions "$agent_id" "$agent_id" "$extra" > "$instructions"
        echo -e "  ${GREEN}✓${NC} $agent_id: created $instructions"
        WRITTEN=$((WRITTEN + 1))
    fi
done

echo ""

# ============================================================================
# STEP 4: Summary
# ============================================================================
echo -e "${BOLD}Done! 🐢${NC}"
echo ""
echo "  Created:"
[ -f "$WORKSPACE_MAP" ] && echo "    - workspace-map.yml (workspace map for all agents)"
[ "$WRITTEN" -gt 0 ] && echo "    - $WRITTEN agent instruction file(s)"
echo ""
echo "  Next steps:"
echo "    1. Edit workspace-map.yml to add your repos"
echo "    2. Edit agent instructions to add project-specific rules"
echo "    3. Commit these files to your repo"
echo ""
echo "  Want continuous maintenance? See:"
echo "    https://github.com/hale-bopp-data/agentic-playbook/blob/main/recipes/governance-testuggine.md"
echo ""
echo -e "  ${CYAN}\"Nessuno dovrebbe pagare un prezzo enterprise"
echo -e "    per fare bene cose semplici.\"${NC}"
echo ""
