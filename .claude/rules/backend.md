---
paths: backend/**
description: Rules for Go backend development
---

# Backend Rules (Go + Echo)

These rules apply when working on backend code.

## Critical Rules

| Rule | Why | Example |
|------|-----|---------|
| **Use generated types** | Clients expect exact JSON from OpenAPI | Use `api.User`, not `map[string]any` |
| **Never edit generated files** | Hook will block this automatically | Edit `openapi.yaml`, run `make generate` |
| **Verify build before commit** | Catch errors early | `make build && make test` |
| **Handle errors explicitly** | Go convention | `if err != nil { return err }` |

## Project Structure

```
backend/
├── api/
│   ├── openapi.yaml      # API spec (SOURCE OF TRUTH)
│   └── oapi-codegen.yaml # Code generation config
├── cmd/api/
│   └── main.go           # Entry point
├── internal/             # Private packages
│   └── api/generated/    # Generated code (DO NOT EDIT)
└── Makefile              # Build commands
```

## Common Workflows

### Adding a New Endpoint

1. Edit `api/openapi.yaml` - add path and schemas
2. Run `make generate` - regenerates server stubs
3. Implement handler in appropriate package
4. Add tests
5. Verify: `make build && make test`

### Modifying an Endpoint

1. Edit `api/openapi.yaml`
2. Run `make generate`
3. Update handler implementation
4. Update tests
5. Verify: `make build && make test`

## Code Patterns

### Error Handling

```go
// Good
if err != nil {
    return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
}

// Bad
if err != nil {
    panic(err)  // Never panic in handlers
}
```

### Context Usage

```go
// Good - use request context
ctx := c.Request().Context()
result, err := service.DoSomething(ctx, input)

// Bad - using background context
result, err := service.DoSomething(context.Background(), input)
```

### Response Formatting

```go
// Good - use generated types
return c.JSON(http.StatusOK, api.HelloResponse{
    Message: "Hello",
})

// Bad - inline structs
return c.JSON(http.StatusOK, map[string]string{"message": "Hello"})
```

## Makefile Commands

| Command | Purpose |
|---------|---------|
| `make run` | Start development server |
| `make build` | Build binary |
| `make test` | Run tests |
| `make generate` | Regenerate from OpenAPI |
| `make lint` | Run linter |

## Quality Checklist

Before committing backend changes:

- [ ] OpenAPI spec updated if API changed
- [ ] `make generate` run after spec changes
- [ ] `make build` passes
- [ ] `make test` passes
- [ ] Error handling is explicit
- [ ] Context is properly passed
- [ ] Generated types used (not `map[string]any`)
