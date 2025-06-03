---
trigger: model_decision
description: 
globs: *.tsx,**/*.tsx
---
Functions should use object parameters instead of positional parameters for better maintainability and readability.

Quick Check:
✓ Single primitive (string, number, boolean) → Use positional parameter
✓ Complex type (object, interface, array) → Must use object parameter
✓ Multiple parameters → Must use object parameter
✓ Optional parameters → Must use object parameter

✅ Good Examples:
```typescript
// Single primitive parameter
function handleClick(id: string): void;

// Single complex type
function updateUser({ user }: { user: UserDetails }): void;

// Multiple parameters
function getData({ 
  id,
  options = {},
}: {
  id: string;
  options?: RequestOptions;
}): Promise<Data>;

// React event handlers
onClick: (id: string) => void;                              // primitive OK
onChange: (params: { value: FormData }) => void;            // complex type
onSubmit: (params: { data: SubmitData; id: string }) => void;  // multiple params
```

❌ Bad Examples:
```typescript
// Complex type should use object param
function updateUser(user: UserDetails): void;

// Multiple params should use object param
function getData(id: string, options: RequestOptions = {}): Promise<Data>;

// Optional param should use object param
function fetchItems(id: string, page?: number): Promise<Item[]>;
```

Guidelines:
1. Parameter Type Rules:
   - Primitive types (string, number, boolean): Use positional parameters if single and required
   - Complex types (interfaces, objects, arrays): Always use object parameters, even if single
   - Any combination of multiple parameters: Always use object parameters
   - Any optional parameters: Always use object parameters

2. Documentation:
   - Include TypeScript interface/type definitions for the parameter object
   - Use JSDoc with @param params for the container object
   - Use @param params.propertyName for each property

3. Default Values:
   - Assign default values in the destructuring pattern
   - Example: `function foo({ value = defaultValue }: { value?: string })`