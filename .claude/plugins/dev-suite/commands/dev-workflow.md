---
description: Complete feature development workflow with planning, architecture, TDD implementation, testing, and review
---

# Development Workflow Command

Execute a complete feature development lifecycle by orchestrating the dev-suite agents.

## Your Task

When this command is invoked, guide the user through these phases:

### Phase 1: Clarify Feature Request

Ask the user what feature they want to implement (if not already specified).

### Phase 2: Requirements & Planning

Launch the **feature-planner** agent using the Task tool to:
- Clarify requirements through questions
- Identify edge cases
- Plan test coverage (TDD approach)
- Break down work into phases
- Define acceptance criteria

**Prompt for Task tool**:
```
Analyze this feature request and create an implementation plan: [feature description]

Create a comprehensive plan with:
1. Requirements clarification (ask questions if needed)
2. Edge case identification
3. TDD test plan (tests to write first)
4. Implementation phases
5. Acceptance criteria
```

### Phase 3: Architecture Design (Conditional)

If the feature requires architectural decisions (new abstractions, system structure changes, SOLID principle application), launch the **system-architect** agent.

For complex features, launch feature-planner and system-architect **in parallel** using multiple Task tool calls in a single message.

**Prompt for Task tool**:
```
Design the architecture for: [feature description]

Provide:
1. Component structure and responsibilities
2. Interface/trait definitions
3. SOLID principles application
4. Trade-off analysis
5. Implementation guidance
```

### Phase 4: TDD Implementation

Launch the **implementation-dev** agent using the Task tool to:
- Write failing tests first (RED)
- Implement code to pass tests (GREEN)
- Refactor for quality (REFACTOR)
- Run formatters automatically

**Prompt for Task tool**:
```
Implement this feature following the plan: [reference plan]

Use TDD strictly:
1. Write tests first for each requirement
2. Implement minimal code to pass tests
3. Refactor while keeping tests green
4. Run appropriate formatter (cargo fmt / mvn spotless / go fmt)

Keep code minimal - no over-engineering.
```

### Phase 5: Quality Assurance & Code Review

Launch **qa-tester** and **code-reviewer** agents **in parallel** using multiple Task tool calls.

**Prompt for qa-tester**:
```
Validate the implementation:
1. Run all tests (cargo test / mvn test / go test)
2. Identify untested edge cases
3. Check test coverage
4. Perform integration testing
5. Report issues with severity
```

**Prompt for code-reviewer**:
```
Review the code for quality:
1. Verify SOLID principles (SRP, OCP, LSP, ISP, DIP)
2. Check for over-engineering
3. Identify bugs (null handling, race conditions, logic errors)
4. Validate conventions
5. Report only high-confidence issues (≥80)
```

### Phase 6: Summary & Next Steps

Provide completion summary:
- ✓ Feature implementation status
- ✓ Test count and results
- ✓ Quality assessment
- ✓ Issues found (if any)
- ✓ Ready for commit

Suggest next steps:
- Run `git status` and `git diff` to review changes
- Create commit when ready (user must explicitly request)

## Workflow Guidelines

- Use TodoWrite tool to track progress through phases
- Launch agents in parallel when beneficial (planning+architecture, qa+review)
- Wait for each phase before proceeding to next
- If issues found, launch implementation-dev again to fix
- Follow CLAUDE.md preferences (SOLID, TDD, minimal code)
