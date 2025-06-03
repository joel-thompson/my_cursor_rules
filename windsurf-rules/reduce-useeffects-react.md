---
trigger: glob
globs: **/*.tsx, *.tsx
---

# useEffect Usage Rule

## ❌ DON'T use useEffect for:

- **Transforming data for rendering**
  ```js
  // ❌ Bad
  const [fullName, setFullName] = useState('');
  useEffect(() => {
    setFullName(firstName + ' ' + lastName);
  }, [firstName, lastName]);
  
  // ✅ Good
  const fullName = firstName + ' ' + lastName;
  ```

- **Caching expensive calculations** (use `useMemo` instead)
  ```js
  // ❌ Bad
  useEffect(() => {
    setFilteredList(expensiveFilter(items));
  }, [items]);
  
  // ✅ Good
  const filteredList = useMemo(() => expensiveFilter(items), [items]);
  ```

- **Handling user events**
  ```js
  // ❌ Bad
  useEffect(() => {
    if (product.isInCart) showNotification();
  }, [product]);
  
  // ✅ Good - in event handler
  function handleBuyClick() {
    addToCart(product);
    showNotification();
  }
  ```

- **Resetting component state** (use `key` prop instead)
  ```js
  // ❌ Bad
  useEffect(() => {
    setComment('');
  }, [userId]);
  
  // ✅ Good
  <Profile key={userId} userId={userId} />
  ```

- **Updating parent component state**
  ```js
  // ❌ Bad
  useEffect(() => {
    onChange(isOn);
  }, [isOn, onChange]);
  
  // ✅ Good - update both in event handler
  function handleToggle() {
    setIsOn(!isOn);
    onChange(!isOn);
  }
  ```

## ✅ DO use useEffect for:

- **Synchronizing with external systems**
  - Third-party widgets (jQuery, D3, etc.)
  - Browser APIs (subscriptions, timers)
  - Network requests
  - WebSocket connections

- **Side effects that happen because component was displayed**
  ```js
  // ✅ Good - runs because component mounted
  useEffect(() => {
    logAnalytics('page_view');
  }, []);
  ```

- **Cleanup operations**
  ```js
  // ✅ Good - cleanup subscriptions
  useEffect(() => {
    const subscription = subscribe();
    return () => subscription.cleanup();
  }, []);
  ```

## Key Questions to Ask:

1. **"Is this caused by a user interaction?"** → Use event handler
2. **"Can this be calculated from existing state/props?"** → Calculate during render
3. **"Am I synchronizing with something outside React?"** → Use useEffect