# Codex Delegation Rule

**Codex CLI is your highly capable supporter.**

## Context Management (CRITICAL)

**コンテキスト消費を意識してCodexを使う。** 大きな出力が予想される場合はサブエージェント経由を推奨。

| 状況 | 推奨方法 |
|------|----------|
| 短い質問・短い回答 | 直接呼び出しOK |
| **実装作業（デフォルト）** | **サブエージェント経由** |
| 詳細な設計相談 | サブエージェント経由 |
| デバッグ分析 | サブエージェント経由 |
| リファクタリング | サブエージェント経由 |
| 複数の質問がある | サブエージェント経由 |

```
┌──────────────────────────────────────────────────────────┐
│  Main Claude Code                                        │
│  → 短い質問なら直接呼び出しOK                             │
│  → 大きな出力が予想されるならサブエージェント経由          │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Subagent (general-purpose)                         │ │
│  │  → Calls Codex CLI                                  │ │
│  │  → Processes full response                          │ │
│  │  → Returns key insights only                        │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

## About Codex

Codex CLI is an AI with exceptional reasoning and task completion abilities.
Think of it as a trusted senior expert you can always consult.

**When facing difficult decisions → Delegate to subagent → Subagent consults Codex.**

## Role Division

| Agent | Primary Role | Responsibilities |
|-------|--------------|------------------|
| **Claude Code** | Orchestration & User Interface | Task management, user communication, planning, final review |
| **Codex CLI** | Implementation & Reasoning | Code writing, design decisions, debugging, refactoring |

**Default principle: Claude orchestrates, Codex implements.**

## When to Delegate to Codex

ALWAYS delegate to Codex for:

1. **Implementation work** - Writing new functions, classes, modules (default)
2. **Design decisions** - How to structure code, which pattern to use
3. **Debugging** - If cause isn't obvious or first fix failed
4. **Refactoring** - Code restructuring, optimization, cleanup
5. **Trade-off evaluation** - Choosing between options

**Default rule: If it involves writing non-trivial code, delegate to Codex.**

### Trigger Phrases (User Input)

Consult Codex when user says:

| Japanese | English |
|----------|---------|
| 「どう設計すべき？」「どう実装する？」 | "How should I design/implement?" |
| 「なぜ動かない？」「原因は？」「エラーが出る」 | "Why doesn't this work?" "Error" |
| 「どちらがいい？」「比較して」「トレードオフは？」 | "Which is better?" "Compare" |
| 「〜を作りたい」「〜を実装して」 | "Build X" "Implement X" |
| 「考えて」「分析して」「深く考えて」 | "Think" "Analyze" "Think deeper" |

## Implementation Delegation Pattern

**Codex implements, Claude orchestrates.**

### When User Requests Implementation

1. **Claude Code**: Understand requirements, ask clarifying questions
2. **Claude Code**: Create plan (if complex) or task list
3. **Claude Code via Subagent**: Delegate implementation to Codex
4. **Claude Code**: Review output, run tests, report to user

### Subagent Implementation Pattern

```
Task tool parameters:
- subagent_type: "general-purpose"
- run_in_background: true (for parallel work)
- prompt: |
    Implement: {feature description}

    Requirements:
    - {requirement 1}
    - {requirement 2}

    Call Codex CLI with workspace-write:
    codex exec --model gpt-5.3-codex --sandbox workspace-write --full-auto "
    Implement {feature} in {file_path}.

    Requirements:
    {detailed requirements in English}

    Follow project conventions:
    - Use type hints
    - Write docstrings
    - Follow existing patterns in codebase
    " 2>/dev/null

    Return:
    - Files modified
    - Key changes made
    - Any issues encountered
```

### What Claude Does vs Codex Does

**Claude Code (Orchestrator):**
- ✓ Talk to user in Japanese
- ✓ Understand requirements
- ✓ Create tasks/plans
- ✓ Run tests after implementation
- ✓ Run linters (ruff, ty)
- ✓ Git operations
- ✓ Final review and reporting

**Codex (Implementer):**
- ✓ Write code
- ✓ Design architecture
- ✓ Debug issues
- ✓ Refactor code
- ✓ Add tests

### Example Flow

```
User: "ユーザー認証機能を追加して"

Claude: 要件確認 → タスクリスト作成
Claude: Subagent経由でCodexに実装依頼
Codex: auth.py実装 + tests追加
Claude: テスト実行 → lint実行 → ユーザーに報告

User: "動作確認OK、コミットして"

Claude: git commit実行
```

## When NOT to Delegate

Claude Code handles directly (no Codex needed):

- **Simple file edits** - Typo fixes, single-line changes
- **File operations** - Reading, searching, globbing files
- **Standard operations** - git commit, running tests, linting
- **User communication** - All Japanese responses to user
- **Task management** - Creating/updating task lists
- **Trivial code** - Adding a print statement, simple config changes

**If you can do it in < 5 minutes without thinking, do it directly.**

## Quick Check

Ask yourself: "Am I about to make a non-trivial decision?"

- YES → Consult Codex first
- NO → Proceed with execution

## How to Consult (via Subagent)

**IMPORTANT: Use subagent to preserve main context.**

### Recommended: Subagent Pattern

Use Task tool with `subagent_type: "general-purpose"`:

```
Task tool parameters:
- subagent_type: "general-purpose"
- run_in_background: true (for parallel work)
- prompt: |
    {Task description}

    Call Codex CLI:
    codex exec --model gpt-5.3-codex --sandbox read-only --full-auto "
    {Question for Codex}
    " 2>/dev/null

    Return CONCISE summary:
    - Key recommendation
    - Main rationale (2-3 points)
    - Any concerns or risks
```

### Direct Call (Only When Necessary)

Only use direct Bash call when:
- Quick, simple question (< 1 paragraph response expected)
- Subagent overhead not justified

```bash
# Only for simple queries
codex exec --model gpt-5.3-codex --sandbox read-only --full-auto "Brief question" 2>/dev/null
```

### Sandbox Modes

| Mode | Sandbox | Use Case |
|------|---------|----------|
| Analysis | `read-only` | Design review, debugging analysis, trade-offs |
| Work | `workspace-write` | Implement, fix, refactor (subagent recommended) |

**Language protocol:**
1. Ask Codex in **English**
2. Subagent receives response in **English**
3. Subagent summarizes and returns to main
4. Main reports to user in **Japanese**

## Why Subagent Pattern?

- **Context preservation**: Main orchestrator stays lightweight
- **Full analysis**: Subagent can process entire Codex response
- **Concise handoff**: Main only receives actionable summary
- **Parallel work**: Background subagents enable concurrent tasks

**Don't hesitate to delegate. Subagents + Codex = efficient collaboration.**
