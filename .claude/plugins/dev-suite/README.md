# Dev Suite - Multi-Agent Development System

A comprehensive development suite with 5 specialized agents for system architecture, feature planning, TDD implementation, QA testing, and code review. Aligned with SOLID principles, Test-Driven Development, and minimal code philosophy.

## Overview

The Dev Suite plugin provides a team of AI agents that work together to guide you through the complete software development lifecycle. Each agent specializes in a specific aspect of development, ensuring quality at every step.

### The Agent Team

1. **System Architect** (Blue, Sonnet) - Designs high-level architecture and applies SOLID principles
2. **Feature Planner** (Cyan, Sonnet) - Creates implementation plans with TDD approach
3. **Implementation Dev** (Green, Haiku) - Executes TDD implementation with minimal code
4. **QA Tester** (Yellow, Haiku) - Validates through comprehensive testing
5. **Code Reviewer** (Red, Sonnet) - Reviews for quality and SOLID compliance

## Quick Start

### Installation

The plugin is automatically discovered from `/Users/mcuento/.claude/plugins/dev-suite/`.

To enable it, add to `/Users/mcuento/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "dev-suite": true
  }
}
```

Or simply restart Claude Code - it will auto-discover plugins in the plugins directory.

### First Use

Try the dev-workflow command:

```
/dev-workflow Add a user registration endpoint
```

The workflow will:
1. Plan the feature (feature-planner)
2. Design architecture if needed (system-architect)
3. Implement with TDD (implementation-dev)
4. Test and validate (qa-tester + code-reviewer)
5. Provide completion summary

## The Agents

### System Architect (Blue)

**Purpose**: Designs system architecture and makes technical decisions

**Use when**:
- Starting new features requiring architectural decisions
- Refactoring existing systems
- Evaluating technology choices or design patterns
- Ensuring SOLID principles are properly applied

**Capabilities**:
- Applies SOLID principles with concrete examples
- Performs trade-off analysis (simplicity vs extensibility)
- Provides language-specific patterns (Rust traits, Java interfaces, Go interfaces)
- Balances good design with minimal code philosophy
- Creates clear, maintainable architectures

**Model**: Sonnet (complex reasoning required)

**Example Triggers**:
- "I need to add a caching layer to the application"
- "Design a plugin system for extensibility"
- "How should I structure the authentication module?"
- "What's the best way to handle multiple payment providers?"

### Feature Planner (Cyan)

**Purpose**: Creates implementation plans with TDD approach

**Use when**:
- User requests a new feature
- Requirements need clarification
- Complex features need breakdown into phases
- Planning test coverage and validation strategy

**Capabilities**:
- Asks targeted clarifying questions
- Identifies edge cases systematically
- Plans test coverage upfront (TDD approach)
- Breaks work into manageable phases
- Defines acceptance criteria
- Identifies risks early

**Model**: Sonnet (requirements analysis required)

**Example Triggers**:
- "Add a REST endpoint for user profile updates"
- "We need better error handling" (asks clarifying questions)
- "Implement OAuth2 authentication with multiple providers"
- "Add rate limiting to all API endpoints"

### Implementation Dev (Green)

**Purpose**: Executes implementation using TDD and minimal code

**Use when**:
- A plan is ready for implementation
- Writing tests and production code
- Following established architecture
- Implementing specific functions or modules

**Capabilities**:
- Follows TDD cycle: Red → Green → Refactor
- Writes tests first, then implementation
- Keeps code minimal (no over-engineering)
- Follows project conventions strictly
- Runs formatters automatically (cargo fmt, mvn spotless, go fmt)
- Self-documenting code (minimal comments)

**Model**: Haiku (fast execution of clear plans)

**Example Triggers**:
- "The plan looks good. Please implement it."
- "Implement the JWT token validation function"
- "Add a new endpoint following the user endpoints pattern"
- "Implement the PaymentProcessor interface for Stripe"

### QA Tester (Yellow)

