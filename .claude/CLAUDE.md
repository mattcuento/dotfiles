# Claude Configuration

This file contains preferences and guidelines for how Claude should work with me.

## Communication Style

**Preference: Detailed Explanations**

- Provide thorough explanations of decisions and approaches
- Explain the reasoning behind code choices
- Describe what you're doing and why before doing it
- Walk through your thought process for complex problems
- When you find issues or patterns, explain what you discovered
- After making changes, explain what was changed and why

## Approval & Planning

**Preference: Use Plan Mode Often**

- Enter plan mode for non-trivial implementation tasks
- Present a plan before making significant changes
- Allow me to review and approve the approach before proceeding
- Use plan mode when:
  - Adding new features
  - Refactoring existing code
  - Making architectural decisions
  - Changes that affect multiple files
  - Anything beyond simple bug fixes

## Coding Style

**Preference: Minimal/Clean Code**

- **Simplicity first**: Prefer simple, straightforward solutions
- **Avoid over-engineering**: Don't add features or abstractions that weren't requested
- **No premature optimization**: Only optimize when there's a clear need
- **Minimal abstractions**: Three similar lines of code is better than a premature abstraction
- **No unnecessary comments**: Code should be self-documenting; only add comments where logic isn't self-evident
- **No extra features**: Stick to exactly what was requested
- **Delete unused code**: Remove it completely rather than commenting it out or using compatibility hacks
- **Trust internal code**: Don't add defensive checks for scenarios that can't happen
- **Keep it focused**: A bug fix should just fix the bug, not refactor surrounding code

### What NOT to Add Unless Requested
- Extra error handling for impossible scenarios
- Feature flags or configuration options
- Helper functions for one-time operations
- Type annotations to unchanged code
- Docstrings or comments to existing code
- Validation for internal/trusted code

## Design Principles

**Requirement: SOLID Principles**

Apply SOLID principles consistently across all code:

- **Single Responsibility**: Each class/module should have one reason to change. When designing features, identify clear boundaries and responsibilities.
- **Open/Closed**: Extend behavior through interfaces/traits rather than modifying existing code. Consider extension points during architecture.
- **Liskov Substitution**: Subtypes must be substitutable for their base types. Ensure polymorphic code works with all implementations.
- **Interface Segregation**: Create focused interfaces rather than large, monolithic ones. Split interfaces when clients need different subsets.
- **Dependency Inversion**: Depend on abstractions, not concretions. Use dependency injection and define clear interfaces.

**Balance with Minimal Code Philosophy**: Apply SOLID where it adds clear value. Don't create abstractions prematurely - wait until you have 2-3 concrete use cases. SOLID guides structure; minimalism guides when to add that structure.

**Inline Architecture Guidance**: During planning, provide concise explanations of architectural decisions inline (2-3 sentences). Explain trade-offs, why a particular pattern fits, and how it aligns with SOLID. No separate design documents.

## Development Methodology

**Preference: Test-Driven Development (Default)**

- **By default, use TDD**: Write tests first, then implement to make them pass
- **When writing tests first**:
  - New features and functionality
  - Refactoring existing code
  - Bug fixes where test coverage helps prevent regression
  - Complex business logic that benefits from examples
  - API or interface design (tests document usage)

**When to be flexible with TDD**:
- **Quick bug fixes**: If the bug is trivial and a test would take longer than the fix
- **Prototyping**: When exploring ideas or proof-of-concepts before committing to design
- **Emergency fixes**: Production issues where speed matters most
- **Spike work**: Investigating feasibility or technical approaches
- **Scripts/tooling**: One-off scripts or simple automation that don't need formal testing

**Testing approach**:
- Write clear, focused tests that document intent
- Test behavior, not implementation details
- Use descriptive test names that explain the scenario
- Prefer integration tests for end-to-end workflows, unit tests for complex logic
- Don't test framework code or trivial getters/setters

**When skipping TDD**: Briefly explain why (e.g., "This is a trivial bug fix, writing test first would be overkill" or "Prototyping approach before committing to design").

## Code Formatting

**Auto-formatting: Enabled**

Code formatting is automated and runs without approval. Formatters are configured per language:

**Rust**: `cargo fmt`
- Runs automatically on Rust projects
- Uses project's `rustfmt.toml` if present, otherwise defaults
- Standard Rust formatting conventions

**Java**: `mvn spotless:apply` + `checkstyle`
- Maven Spotless for code formatting
- Checkstyle for style validation
- Configured via project's `pom.xml` and checkstyle rules
- Runs spotless:apply to auto-fix formatting issues

**Go**: `go fmt` (or `gofmt`)
- Standard Go formatting tool
- Runs automatically on Go projects
- Non-configurable by design (Go convention)

**Formatter behavior**:
- Run formatters automatically before committing code
- If formatter fails, explain the error and how to fix it
- Don't ask permission to run formatters - they're pre-approved
- If a project doesn't have formatter config, use language defaults

## Git Operations

**Preference: Ask Before Committing**

- Never commit automatically
- Only create commits when I explicitly ask
- Before committing:
  - Show me what will be committed (git status, git diff)
  - Explain the changes being committed
  - Draft a commit message for my review
  - Wait for my approval before running git commit
- Follow these commit message guidelines:
  - Keep it concise (1-2 sentences)
  - Focus on the "why" rather than the "what"
  - Match the style of recent commits in the repo
  - Always include: `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>`

## General Guidelines

### Do:
- Read files before modifying them
- Follow existing project conventions and patterns
- Test changes when appropriate
- Explain your reasoning and approach
- Ask clarifying questions when requirements are unclear
- Use todo lists to track progress on multi-step tasks
- Search and explore the codebase to understand context

### Don't:
- Make assumptions about code you haven't read
- Add features or improvements beyond what was requested
- Commit changes without explicit permission
- Over-engineer solutions
- Add unnecessary abstraction layers
- Create new files unless absolutely necessary (prefer editing existing files)
- Skip explanations - I want to understand what you're doing

## Workflow Preferences

1. **For new features**: Enter plan mode, explain the approach, get approval, then implement
2. **For bug fixes**: Investigate, explain what you found, propose a fix, implement after I understand
3. **For refactoring**: Show me the current state, propose the refactored approach, explain the benefits
4. **For exploration**: Search thoroughly, read relevant files, explain what you discovered

## Tool Usage

- Use TodoWrite to track multi-step tasks
- Prefer specialized tools (Read, Edit, Write) over bash commands for file operations
- Use parallel operations when possible for efficiency
- Enter plan mode proactively for complex work

---

*This configuration helps Claude work in a way that matches my preferences and workflow.*
