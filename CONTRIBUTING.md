# Contributing to VyavsayPro

We love your input! We want to make contributing to VyavsayPro as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

1. Fork the repo and create your branch from `develop`
2. If you've added code that should be tested, add tests
3. If you've changed APIs, update the documentation
4. Ensure the test suite passes
5. Make sure your code follows the project style guide
6. Issue that pull request!

## Pull Request Process

1. Update the README.md with details of changes if needed
2. Follow the PR template provided
3. You may merge the Pull Request once you have the sign-off of at least one other developer
4. Use conventional commit messages:
   - feat: (new feature)
   - fix: (bug fix)
   - docs: (documentation)
   - style: (formatting, missing semicolons, etc)
   - refactor: (refactoring code)
   - test: (adding tests)
   - chore: (updating grunt tasks etc)

## Code Style Guidelines

- Follow the Flutter style guide
- Use meaningful variable and function names
- Write comments for complex logic
- Keep functions small and focused
- Use proper formatting (run `dart format .`)

## Firebase Guidelines

1. **Security Rules**
   - Always test security rules before deployment
   - Never disable authentication in production
   - Use minimal necessary permissions

2. **Data Structure**
   - Follow the agreed-upon data structure
   - Use proper data types
   - Include timestamps for created/updated fields

3. **Queries**
   - Optimize queries for performance
   - Use proper indexes
   - Limit query results appropriately

## Testing Guidelines

1. Write tests for:
   - New features
   - Bug fixes
   - Complex logic
   - Edge cases

2. Types of Tests:
   - Unit tests for business logic
   - Widget tests for UI components
   - Integration tests for feature flows

## Issue Guidelines

1. Use issue templates when available
2. Include:
   - Steps to reproduce (for bugs)
   - Expected behavior
   - Actual behavior
   - Screenshots if applicable
   - Device/environment information

## Branch Strategy

1. Main Branches:
   - `main`: Production code
   - `develop`: Development branch

2. Supporting Branches:
   - Feature: `feature/feature-name`
   - Bugfix: `fix/bug-name`
   - Release: `release/version`
   - Hotfix: `hotfix/issue`

3. Branch Naming:
   - Use lowercase
   - Use hyphens for spaces
   - Be descriptive but concise

## Environment Setup

1. Install required tools:
   - Flutter SDK
   - Android Studio/VS Code
   - Firebase CLI
   - Git

2. Configure Firebase:
   - Get configuration files from team lead
   - Never commit Firebase config files
   - Use proper environment configurations

## Code Review Guidelines

1. Aspects to Review:
   - Code functionality
   - Code style
   - Test coverage
   - Documentation
   - Performance implications
   - Security implications

2. Review Process:
   - Use GitHub's review features
   - Be constructive and respectful
   - Approve only when satisfied
   - Request changes if needed

## License

By contributing, you agree that your contributions will be licensed under the same license that covers the project.

## Questions?

Contact the project maintainers for any questions about contributing.