**Purpose**: Validates implementation through comprehensive testing

**Use when**:
- Code has been implemented and needs validation
- Verifying test completeness
- Identifying untested edge cases
- Integration testing required
- Pre-commit validation needed

**Capabilities**:
- Runs all tests and analyzes results
- Identifies edge case gaps systematically
- Performs integration testing
- Checks test coverage
- Reports issues clearly
- Suggests additional tests

**Model**: Haiku (fast test execution)

**Example Triggers**:
- "The feature is implemented. Can you test it?"
- "Are there any edge cases I'm missing?"
- "I think we're ready to commit" (final validation)
- "Test the OAuth flow end-to-end"

### Code Reviewer (Red)

**Purpose**: Reviews code for SOLID principles and quality

**Use when**:
- Code review needed before committing
- Verifying SOLID principles application
- Checking for over-engineering
- Ensuring minimal code philosophy is followed

**Capabilities**:
- Verifies each SOLID principle with confidence scoring
- Enforces minimal code philosophy
- Reports only high-confidence issues (≥80)
- Detects premature abstractions
- Identifies bugs (logic errors, null handling, race conditions)
- Provides actionable feedback with file:line references

**Model**: Sonnet (judgment and pattern recognition required)

**Example Triggers**:
- "I've implemented the feature. Can you review it?"
- "Let's review before committing"
- "Am I over-engineering this?"
- "Does this design properly apply SOLID principles?"

## Understanding Plugin Commands

**Important**: Plugin commands in Claude Code are **namespaced** with the plugin name to avoid conflicts:

- ✓ Correct: `/dev-suite:dev-workflow`
- ✗ Incorrect: `/dev-workflow`

This is different from project-local commands in `.claude/commands/` which don't use namespacing.

## Orchestration Commands

### /dev-suite:dev-workflow

**Purpose**: Complete feature development lifecycle

**Usage**:
```
/dev-suite:dev-workflow
```

The command will ask what feature you want to implement.

**What it does**:
1. **Requirements & Planning**: Launches feature-planner to clarify and plan
2. **Architecture** (if needed): Launches system-architect to design structure
3. **Implementation**: Launches implementation-dev to execute with TDD
4. **Quality Assurance**: Launches qa-tester to validate comprehensively
5. **Code Review**: Launches code-reviewer to check quality
6. **Summary**: Provides completion report

**Parallel Execution**:
- Planning + Architecture (for complex features)
- QA Testing + Code Review (for validation)

**Example**:
```
/dev-suite:dev-workflow
```
Then when prompted: "Add email validation to user registration"

### /dev-suite:design-review

**Purpose**: Architecture and design quality review

**Usage**:
```
/dev-suite:design-review
```

The command will ask what scope to review (full project, directory, or file).

**What it does**:
1. **Architecture Analysis**: Launches system-architect to evaluate structure
2. **SOLID Verification**: Launches code-reviewer to check all principles
3. **Simplicity Check**: Identifies over-engineering and premature abstractions
4. **Recommendations**: Provides prioritized improvements with specific fixes

**Example**:
```
/dev-suite:design-review
```
Then when prompted: "Review src/payment/ module"

**Note**: Commands require the `/dev-suite:` prefix. However, individual agents still trigger **proactively** based on context without needing commands - just describe what you want naturally.

## Proactive Triggering

Agents automatically activate based on context - you don't need to explicitly name them:

**Example 1**:
```
User: "I need to design a plugin system"
Claude: (automatically activates system-architect agent)
```

**Example 2**:
```
User: "Are there edge cases I'm missing?"
Claude: (automatically activates qa-tester agent)
```

**Example 3**:
```
User: "Am I over-engineering this?"
Claude: (automatically activates code-reviewer agent)
```

## Model Assignments

**Sonnet** (Complex Reasoning):
- **system-architect**: Architectural thinking required
- **feature-planner**: Requirements analysis needed
- **code-reviewer**: Pattern recognition and judgment

