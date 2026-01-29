---
description: Architecture and design review with SOLID verification and simplicity assessment
---

# Design Review Command

Perform comprehensive architecture and design review using the dev-suite agents.

## Your Task

When this command is invoked, execute an architecture review.

### Step 1: Clarify Scope

Ask the user what to review (if not specified):
- Full project (entire codebase)
- Module/directory (specific path)
- Single file (specific file)

### Step 2: Architecture Analysis

Launch the **system-architect** agent using the Task tool to analyze the architecture.

**Prompt for Task tool**:
```
Analyze the architecture of: [scope]

Provide comprehensive analysis:
1. Architecture structure (layers, modules, separation of concerns)
2. Abstractions (interfaces/traits quality, appropriate levels)
3. Patterns (design patterns used, whether appropriate)
4. Issues identified (architectural smells, coupling issues)
5. Recommendations (prioritized improvements, refactoring suggestions)
```

### Step 3: SOLID Verification

Launch the **code-reviewer** agent using the Task tool to verify SOLID principles.

**Can run in parallel with Step 2** by making both Task tool calls in a single message.

**Prompt for Task tool**:
```
Review [scope] for SOLID principles compliance:

1. Single Responsibility Principle - one reason to change per class?
2. Open/Closed Principle - open for extension, closed for modification?
3. Liskov Substitution Principle - subtypes substitutable?
4. Interface Segregation Principle - focused interfaces?
5. Dependency Inversion Principle - depend on abstractions?

Also check:
- Premature abstractions
- Over-engineering
- Unnecessary complexity

Report ONLY high-confidence issues (≥80) with:
- Confidence score
- Location (file:line)
- Impact explanation
- Specific fix recommendation
```

### Step 4: Consolidate & Report

Synthesize findings from both agents into a comprehensive report:

```
# Design Review Report

## Scope: [what was reviewed]

## Executive Summary
- Overall Quality: [Excellent/Good/Fair/Needs Improvement]
- Critical Issues: [count]
- High Priority: [count]

## Architecture Assessment
✓ [Strengths]
⚠ [Issues with details]

## SOLID Compliance
- SRP: [X%] - [assessment]
- OCP: [Y%] - [assessment]
- LSP: [Z%] - [assessment]
- ISP: [A%] - [assessment]
- DIP: [B%] - [assessment]

## Simplicity Assessment
- Premature Abstractions: [count]
- Over-Engineering: [examples]

## Issues by Priority

### Critical (Must Address)
1. [Issue] - Confidence: XX
   Location: [file:line]
   Fix: [recommendation]

### High (Should Address)
...

## Recommendations
1. [Immediate action]
2. [Refactoring priority]

## Estimated Effort: [X hours]
```

### Step 5: Next Steps

Based on findings, suggest:
- Critical issues: Address immediately
- Medium/Low: Address incrementally
- No issues: Architecture is healthy

## Review Guidelines

- Reviews are read-only analysis
- High-confidence issues only (≥80)
- Concrete, actionable recommendations
- Prioritized by impact
- Considers minimal code philosophy