**Haiku** (Fast Execution):
- **implementation-dev**: Executes clear plans quickly
- **qa-tester**: Runs tests and validates quickly

This mixed approach balances cost and performance.

## Integration with CLAUDE.md

All agents are configured to follow your preferences from `/Users/mcuento/.claude/CLAUDE.md`:

**SOLID Principles**:
- system-architect: Designs with SOLID
- code-reviewer: Verifies SOLID application
- All agents: Reference SOLID in decisions

**TDD Approach**:
- feature-planner: Plans test coverage upfront
- implementation-dev: Follows TDD cycle (test first)
- qa-tester: Validates test quality

**Minimal Code Philosophy**:
- implementation-dev: Avoids over-engineering
- code-reviewer: Flags unnecessary complexity
- All agents: Keep solutions simple

**Language Support**:
- **Rust**: Traits, ownership, cargo fmt, cargo test
- **Java**: Interfaces, Optional, mvn spotless, JUnit
- **Go**: Interfaces, error handling, go fmt, go test

**Formatters (Auto-Permission)**:
- `cargo fmt` for Rust
- `mvn spotless:apply` for Java
- `go fmt` for Go

## Agent Interaction Patterns

### Parallel Execution

**Planning Phase** (complex features):
```
feature-planner + system-architect → Run simultaneously
```

**Validation Phase** (all features):
```
qa-tester + code-reviewer → Run simultaneously
```

### Sequential Dependencies

```
1. system-architect → implementation-dev (design first)
2. feature-planner → implementation-dev (plan first)
3. implementation-dev → qa-tester (implement first)
4. qa-tester → code-reviewer (test first)
```

## Workflow Examples

### Example 1: Simple Feature

```
User: /dev-workflow Add email validation to user registration

→ feature-planner: Creates plan with test cases for valid/invalid formats
→ implementation-dev: Writes tests first, implements validator
→ qa-tester + code-reviewer: Validate in parallel
✓ Complete: All tests pass, no issues found, ready to commit
```

### Example 2: Complex Feature

```
User: /dev-workflow Implement OAuth2 with Google and GitHub

→ feature-planner + system-architect: Plan and design in parallel
  - feature-planner: Breaks into phases, identifies edge cases
  - system-architect: Designs provider abstraction, SOLID approach
→ implementation-dev: Implements OAuth2Provider trait with TDD
→ qa-tester: Tests both providers, integration flow
→ code-reviewer: Verifies SOLID, no over-engineering
✓ Complete: Architecture solid, tests comprehensive, ready to commit
```

### Example 3: Design Review

```
User: /design-review src/payment/

→ system-architect: Analyzes payment module architecture
  ✓ Good: Clear separation of concerns
  ⚠ Issue: PaymentProcessor uses switch on type (OCP violation)

→ code-reviewer: Verifies SOLID principles
  - SRP: ✓ Each class has single responsibility
  - OCP: ⚠ Switch statement (Confidence: 90)
  - DIP: ⚠ Depends on concrete Gateway (Confidence: 85)

Recommendations:
1. Replace switch with strategy pattern (high priority)
2. Inject gateway via interface (high priority)
3. Consider splitting processor for each provider

Estimated effort: 2-3 hours
```

## Best Practices

### When to Use Each Agent

**system-architect**:
- New features with architectural impact
- Refactoring large modules
- Technology or pattern decisions
- Designing abstractions

**feature-planner**:
- Any new feature (simple or complex)
- Clarifying vague requirements
- Planning test coverage
- Breaking down large work

**implementation-dev**:
- Executing approved plans
- Writing code with TDD
- Following established patterns
- Implementing specific components

**qa-tester**:
- After implementation complete
- Before committing changes
- Finding edge case gaps
- Integration testing

**code-reviewer**:
- Before every commit
- Checking SOLID compliance
- Identifying over-engineering
- Final quality gate

### Workflow Recommendations

**For New Features**:
1. Use `/dev-workflow` for guided process
2. Let agents work in parallel when possible
3. Address issues before moving to next phase

**For Refactoring**:
1. Run `/design-review` first to understand issues
2. Use system-architect to design improved structure
3. Use implementation-dev for incremental changes
4. Validate with qa-tester and code-reviewer

**For Bug Fixes**:
- Simple bugs: Implement directly, skip workflow
- Complex bugs: Use feature-planner to understand scope
- Always validate with qa-tester before committing

**For Code Reviews**:
- Use code-reviewer before every commit
- Focus on high-confidence issues (≥80)
- Address SOLID violations promptly
- Remove over-engineering when identified

## Confidence Scoring

The **code-reviewer** agent uses confidence scoring to reduce noise:

- **90-100**: Definite issue, clear violation or bug → Always report
- **80-89**: Strong evidence, highly likely problem → Report
- **70-79**: Probable issue, context dependent → Don't report
- **<70**: Speculative or subjective → Don't report

This ensures you only see issues that truly matter.

## Troubleshooting

### Agents Not Triggering

**Problem**: Agent doesn't activate when expected

**Solutions**:
- Describe the task more explicitly
- Mention the agent's area (e.g., "design the architecture")
- Use orchestration commands (/dev-workflow, /design-review)

### Wrong Agent Activates

**Problem**: Different agent than expected activates

**Solution**: The agent that activated is likely more appropriate for the context. Trust the system's judgment or explicitly request a different agent.

### Agents Disagree

**Problem**: Different agents give conflicting advice

**Solution**: This is intentional - different perspectives. Use:
- system-architect: For architectural truth
- code-reviewer: For quality/SOLID truth
- feature-planner: For requirements truth
- Your judgment: To balance tradeoffs

## Language-Specific Features

### Rust

- **Architecture**: Trait-based design, ownership patterns
- **Testing**: `#[test]`, `#[cfg(test)]`, property testing
- **Formatting**: `cargo fmt` (automatic)
- **Error Handling**: Result/Option patterns
- **SOLID**: Trait composition, newtype pattern

### Java

- **Architecture**: Interface-based design, dependency injection
- **Testing**: JUnit 5, Mockito, AssertJ
- **Formatting**: `mvn spotless:apply` (automatic)
- **Error Handling**: Optional, exception hierarchy
- **SOLID**: Interface segregation, composition over inheritance

### Go

- **Architecture**: Small interfaces, composition via embedding
- **Testing**: Table-driven tests, `testing` package
- **Formatting**: `go fmt` (automatic)
- **Error Handling**: Explicit error returns
- **SOLID**: Implicit interfaces, functional options

## Version and Compatibility

- **Version**: 1.0.0
- **Claude Code**: Compatible with current version
- **Languages**: Rust, Java, Go (optimized for these, works with others)
- **Dependencies**: None (standalone plugin)

## Contributing

To modify or extend this plugin:

1. **Add New Agent**: Create `agents/agent-name.md` with frontmatter and system prompt
2. **Add Command**: Create `commands/command-name.md` with orchestration logic
3. **Test Changes**: Restart Claude Code to reload plugin
4. **Verify Triggering**: Test that agents activate on appropriate prompts

## Support

For issues or questions:
- Check this README for usage patterns
- Verify plugin is enabled in settings.json
- Restart Claude Code if agents don't activate
- Review agent frontmatter for triggering examples

## Summary

The Dev Suite provides a complete multi-agent development system that:

✓ **Guides** you through the development lifecycle
✓ **Enforces** SOLID principles and TDD approach
✓ **Prevents** over-engineering via minimal code philosophy
✓ **Validates** quality through comprehensive testing and review
✓ **Optimizes** performance with mixed model strategy (Haiku + Sonnet)
✓ **Integrates** seamlessly with your CLAUDE.md preferences

Five specialized agents work together to ensure quality at every step, from architecture design to final code review, all while keeping code simple, testable, and maintainable.

**Get started**: `/dev-workflow your-feature-description`
